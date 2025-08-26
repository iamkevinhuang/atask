class ApplicationController < ActionController::API
  def get_token
    request.headers["Authorization"]&.split(" ")&.last
  end

  def authenticate_user!
    token = get_token
    @current_user = UserSession.find_by(auth_token: token)&.user if token

    render json: { error: I18n.t("session.errors.unauthorized") }, status: :unauthorized and return unless @current_user
  end

  def pagination_helper(records, blueprint_object, limit, current_page)
    limit = limit ? limit.to_i : 20
    current_page = current_page ? current_page.to_i : 1

    total = records.size
    total_page = (records.size / limit.to_f).ceil

    return { error: I18n.t("helper.errors.invalid_limit_or_current_page") }, 422 if limit < 1 || current_page < 1

    records = records.offset((current_page - 1) * limit).limit(limit)

    [ {
      paging: {
        total:,
        count: if current_page == total_page
                 (total % limit).zero? ? limit : total % limit
               else
                 current_page > total_page ? 0 : limit
               end,
        per_page: limit,
        current_page:,
        total_page:
      },
      data: blueprint_object.render_as_hash(records)
    }, 200 ]
  end
end

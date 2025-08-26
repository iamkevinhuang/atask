# frozen_string_literal: true

class WalletBlueprint < Blueprinter::Base
  identifier :id

  field :balance do |wallet|
    wallet.balance.to_f
  end

  field :owner do |wallet|
    case wallet.owner
    when User
      UserBlueprint.render_as_hash(wallet.owner)
    when Team
      TeamBlueprint.render_as_hash(wallet.owner)
    else
      nil
    end
  end
end

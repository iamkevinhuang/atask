class CreateUserSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.text :auth_token
      t.text :user_agent

      t.timestamps
    end
  end
end

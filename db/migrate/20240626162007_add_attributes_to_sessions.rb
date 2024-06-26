class AddAttributesToSessions < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :token, :string
    add_column :sessions, :user_id, :integer

    add_index :sessions, :user_id
    add_foreign_key :sessions, :users, column: :user_id
  end
end

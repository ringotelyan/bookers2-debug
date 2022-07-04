class CreateGroupUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_users do |t|
      t.references :user_id
      t.references :group_id

      t.timestamps
    end
  end
end

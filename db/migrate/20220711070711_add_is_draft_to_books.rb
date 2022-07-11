class AddIsDraftToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :is_draft, :boolean, null: false, default: false
  end
end

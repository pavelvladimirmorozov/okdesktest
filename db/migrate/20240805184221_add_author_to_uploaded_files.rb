class AddAuthorToUploadedFiles < ActiveRecord::Migration[7.1]
  def change
    add_column :uploaded_files, :author_account, :string, null: false
    add_column :uploaded_files, :author_api_key, :string, null: false
    add_reference(:uploaded_files, :author, index: true, foreign_key: { to_table: :users })
  end
end

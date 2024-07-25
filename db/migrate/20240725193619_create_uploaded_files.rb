class CreateUploadedFiles < ActiveRecord::Migration[7.1]
  def change
    create_table :uploaded_files do |t|
      t.string :name
      t.string :content_type
      t.integer :size

      t.timestamps
    end
  end
end

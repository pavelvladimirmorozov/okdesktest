class CreateUploadedCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :uploaded_companies do |t|
      t.belongs_to :uploaded_file, null: true, foreign_key: true

      t.string :name
      t.string :additional_name
      t.string :site
      t.string :email
      t.string :phone
      t.string :address
      t.float :coordinates_x
      t.float :coordinates_y
      t.string :comment
      t.string :category_code
      t.boolean :active
      t.integer :request_status
      t.boolean :request_success

      t.timestamps
    end
  end
end

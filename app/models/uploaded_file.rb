class UploadedFile < ApplicationRecord
  has_many :uploaded_companies
  belongs_to :author, class_name: "User", foreign_key: "author_id"
end

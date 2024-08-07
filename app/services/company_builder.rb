class CompanyBuilder 
  def self.from_hash(company)
    UploadedCompany.new name: company['name'],
      additional_name: company['additional_name'],
      site: company['site'],
      email: company['email'],
      phone: company['phone'],
      address: company['address'],
      coordinates_x: company['coordinates'].nil? ? nil : company['coordinates'][0],
      coordinates_y: company['coordinates'].nil? ? nil : company['coordinates'][1],
      comment: company['comment'],
      category_code: company['category_code'],
      active: company['active'],
      request_status: company['request_status'],
      request_success: company['request_success'],
      created_at: company['created_at'],
      updated_at: company['updated_at']
  end
end
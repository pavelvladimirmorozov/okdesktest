require('json')

class OkdeskApiService < BaseApiService

  def create_company (company)
    response = connection.post("companies/", company.to_json);

    if response.success?
      company = CompanyBuilder.from_hash JSON.parse(response.body)
    end

    company.request_success = response.success?
    company.request_status = response.status

    return company
  end

  def get_companies()
    response = @connection.get("companies/list/");

    if response.success?
      return JSON.parse(response.body, object_class: Array).map { |company| CompanyBuilder.from_hash company }
    end

    return nil
  end
  
end


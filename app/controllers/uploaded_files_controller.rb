require("faraday")
require("json")

class UploadedFilesController < ApplicationController
  def index
    @pagy, @files = pagy UploadedFile.order created_at: :asc
  end

  def show
    @file = UploadedFile.find(params[:id])
    @pagy, @companies = pagy @file.uploaded_companies.order created_at: :asc
  end
  
  def create
    if params[:file].present?
      
      db_file = UploadedFile.create file_params

      parsed_companies = XlsxParseService.call params[:file]
      
      conn = Faraday.new(
        url: 'https://pvmorozov.testokdesk.ru/api/v1',
        params: { api_token: '14db65d12b43a84a13ac5833923b5337d165a4d4' },
        headers: {'Content-Type' => 'application/json'}
      )

      parsed_companies.each do |company|
        response = conn.post("companies/", company.to_json);

        if response.success?
          @result = company_from JSON.parse(response.body)
          company = @result
        end
        company.request_success = response.success?
        company.request_status = response.status

        db_file.uploaded_companies << company
        db_file.save
      end
      
      flash[:success] = "Companies imported! #{@result.name}"
    end

    redirect_to root_path
  end
  
  private

  def file_params
    file = params[:file]
    { content_type: file.content_type, size: file.size, name: file.original_filename }
  end

  def company_from(company)
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

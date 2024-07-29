require("faraday")
require("json")

class UploadedFilesController < ApplicationController
  def index
    @files = UploadedFile.all
  end

  def show
    @file = UploadedFile.find(params[:id])
    @companies = @file.uploaded_companies.order created_at: :asc
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
          company = JSON.parse(response.body)
        end
        company[:request_success] = response.success?
        company[:request_status] = response.status

        db_company = db_file.uploaded_companies.build company_params(company)
        db_company.save
      end
      
      flash[:success] = "Companies imported! #{parsed_companies.to_json}"
    end

    redirect_to root_path
  end
  
  private

  def file_params
    file = params[:file]
    { content_type: file.content_type, size: file.size, name: file.original_filename }
  end

  def company_params(company)
    {
      name: company[:uploaded_file_id],
      additional_name: company[:uploaded_file_id],
      site: company[:uploaded_file_id],
      email: company[:uploaded_file_id],
      phone: company[:uploaded_file_id],
      address: company[:uploaded_file_id],
      coordinates_x: company[:uploaded_file_id],
      coordinates_y: company[:uploaded_file_id],
      comment: company[:uploaded_file_id],
      category_code: company[:uploaded_file_id],
      active: company[:uploaded_file_id],
      request_status: company[:uploaded_file_id],
      request_success: company[:uploaded_file_id],
      created_at: company[:uploaded_file_id],
      updated_at: company[:uploaded_file_id],
    }
  end
end

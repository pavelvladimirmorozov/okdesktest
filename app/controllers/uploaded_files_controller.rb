require("faraday")
require("json")

class UploadedFilesController < ApplicationController
  before_action :require_authentication, only: %i[index show create]
  before_action :require_okdesk_account, only: %i[index show create]
  
  def index
    @pagy, @files = pagy UploadedFile.where(author_id: @current_user.id)
      .order created_at: :asc
  end

  def show
    file = UploadedFile.find(params[:id])
    if file.author_id != @current_user.id
      redirect_to root_path
    end
    @file = file
    @pagy, @companies = pagy @file.uploaded_companies.order created_at: :asc
  end
  
  def create
    if params[:file].present?
      db_file = UploadedFile.create file_params

      parsed_companies = XlsxParseService.call params[:file]
      
      conn = Faraday.new(
        url: "https://#{@current_user.okdesk_account}.testokdesk.ru/api/v1",
        params: { api_token: @current_user.okdesk_api_key },
        headers: {'Content-Type' => 'application/json'}
      )

      parsed_companies.each do |company|
        response = conn.post("companies/", company.to_json);

        if response.success?
          company = company_from JSON.parse(response.body)
        end
        company.request_success = response.success?
        company.request_status = response.status

        db_file.uploaded_companies << company
        db_file.save
      end
      
      flash[:success] = "Companies imported! #{db_file.name}"
    end

    redirect_to root_path
  end
  
  private

  def require_okdesk_account
    if @current_user.okdesk_account.nil? || @current_user.okdesk_account.empty? || 
      @current_user.okdesk_api_key.nil? || @current_user.okdesk_api_key.empty?
     flash[:warning] = "OKDESK account or API key is missing"
     redirect_to edit_user_path @current_user.id
   end
  end

  def file_params
    file = params[:file]
    { 
      content_type: file.content_type, 
      size: file.size, 
      name: file.original_filename,
      author_account: @current_user.okdesk_account,
      author_api_key: @current_user.okdesk_api_key,
      author_id: @current_user.id
    }
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

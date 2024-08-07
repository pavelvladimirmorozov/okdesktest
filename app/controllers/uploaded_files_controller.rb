class UploadedFilesController < ApplicationController
  before_action :require_authentication, only: %i[index show create]
  before_action :require_okdesk_account, only: %i[create]
  
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
      
      api_service = OkdeskApiService.new @current_user

      parsed_companies.each do |company|
        company = api_service.create_company company

        db_file.uploaded_companies << company
        db_file.save
      end
      
      flash[:success] = "Companies imported! #{db_file.name}"
    end

    redirect_to uploaded_files_path
  end
  
  private

  def require_okdesk_account
    if @current_user.okdesk_account.nil? || @current_user.okdesk_account.empty? || 
      @current_user.okdesk_api_key.nil? || @current_user.okdesk_api_key.empty?
     flash[:warning] = "OKDESK account or API key is missing. Please fill missing fields"
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
end

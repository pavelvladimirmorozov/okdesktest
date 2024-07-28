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

      parsed_companies.each do |company|
        db_company = db_file.uploaded_companies.build company
        db_company.save
      end
      
      flash[:success] = "File with companies uploaded!"
    end

    redirect_to root_path
  end
  
  private



  def file_params
    file = params[:file]
    { content_type: file.content_type, size: file.size, name: file.original_filename }
  end
end

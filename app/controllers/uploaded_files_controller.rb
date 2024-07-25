class UploadedFilesController < ApplicationController
  def index
    @files = UploadedFile.all
  end

  def show
    @file = UploadedFile.find(params[:id])
  end
  
  def create

  end
  
  private

  def file_params
    params.require(:UploadedFile).permit(:name, :address, :legal_form, :tin)
  end
end

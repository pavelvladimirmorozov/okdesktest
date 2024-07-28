class XlsxParseService < ApplicationService
  attr_reader :file

  def initialize(file_param)
    @file = file_param
  end

  def call
    companies_from(@file)
  end

  private

  def companies_from(file)
    sheet = RubyXL::Parser.parse_buffer(file.read)[0]
    sheet.map do |row|
      cells = row.cells[0..3].map { |c| c&.value.to_s }
      { 
        name: cells[0],
        additional_name: cells[1],
        site: cells[2],
        email: cells[3],
        phone: cells[4],
        address: cells[5],
        coordinates_x: cells[6],
        coordinates_y: cells[7],
        comment: cells[8],
        category_code: cells[9],
        active: cells[10],
        request_status: cells[11],
        request_success: cells[12]
      }
    end
  end
end
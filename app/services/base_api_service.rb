require("faraday")

class BaseApiService
  def initialize(user)
    @connection = Faraday.new(
      url: "https://#{user.okdesk_account}.testokdesk.ru/api/v1",
      params: { api_token: user.okdesk_api_key },
      headers: {'Content-Type' => 'application/json'}
    )
  end

  def crate_company(params)
    connection.post(PATH, params)
  end

  private

  attr_reader :connection
end
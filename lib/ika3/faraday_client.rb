# frozen_string_literal: true

require_relative 'response'

module Ika3
  class FaradayClient
    BASE_URL = 'https://spla3.yuu26.com/'

    def initialize(contact)
      @user_agent = "Ika3Gem/#{Ika3::VERSION}(#{contact})"
    end

    def get(path)
      response = connection.get(path)
      raise ApiError, "API Error: #{response.status}" unless response.success?

      Response.new(response)
    rescue Faraday::Error => e
      raise ApiError, "Connection Error: #{e.message}"
    end

    private

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |conn|
        conn.request :json
        conn.response :json
        conn.headers['User-Agent'] = @user_agent
        conn.adapter Faraday.default_adapter
      end
    end
  end
end

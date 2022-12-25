class Hash
  def method_missing(name)
    return self[name].extend Hash if key? name

    each { |k, v| return v if k.to_s.to_sym == name }
    super.method_missing(name)
  end
end

module Ika3
  class Schedule
    class << self
      def regular_now
        @regular_now_obj ||= send_request(:get, "/api/regular/now").body.results[0]
      end

      def send_request(method, path, params = nil, headers = nil)
        response = splat3_connection.send(method, path, params, headers)
        Ika3::Response.new(response)
      end

      private

      def api_url
        "https://spla3.yuu26.com/"
      end

      def splat3_connection
        @splat3_connection ||= Faraday::new(faraday_options) do |c|
          c.request :json
          c.response :json
          c.adapter Faraday.default_adapter
        end
      end

      def faraday_options
        { url: api_url }
      end
    end
  end
end

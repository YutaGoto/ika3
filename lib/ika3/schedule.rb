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
      modes = ["regular", "bankara_challenge", "bankara_open", "x"]

      modes.each do |mode|
        define_method("#{mode}_now".to_sym) do
          return instance_variable_get("@#{mode}_now_obj") if instance_variable_defined?("@#{mode}_now_obj")

          instance_variable_set("@#{mode}_now_obj", send_request(:get, "/api/#{mode.dasherize}/now").body.results[0])
        end
      end

      def salmon_run_now
        @salmon_run_now ||= send_request(:get, "/api/coop-grouping/now").body.results[0]
      end

      private

      def send_request(method, path, params = nil, headers = nil)
        response = splat3_connection.send(method, path, params, headers)
        Ika3::Response.new(response)
      end

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

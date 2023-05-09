# frozen_string_literal: true

class Hash
  def respond_to_missing?(sym)
    key? name ? true : super
  end

  def method_missing(name)
    return self[name] if key? name

    each { |k, v| return v if k.to_s.to_sym == name }
    super.method_missing(name)
  end
end

module Ika3
  class Schedule
    def initialize(contact)
      @contact = contact
    end

    modes = %w[regular bankara_challenge bankara_open x fest]
    schedules = %w[now next]

    schedules.each do |schedule|
      modes.each do |mode|
        define_method("#{mode}_#{schedule}".to_sym) do
          if instance_variable_defined?("@#{mode}_#{schedule}_obj")
            return instance_variable_get("@#{mode}_#{schedule}_obj")
          end

          instance_variable_set("@#{mode}_#{schedule}_obj",
                                send_request(:get, "/api/#{mode.dasherize}/#{schedule}").body.results[0])
        end
      end

      define_method("salmon_run_#{schedule}".to_sym) do
        if instance_variable_defined?("@salmon_run_#{schedule}_obj")
          return instance_variable_get("@salmon_run_#{schedule}_obj")
        end

        instance_variable_set("@salmon_run_#{schedule}_obj",
                              send_request(:get, "/api/coop-grouping/#{schedule}").body.results[0])
      end

      def salmon_run_team_contest
        return @salmon_run_team_contest_obj unless @salmon_run_team_contest_obj.nil?

        @salmon_run_team_contest_obj = send_request(:get, '/api/coop-grouping-team-contest/schedule').body.results[0]
      end
    end

    private

    def send_request(method, path)
      response = splat3_connection.send(method, path)
      Ika3::Response.new(response)
    end

    def api_url
      'https://spla3.yuu26.com/'
    end

    def splat3_connection
      @splat3_connection ||= Faraday.new(faraday_options) do |c|
        c.request :json
        c.response :json
        c.adapter Faraday.default_adapter
      end
    end

    def faraday_options
      {
        url: api_url,
        headers: {
          'User-Agent': "Ika3Gem/#{Ika3::VERSION}(#{@contact})"
        }
      }
    end
  end
end

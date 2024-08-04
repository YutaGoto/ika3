# frozen_string_literal: true

module Ika3
  class Schedule
    def initialize(contact)
      @contact = contact
    end

    modes = %w[regular bankara_challenge bankara_open x fest]
    schedules = %w[now next]

    schedules.each do |schedule|
      modes.each do |mode|
        define_method(:"#{mode}_#{schedule}") do
          return instance_variable_get("@#{mode}_#{schedule}") if instance_variable_defined?("@#{mode}_#{schedule}")

          instance_variable_set(
            "@#{mode}_#{schedule}",
            Battle.new(send_request(:get, "/api/#{mode.dasherize}/#{schedule}").body['results'][0])
          )
        end
      end

      define_method(:"salmon_run_#{schedule}") do
        return instance_variable_get("@salmon_run_#{schedule}") if instance_variable_defined?("@salmon_run_#{schedule}")

        instance_variable_set(
          "@salmon_run_#{schedule}", Salmon.new(send_request(:get, "/api/coop-grouping/#{schedule}").body['results'][0])
        )
      end
    end

    def salmon_run_team_contest
      return @salmon_run_team_contest unless @salmon_run_team_contest.nil?

      @salmon_run_team_contest = Salmon.new(
        send_request(:get, '/api/coop-grouping-team-contest/schedule').body['results'][0]
      )
    end

    def event
      return @event_match unless @event_match.nil?

      @event_match = Battle.new(send_request(:get, '/api/event/schedule').body['results'][0])
    end

    class Battle
      attr_reader :start_time, :end_time, :rule, :stages, :is_fest

      def initialize(data)
        @start_time = data&.[]('start_time')
        @end_time = data&.[]('end_time')
        @rule = Rule.new(data&.[]('rule'))
        @stages = data&.[]('stages')&.map { |stage| Stage.new(stage) }
        @is_fest = data&.[]('is_fest')
      end

      class Stage
        attr_reader :id, :name, :image

        def initialize(data)
          @id = data&.[]('id')
          @name = data&.[]('name')
          @image = data&.[]('image')
        end
      end

      class Rule
        attr_reader :name, :key

        def initialize(data)
          @name = data&.[]('name')
          @key = data&.[]('key')
        end
      end

      private_constant :Stage, :Rule
    end

    class Salmon
      attr_reader :start_time, :end_time, :stage, :weapons, :boss

      def initialize(data)
        return unless data

        @start_time = data['start_time']
        @end_time = data['end_time']
        @stage = Stage.new(data['stage'])
        @weapons = data['weapons'].map { |weapon| Weapon.new(weapon) }
        @boss = Boss.new(data['boss'])
      end

      class Stage
        attr_reader :name, :image

        def initialize(data)
          @name = data['name']
          @image = data['image']
        end
      end

      class Weapon
        attr_reader :name, :image

        def initialize(data)
          @name = data['name']
          @image = data['image']
        end
      end

      class Boss
        attr_reader :name, :id

        def initialize(data)
          @name = data['name']
          @id = data['id']
        end
      end

      private_constant :Stage, :Weapon, :Boss
    end

    private_constant :Battle, :Salmon

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

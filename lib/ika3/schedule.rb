# frozen_string_literal: true

require_relative 'faraday_client'

module Ika3
  class Schedule
    def initialize(contact)
      @client = Ika3::FaradayClient.new(contact)
    end

    modes = %w[regular bankara_challenge bankara_open x fest fest_challenge]
    schedules = %w[now next]

    schedules.each do |schedule|
      modes.each do |mode|
        define_method(:"#{mode}_#{schedule}") do
          return instance_variable_get("@#{mode}_#{schedule}") if instance_variable_defined?("@#{mode}_#{schedule}")

          response = @client.get("/api/#{mode.dasherize}/#{schedule}")

          instance_variable_set(
            "@#{mode}_#{schedule}",
            Battle.new(response.body['results'][0])
          )
        end
      end

      define_method(:"salmon_run_#{schedule}") do
        return instance_variable_get("@salmon_run_#{schedule}") if instance_variable_defined?("@salmon_run_#{schedule}")

        response = @client.get("/api/coop-grouping/#{schedule}")

        instance_variable_set(
          "@salmon_run_#{schedule}", Salmon.new(response.body['results'][0])
        )
      end
    end

    def salmon_run_team_contest
      return @salmon_run_team_contest unless @salmon_run_team_contest.nil?

      response = @client.get('/api/coop-grouping-team-contest/schedule')
      @salmon_run_team_contest = Salmon.new(response.body['results'][0])
    end

    def event
      return @event_match unless @event_match.nil?

      response = @client.get('/api/event/schedule')

      @event_match = Battle.new(response.body['results'][0])
    end

    class Battle
      attr_reader :start_time, :end_time, :rule, :stages, :is_fest, :is_tricolor, :tricolor_stage

      def initialize(data)
        @start_time = data&.[]('start_time')
        @end_time = data&.[]('end_time')
        @rule = Rule.new(data&.[]('rule'))
        @stages = data&.[]('stages')&.map { |stage| Stage.new(stage) }
        @is_fest = data&.[]('is_fest')
        @is_tricolor = data&.[]('is_tricolor')
        @tricolor_stage = Stage.new(data&.[]('tricolor_stage'))
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
  end
end

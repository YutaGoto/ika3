# frozen_string_literal: true

module Ika3
  class Weapon
    class << self
      class W
        attr_reader :name, :sub, :special

        def initialize(data)
          @name = data[:name]
          @sub = data[:sub]
          @special = data[:special]
        end
      end

      private_constant :W

      def find(weapon_key)
        raise "unknown weapon: #{weapon_key}" unless valid?(weapon_key)

        @cache ||= {}
        unless @cache[weapon_key]
          weapon_config = config[weapon_key] || {}
          @cache[weapon_key] = weapon_config
        end

        W.new(@cache[weapon_key])
      end

      def find_by_name(weapon_name)
        raise "unknown weapon: #{weapon_name}" unless weapons.values.include?(weapon_name)

        key = weapons.key(weapon_name)
        find(key)
      end

      def filter_by_sub(sub_name)
        raise "unknown sub weapon: #{sub_name}" unless sub_weapons.values.include?(sub_name)

        weapons = config.values.filter { |weapon| weapon[:sub] == sub_name }
        weapons.map { |weapon| W.new(weapon) }
      end

      def filter_by_special(special_name)
        raise "unknown special weapon: #{special_name}" unless special_weapons.values.include?(special_name)

        weapons = config.values.filter { |weapon| weapon[:special] == special_name }
        weapons.map { |weapon| W.new(weapon) }
      end

      def reload_config!
        @cache = {}
        @config = nil
        @sub_weapons = nil
        config
        config_sub_weapons
        config_special_weapons
      end

      private

      def names
        config.keys
      end

      def weapons
        @weapon_hash ||= {}
        if @weapon_hash.empty?
          config.each do |key, value|
            @weapon_hash[key] = value[:name]
          end
        end
        @weapon_hash
      end

      def sub_weapons
        @sub_weapon_hash ||= {}
        if @sub_weapon_hash.empty?
          config_sub_weapons.each do |key, value|
            @sub_weapon_hash[key] = value[:name]
          end
        end
        @sub_weapon_hash
      end

      def special_weapons
        @special_weapon_hash ||= {}
        if @special_weapon_hash.empty?
          config_special_weapons.each do |key, value|
            @special_weapon_hash[key] = value[:name]
          end
        end
        @special_weapon_hash
      end

      def config
        @config ||= load_yaml("#{File.dirname(__FILE__)}/../../config/weapons.yml").deep_symbolize_keys
        @config
      end

      def config_sub_weapons
        @sub_weapons ||= load_yaml("#{File.dirname(__FILE__)}/../../config/sub_weapons.yml").deep_symbolize_keys
        @sub_weapons
      end

      def config_special_weapons
        @special_weapons ||= load_yaml("#{File.dirname(__FILE__)}/../../config/special_weapons.yml").deep_symbolize_keys
        @special_weapons
      end

      def valid?(weapon_key)
        names.include?(weapon_key)
      end

      def load_yaml(file)
        YAML.safe_load_file(file, aliases: true)
      end
    end
  end
end

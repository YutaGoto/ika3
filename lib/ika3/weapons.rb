module Ika3
  class Weapon < Hash
    include Hashie::Extensions::MethodAccess

    ATTRIBUTES = [
      :name, :sub, :special
    ].freeze

    attr_accessor :io

    ATTRIBUTES.each do |attribute|
      define_method attribute do
        self[attribute]
      end
    end

    class << self
      include Ika3::Concerns::Utils

      def find(weapon_key)
        raise "unknown weapon: #{weapon_key}" unless valid?(weapon_key)

        @cache ||= {}
        unless @cache[weapon_key]
          weapon_config = config[weapon_key] || {}
          @cache[weapon_key] = Ika3::Weapon[weapon_config].tap {|weapon| weapon.io = $stdout}
        end

        @cache[weapon_key]
      end

      def find_by_name(weapon_name)
        raise "unknown weapon: #{weapon_name}" unless weapons.values.include?(weapon_name)

        key = weapons.key(weapon_name)
        find(key)
      end

      def filter_by_sub(sub_name)
        raise "unknown sub weapon: #{sub_name}" unless sub_weapons.values.include?(sub_name)

        config.values.filter{|weapon| weapon[:sub] == sub_name}
      end

      def reload_config!
        @cache = {}
        @config = nil
        @config_sub_weapons = nil
        config
        config_sub_weapons
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

      def config
        unless @config
          @config = load_yaml_file("#{File.dirname(__FILE__)}/../../config/weapons.yml").deep_symbolize_keys
        end
        @config
      end

      def config_sub_weapons
        unless @config_sub_weapons
          @config_sub_weapons = load_yaml_file("#{File.dirname(__FILE__)}/../../config/sub_weapons.yml").deep_symbolize_keys
        end
        @config_sub_weapons
      end

      def valid?(weapon_key)
        names.include?(weapon_key)
      end
    end
  end
end

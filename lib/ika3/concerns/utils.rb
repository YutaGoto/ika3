# frozen_string_literal: true

module Ika3
  module Concerns
    module Utils
      module_function

      def load_yaml_file(file)
        YAML.safe_load_file(file, aliases: true)
      end
    end
  end
end

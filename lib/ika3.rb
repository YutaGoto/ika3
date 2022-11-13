# frozen_string_literal: true

require "active_support/core_ext/array/wrap"
require "active_support/core_ext/hash/keys"

require "yaml"
require "hashie"
require "json"

require "ika3/version"
require "ika3/concerns/utils"
require "ika3/weapons"

module Ika3
  class Error < StandardError; end
end

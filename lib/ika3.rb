# frozen_string_literal: true

require 'yaml'

require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require 'faraday'

require 'ika3/version'
require 'ika3/response'
require 'ika3/weapons'
require 'ika3/schedule'

module Ika3
  class Error < StandardError; end
end

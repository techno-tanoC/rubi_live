require 'active_support/all'
require 'hashie'
require 'yaml'
require 'rubi_live/version'
require 'rubi_live/idol'
require 'rubi_live/unit'
require 'rubi_live/series'
require 'rubi_live/errors'

module RubiLive
  class << self
    [RubiLive::Series, RubiLive::Unit, RubiLive::Idol].each do |klass|
      klass.names.each do |name|
        define_method(name) do
          klass.find(name)
        end
      end
    end
  end
end

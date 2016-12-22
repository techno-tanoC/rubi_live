module RubiLive
  class Series < Hash
    include Hashie::Extensions::MethodAccess
    include Enumerable

    def members
      self[:idols].map do |member|
        RubiLive::Idol.find(member)
      end
    end

    def trio_units
      self[:trio_units].map do |trio_unit|
        RubiLive::Unit.find(trio_unit)
      end
    end

    def each(&block)
      members.each(&block)
    end

    class << self
      ConfigPath = config_file = "#{File.dirname(__FILE__)}/../../config/series.yml"
      private_constant :ConfigPath

      def config
        @config ||= YAML.load_file(ConfigPath).deep_symbolize_keys
      end

      def find(name)
        series_name = name.to_sym
        raise UnknownSeriesError unless valid?(series_name)

        @cache ||= {}
        unless @cache[series_name]
          series_config = config[series_name]
          @cache[series_name] = RubiLive::Series[series_config]
        end

        @cache[series_name]
      end

      def names
        config.keys
      end

      def valid?(series_name)
        names.include?(series_name)
      end
    end
  end
end

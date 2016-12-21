module RubiLive
  class Series < Hash
    include Hashie::Extensions::MethodAccess
    include Enumerable

    def members
      self[:members].map do |member|
        RubiLive::Idol.find(member.to_sym)
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

      def find(series_name)
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

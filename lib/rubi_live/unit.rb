module RubiLive
  class Unit < Hash
    include Hashie::Extensions::MethodAccess
    include Enumerable

    def members
      self[:idols].map do |member|
        RubiLive::Idol.find(member.to_sym)
      end
    end

    def each(&block)
      members.each(&block)
    end

    class << self
      ConfigPath = config_file = "#{File.dirname(__FILE__)}/../../config/units.yml"
      private_constant :ConfigPath

      def config
        @config ||= YAML.load_file(ConfigPath).deep_symbolize_keys
      end

      def find(name)
        unit_name = name.to_sym
        raise UnknownUnitError unless valid?(unit_name)

        @cache ||= {}
        unless @cache[unit_name]
          unit_config = config[unit_name]
          @cache[unit_name] = RubiLive::Unit[unit_config]
        end

        @cache[unit_name]
      end

      def names
        config.keys
      end

      def valid?(unit_name)
        names.include?(unit_name)
      end
    end
  end
end

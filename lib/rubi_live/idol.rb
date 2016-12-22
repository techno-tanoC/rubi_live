module RubiLive
  class Idol < Hash
    include Hashie::Extensions::MethodAccess

    def ==(other)
      other.is_a?(self.class) && self.name == other.name
    end

    def birthday?(date = Date.today)
      month, day = birthday.split("/")
      birthday_date = Date.new(date.year, month.to_i, day.to_i)
      birthday_date == date
    end

    class << self
      ConfigPath = config_file = "#{File.dirname(__FILE__)}/../../config/idols.yml"
      private_constant :ConfigPath

      def config
        @config ||= YAML.load_file(ConfigPath).deep_symbolize_keys
      end

      def find(name)
        idol_name = name.to_sym
        raise "unknown idol: #{name}" unless valid?(idol_name)

        @cache ||= {}
        unless @cache[idol_name]
          idol_config = config[idol_name]
          @cache[idol_name] = RubiLive::Idol[idol_config]
        end

        @cache[idol_name]
      end

      def names
        config.keys
      end

      def valid?(idol_name)
        names.include?(idol_name)
      end
    end
  end
end

module Baron
  module Game
    # Configuration file parsing. This loads the companies, stock market, map
    # tiles, trains and other basic information from the config file.
    class Config
      def initialize(config_file_name)
        @config ||= YAML.load(File.open("games/#{config_file_name}.yml"))
      end

      def private_companies
        init_companies('private', PrivateCompanyConfig)
      end

      def major_companies
        init_companies('major', MajorCompanyConfig)
      end

      private

      def init_companies(type, klass)
        @config.fetch('companies').fetch(type).map do |config|
          klass.new(config).company
        end
      end

      # YamlConfig assists in loading the rules from the yaml file
      #
      # @api private
      class YamlConfig
        def initialize(config)
          @config = config
        end

        def money(key)
          Money.new @config.fetch(key)
        end
      end

      # Creates a Private Company from the config file
      #
      # @api private
      class PrivateCompanyConfig < YamlConfig
        # Returns the private company object
        #
        # return [Baron::PrivateCompany]
        def company
          Company::PrivateCompany.new(
            @config.fetch('name'),
            face_value: money('face_value'),
            revenue: money('revenue')
          )
        end
      end

      # Creates a Major Company from the config file
      #
      # @api private
      class MajorCompanyConfig < YamlConfig
        # Returns the major company object
        #
        # return [Baron::MajorCompany]
        def company
          Company::MajorCompany.new(
            @config.fetch('abbreviation'),
            @config.fetch('name')
          )
        end
      end
    end
  end
end

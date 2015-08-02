module Baron
  # Configuration file parsing. This loads the companies, stock market, map
  # tiles, trains and other basic information from the config file.
  class Rules
    # @see class description
    #
    # @example
    #   Baron::Rules.new('1860')
    #   # loads the rules from `games/1860.yml`
    #
    # @api public
    # @param [String] config_file_name
    def initialize(config_file_name)
      @config ||= YAML.load(File.open("games/#{config_file_name}.yml"))
    end

    # The private companies in the rules
    #
    # @example
    #   rules.private_companies
    #   # returns all private comapnies in these rules
    #
    # @api public
    # @return [Array<Baron::Company::PrivateCompany>]
    def private_companies
      init_companies('private', PrivateCompanyConfig)
    end

    # The major companies in the rules
    #
    # @example
    #   rules.major_companies
    #   # returns all major comapnies in these rules
    #
    # @api public
    # @return [Array<Baron::Company::MajorCompany>]
    def major_companies
      init_companies('major', MajorCompanyConfig)
    end

    # The configuration of the shares, as defined in the yaml file
    #
    # @example
    #   rules.share_configuration
    #   #=> [0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1]
    #
    # @api public
    # @return [Array<BigDecimal>] An array of big decimals defining the share
    # configuration. The big decimals should sum to 1.
    def share_configuration
      @config.fetch('share_configuration').fetch('major')
        .flat_map do |portion, number|
        number.times.map { BigDecimal.new portion }
      end
    end

    private

    # Create the companies that are defined for this game in the config
    #
    # @api private
    # @return [Array<Baron::Company>]
    def init_companies(type, klass)
      @config.fetch('companies').fetch(type).map do |config|
        klass.new(config).company
      end
    end

    # YamlConfig assists in loading the rules from the yaml file
    #
    # @api private
    class YamlConfig
      # Initialize a yaml parser
      def initialize(config)
        @config = config
      end

      # Returns a money representation of the yaml key
      #
      # @api private
      # @return [Baron::Money]
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
      # @api private
      # @return [Baron::Comany::PrivateCompany]
      def company
        Company::PrivateCompany.new(
          @config.fetch('abbreviation'),
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
      # @api private
      # @return [Baron::Company::MajorCompany]
      def company
        Company::MajorCompany.new(
          @config.fetch('abbreviation'),
          @config.fetch('name')
        )
      end
    end
  end
end

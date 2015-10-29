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
      @private_companies ||= init_companies('private', PrivateCompanyConfig)
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
      @major_companies ||= init_companies('major', MajorCompanyConfig)
    end

    # All of the trains used in the game
    #
    # @example
    #   rules.trains
    #
    # @api public
    # @return [Array<Baron::Train>]
    def trains
      @trains ||= init_trains
    end

    # Return all companies
    #
    # This returns all private and major companies
    #
    # @example
    #   rules.companies
    #
    # @api public
    # @return [Array<Baron::Company>]
    def companies
      private_companies + major_companies
    end

    # The auctionable private companies
    #
    # @example
    #   rules.auctionable_companies
    #
    # @api public
    # @return [Array<Baron::Company>]
    def auctionable_companies
      @config.fetch('auction').map do |abbreviation|
        companies.find do |company|
          company.abbreviation.eql? abbreviation
        end
      end
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

    # The starting cash for this game for the number of players
    #
    # @example
    #   rules.starting_cash #=> $540
    #
    # @api public
    # @param [Fixnum] num_players The number of players in this game
    # @return [Baron::Money] The money that each player starts the game with.
    def starting_cash(num_players)
      Money.new @config.fetch('starting_money').fetch(num_players)
    end

    # The stock market values for the game
    #
    # @example
    #   rules.market_values
    #
    # @api public
    # @return [Array<Fixnum>]
    def market_values
      @config.fetch('stock_market').fetch('values')
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

    # Create the trains for this game
    #
    # @api private
    # @return [Array<Baron::Trains>]
    def init_trains
      init_train_types
      @config.fetch('trains').flat_map do |train_type|
        train_type.fetch('count').times.map do
          create_train(train_type)
        end
      end
    end

    # Create a train based on the config file format
    #
    # @api private
    # @return [Baron::Train]
    def create_train(train_type)
      Train.new(
        @train_types.find do |type|
          type.to_s.eql? "#{train_type.fetch('type')}T"
        end
      )
    end

    # Create the train types used in this game
    #
    # @api private
    # @return [Array<Baron::TrainType>]
    def init_train_types
      @train_types ||= @config.fetch('trains').map do |train|
        major_allowance, minor_allowance = train.fetch('type').split('+')
        TrainType.new(
          major_allowance.to_i,
          Money.new(train.fetch('face_value')),
          minor_station_allowance: minor_allowance
        )
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

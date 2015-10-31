module Baron
  # Base class for all games, this contains the logic for maintaining a
  # standard 18xx game, which can be customized through configuration.
  #
  # The basic information for the game is defined in yml files in the games
  # directory.
  class Game
    extend Forwardable
    def_delegator :@rules, :major_companies

    # The size of the bank.
    #
    # In many games the bank size involves an end game trigger, however in Baron
    # we calculate that through other means. We just need a pool of money large
    # enough to pay out everything.
    BANK_SIZE = 100_000_000

    # The bank for this game
    #
    # @example
    #   game.bank
    #
    # @api public
    # @return [Baron::Bank]
    attr_reader :bank

    # The initial offering
    #
    # @example
    #   game.initial_offering
    #
    # @api public
    # @return [Baron::InitialOffering]
    attr_reader :initial_offering

    # The market
    #
    # @example
    #   game.market
    #
    # @api public
    # @return [Baron::Market]
    attr_reader :market

    # The players involved in this game
    #
    # @example
    #   game.players
    #
    # @api public
    # @return [Array<Baron::Player>]
    attr_reader :players

    # The rules of this game
    #
    # @example
    #   game.rules
    #
    # @api public
    # @return [Baron::Rules]
    attr_reader :rules

    # The unavailable certificates pool
    #
    # @example
    #   game.unavailable_certificates_pool
    #
    # @api public
    # @return [Baron::UnavailableCertificatesPool]
    attr_reader :unavailable_certificates_pool

    # Construct the game
    #
    # @example
    #   Baron::Game.new(rules, players)
    #
    # @api public
    # @param [Baron::Rules] rules
    # @param [Array<Baron::Player>] players The players of the game in the
    # order in which they are going to take turns. The player starting the
    # game with priority deal should be first in the array.
    def initialize(rules, players)
      @rules = rules
      @players = players.freeze
      @flow = GameRoundFlow.new(self)
      init_bank
      init_certificates
      init_market
      init_initial_offering
      init_starting_cash
      init_trains
    end

    # The current round in the game
    #
    # This will return a stock round, operating round, auction round or some
    # other round.
    #
    # @example
    #   game.current_round
    #
    # @api public
    # @return [Baron::Round]
    def current_round
      @flow.current_round
    end

    # The current turn in the game
    #
    # This is delegated to the current round
    #
    # @example
    #   game.current_turn
    #
    # @api public
    # @return [Baron::Turn]
    def current_turn
      current_round.current_turn
    end

    # The player whose turn it is to currently act
    #
    # @example
    #   game.current_player
    #
    # @api public
    # @return [Baron::Player]
    def current_player
      current_turn.player
    end

    # Get the director of a company
    #
    # @example
    #   game.director(company) #=> the player who is a director
    #
    # @api public
    # @param [Baron::Company] company
    # @return [Baron::Player] The player who holds the directors certificate,
    # nil if no player holds it
    def director(company)
      players.each do |player|
        return player if player.directorships.include?(company)
      end
      bank
    end

    # Returns a basic string representation of the game
    #
    # @api private
    # @return [String]
    def inspect
      "#<Baron::Game:#{object_id}>"
    end

    # Is the game over
    #
    # TODO: Implement game over logic
    #
    # @example
    #   game.over?
    #
    # @api public
    # @return [Boolean] True if the game is over, false otherwise.
    def over?
      false
    end

    # Place the next level of trains in the initial offering
    #
    # This will generally be triggered at the start of the game or after a
    # train has been purchased. The trains will be added if the appopriate
    # conditions have been met.
    #
    # @example
    #   game.add_next_level_of_trains
    #
    # @api public
    # @return [void]
    def add_next_level_of_trains
      unavailable_certificates_pool.give(
        initial_offering,
        unavailable_certificates_pool.next_trains
      ) if initial_offering.trains.empty?
    end

    # The current phase of the game
    #
    # The game phase is defined by the trains which have been sold. As an
    # example, when the first 3 train has been sold, the game enters phase 3.
    #
    # @example
    #   game.phase
    #
    # @api public
    # @return [Fixnum] The phase of the game
    def phase
      major_companies.map(&:largest_train).compact.max || 2
    end

    private

    # Initialize the bank and grant it the starting money
    #
    # @api private
    # @return [Baron::Bank]
    def init_bank
      @bank = Bank.new(self)
      @bank.grant Money.new(BANK_SIZE)
    end

    # All certificates in the game
    #
    # @api private
    # @return [Array<Baron::Certificate>]
    def certificates
      major_certificates + private_certificates
    end

    # Major company certificates in the game
    #
    # @api private
    # @return [Array<Baron::Certificate>]
    def major_certificates
      major_companies.flat_map do |company|
        rules.share_configuration.map do |portion|
          Certificate.new company, portion
        end
      end
    end

    # Private company certificates in the game
    #
    # @api private
    # @return [Array<Baron::Certificate>]
    def private_certificates
      rules.private_companies.map do |company|
        Certificate.new company, BigDecimal.new('1')
      end
    end

    # Create the unavailable certificate pool and place the certificates there
    #
    # @api private
    # @return [void]
    def init_certificates
      @unavailable_certificates_pool = UnavailableCertificatesPool.new
      @unavailable_certificates_pool.grant certificates
    end

    # Create the market
    #
    # @api private
    # @return [void]
    def init_market
      @market = Market.new rules
    end

    # Create the initial offering
    #
    # @api private
    # @return [void]
    def init_initial_offering
      @initial_offering = InitialOffering.new
    end

    # Grant the players their initial starting capital
    #
    # @api private
    # @return [void]
    def init_starting_cash
      players.each do |player|
        bank.give player, starting_cash
      end
    end

    # Place trains in the initial offering and unavailable certificates pool
    #
    # @api private
    # @return [void]
    def init_trains
      unavailable_certificates_pool.grant rules.trains
      add_next_level_of_trains
    end

    # The amount of money that players start the game with
    #
    # @api private
    # @return [Baron::Money]
    def starting_cash
      rules.starting_cash(players.count)
    end
  end
end

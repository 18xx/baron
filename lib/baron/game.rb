module Baron
  # Base class for all games, this contains the logic for maintaining a
  # standard 18xx game, which can be customized through configuration.
  #
  # The basic information for the game is defined in yml files in the games
  # directory.
  class Game
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
      @current_round ||= Round::InitialAuction.new(self)
      @current_round = next_round.new(self) if @current_round.over?
      @current_round
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
      nil
    end

    # Returns a basic string representation of the game
    #
    # @api private
    # @return [String]
    def inspect
      "#<Baron::Game:#{object_id}>"
    end

    private

    # Initialize the bank and grant it the starting money
    #
    # @api private
    # @return [Baron::Bank]
    def init_bank
      @bank = Bank.new
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
      rules.major_companies.flat_map do |company|
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

    # Place the next level of trains in the initial offering
    #
    # This will generally be triggered when the current set of trains has
    # sold out.
    #
    # @api private
    # @return [void]
    def add_next_level_of_trains
      unavailable_certificates_pool.give(
        initial_offering,
        unavailable_certificates_pool.next_trains
      )
    end

    # Returns the next round to be played in the game
    #
    # The game will normally cycle between stock rounds and operating rounds
    #
    # @api private
    # @return [Baron::Round]
    def next_round
      if @current_round.instance_of?(Round::StockRound)
        Round::OperatingRound
      else
        Round::StockRound
      end
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

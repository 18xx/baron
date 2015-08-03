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
      @players = players
      init_bank
      init_initial_offering
      init_starting_cash
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
      # FIXME: This is not fully implemented
      @current_round ||= Round::InitialAuction.new(self)
    end

    # The current operation in the game
    #
    # This is delegated to the current round
    #
    # @example
    #   game.current_operation
    #
    # @api public
    # @return [Baron::Operation]
    def current_operation
      current_round.current_operation
    end

    private

    # Initialize the bank and grant it the starting money
    #
    # @api private
    # @return [Baron::Bank]
    def init_bank
      @bank = Bank.new
      Transaction.new(@bank, Money.new(BANK_SIZE), nil, nil)
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

    # Create the initial offering and place the certificates there
    #
    # @api private
    # @return [void]
    def init_initial_offering
      @initial_offering = InitialOffering.new
      certificates.each do |certificate|
        Transaction.new @initial_offering, [certificate], nil, []
      end
    end

    # Grant the players their initial starting capital
    #
    # @api private
    # @return [void]
    def init_starting_cash
      players.each do |player|
        Transaction.new player, rules.starting_cash(players.count), bank, nil
      end
    end
  end
end

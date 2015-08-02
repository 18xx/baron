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
    end

    # The current operation in the game
    #
    # @example
    #   game.current_operation
    #
    # @api public
    # @return [Baron::Operation]
    def current_operation
      # FIXME: This is not fully implemented
      @current_operation ||= Operation::WinnerChooseAuction.new(@players)
    end

    private

    # Initialize the bank and grant it the starting money
    #
    # @api private
    # @return [Baron::Bank]
    def init_bank
      @bank = Bank.new
      @bank.add_transaction(
        Transaction.new(@bank, Money.new(BANK_SIZE), nil, nil)
      )
    end

    # All certificates in the game
    #
    # @api private
    # @return [Array<Baron::Certificate>]
    def certificates
      rules.major_companies.flat_map do |company|
        rules.share_configuration.map do |portion|
          Certificate.new company, portion
        end
      end
    end

    # Create the initial offering and place the certificates there
    #
    # @api private
    # @return [void]
    def init_initial_offering
      @initial_offering = InitialOffering.new
      certificates.each do |certificate|
        @initial_offering.add_transaction(
          Transaction.new @initial_offering, [certificate], nil, []
        )
      end
    end
  end
end

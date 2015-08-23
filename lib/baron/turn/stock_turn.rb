module Baron
  class Turn
    # A stock turn is a single players turn to sell and buy certificates
    #
    # In most games, a player may sell as many certificats as they would like
    # to the bank pool (respecting various limits). And then buy one
    # certificate. A player may also pass and take no action.
    class StockTurn < self
      # The player who is taking the turn
      #
      # @example
      #   stock_turn.player
      #
      # @api public
      # @return [Baron::Player]
      attr_reader :player

      # The stock round in which this stock turn is taking place
      #
      # @example
      #   stock_turn.round
      #
      # @api public
      # @return [Baron::StockRound]
      attr_reader :round

      # Create the stock turn
      #
      # @example
      #   Baron::Turn::StockTurn.new(player, round)
      #
      # @api public
      # @param [Baron::Player] player The player taking the turn
      # @param [Baron::Round::StockRound] round The stock round this belongs to
      def initialize(player, round)
        @player = player
        @round = round
      end

      # Is this stock turn over?
      #
      # The persons stock turn is over if they have passed, or if they have
      # done their purchase for the round.
      #
      # @example
      #   turn.done?
      #
      # @api public
      # @return [Boolean] Returns true if this turn is done, false otherwise
      def done?
        false
      end

      # Returns a list of actions that the player can take
      #
      # @example
      #   turn.available_actions
      #
      # @api public
      # @return [Array<Baron::Action>]
      def available_actions
        [Action::BuyCertificate, Action::Pass]
      end
    end
  end
end

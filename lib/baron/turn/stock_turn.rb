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
        @done = false
        @passed = false
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
        @done
      end

      # Was this action a pass?
      #
      # A pass is defined as taking no buy, or sell actions
      #
      # @example
      #   turn.pass?
      #
      # @api public
      # @return [Boolean] True if this was a pass, false otherwise
      def passed?
        @passed
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

      private

      # The bank for this game
      #
      # @api private
      # @return [Baron::Bank]
      def bank
        @round.game.bank
      end

      # The initial offering
      #
      # @api private
      # @return [Baron::InitialOffering]
      def initial_offering
        @round.game.initial_offering
      end

      # Floats the specified company
      #
      # @api private
      # @return [void]
      def float(company)
        bank.give company, initial_offering.get_par_price(company) * 10
      end

      # Check to see if the company has floated
      #
      # @api private
      # @param [Baron::Company] company
      # @return [void]
      def check_for_float(company)
        float(company) unless
          company.floated? ||
          (initial_offering.percentage_owned(company) > BigDecimal.new('0.5'))
      end

      # The player buys the certifiate from a source
      #
      # The player will buy the certificate at the appropriate price determined
      # by the par price or market price for that certificate
      #
      # @api private
      # @param [Baron::Action::BuyCertificate] action
      # @return [void]
      def buycertificate(action)
        @done = true
        action.create_transaction
        check_for_float action.certificate.company
      end

      # The player passes
      #
      # The player will be done, and they can not take any more actions on this
      # turn
      #
      # @api private
      # @param [Baron::Action::Pass] _
      # @return [void]
      def pass(_)
        @passed = true
        @done = true
      end
    end
  end
end

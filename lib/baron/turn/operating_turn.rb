module Baron
  class Turn
    # An operating turn is taken by the player on behalf of a company
    #
    # Each company will generally get one turn during each operating round
    # during which they may:
    # - Lay tiles
    # - Place Tokens
    # - Run Trains
    # - Purchase Trains
    # and more
    class OperatingTurn < self
      # The game that this operating turn is a part of
      #
      # @example
      #   turn.game
      #
      # @api public
      # @return [Baron::Game]
      attr_reader :game

      # The company performing this operation
      #
      # @example
      #   turn.company
      #
      # @api public
      # @return [Baron::Company]
      attr_reader :company

      # The player in charge of this operation
      #
      # This will be the director of the company
      #
      # @example
      #   turn.player
      #
      # @api public
      # @return [Baron::Player]
      attr_reader :player

      # The amount that the company ran for this operation
      #
      # @example
      #   turn.run_amount
      #
      # @api public
      # @return [Fixnum]
      attr_reader :run_amount

      # Initialize the operating turn
      #
      # @example
      #   Baron::Turn::OperatingTurn.new(game, director, company)
      #
      # @api public
      # @param [Baron::Game] game
      # @param [Baron::Player] player
      # @param [Baron::Company] company
      def initialize(game, player, company)
        @game = game
        @company = company
        @player = player
      end

      # A list of actions that the player can take on behalf of the company
      #
      # @example
      #   turn.available_actions
      #
      # @api public
      # @return [Array<Baron::Action>]
      def available_actions
        [
          can_place_tile,
          can_place_token,
          can_run_trains,
          can_payout,
          can_retain,
          can_buy_trains,
          can_done
        ].compact
      end

      # Is this operating turn over?
      #
      # The company operating turn is over when they have no more legal
      # actions to perform, or if they have declared that they are done
      # through a done action.
      #
      # @example
      #   turn.done?
      #
      # @api public
      # @return [Boolean] Returns true if this turn is done, false otherwise
      def done?
        count_actions_taken(Action::Done) > 0
      end

      # Place a tile on the board
      #
      # @api private
      # @param [Baron::Action::PlaceTile] _
      # @return [void]
      def placetile(_)
        # TODO: Implement placetile
      end

      # Place a token on the board
      #
      # @api private
      # @param [Baron::Action::PlaceTile] _
      # @return [void]
      def placetoken(_)
        # TODO: Implement placetile
      end

      # Run trains this companies operating turn
      #
      # @api private
      # @param [Baron::Action::RunTrains] _
      # @return [void]
      def runtrains(action)
        @run_amount = action.amount
      end

      # Pay out earnings to shareholders
      #
      # @api private
      # @param [Baron::Action::Payout] _
      # @return [void]
      def payout(_)
        payout_amounts.each do |player, amount|
          game.bank.give(player, Money.new(amount)) if amount > 0
        end
      end

      # Retain earnings to the company
      #
      # @api private
      # @param [Baron::Action::Retain] _
      # @return [void]
      def retain(_)
        game.bank.give(company, Money.new(@run_amount))
      end

      # Count the number of times the action taken this turn
      #
      # @api private
      # @return [Fixnum] The number of times the action has been taken. 0 if it
      # has not been taken this turn.
      def count_actions_taken(klass)
        taken_actions.count { |action| action.instance_of? klass }
      end

      # Has this company placed a token this turn
      #
      # @api private
      # @return [Boolean]
      def placed_token?
        count_actions_taken(Action::PlaceToken) > 0
      end

      # Has this company run trains this turn
      #
      # @api private
      # @return [Boolean]
      def run_trains?
        count_actions_taken(Action::RunTrains) > 0
      end

      # Has this declared what it is going to do with its earnings
      #
      # @api private
      # @return [Boolean]
      def declared_earnings?
        run_amount.equal?(0) || (
          count_actions_taken(Action::Payout) +
          count_actions_taken(Action::Retain)
        ) > 0
      end

      # Return the place tile action is the company can place tiles
      #
      # @api private
      # @return [Baron::Action::PlaceTile]
      def can_place_tile
        Action::PlaceTile unless
          count_actions_taken(Action::PlaceTile).equal?(2) ||
          placed_token? ||
          run_trains?
      end

      # Return the place token action is the company can place a token
      #
      # @api private
      # @return [Baron::Action::PlaceToken]
      def can_place_token
        Action::PlaceToken unless placed_token? || run_trains?
      end

      # Return the run trains action is the company can run trains
      #
      # @api private
      # @return [Baron::Action::PlaceToken]
      def can_run_trains
        Action::RunTrains unless run_trains?
      end

      # Return the payout action is the company can pay out
      #
      # @api private
      # @return [Baron::Action::Payout]
      def can_payout
        Action::Payout if run_trains? && !declared_earnings?
      end

      # Return the retain action is the company can retain
      #
      # @api private
      # @return [Baron::Action::Retain]
      def can_retain
        Action::Retain if can_payout
      end

      # Return the buy trains action is the company can buy trains
      #
      # @api private
      # @return [Baron::Action::BuyTrain]
      def can_buy_trains
        Action::BuyTrain if declared_earnings? && !done?
      end

      # Return the done action is the company can declar it is done
      #
      # @api private
      # @return [Baron::Action::Done]
      def can_done
        Action::Done if declared_earnings? && !done?
      end

      # The amounts to be paid out to each payer
      #
      # @api private
      # @return [Hash<Baron::Player, Fixnup>] The player and amount that they
      # are to be paid
      def payout_amounts
        game.players.map do |player|
          [player, (run_amount * player.percentage_owned(company)).to_int]
        end
      end
    end
  end
end

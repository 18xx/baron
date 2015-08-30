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

      # Initialize the operating turn
      #
      # @example
      #   Baron::Turn::OperatingTurn.new(company)
      #
      # @api public
      # @param [Baron::Player] player
      # @param [Baron::Company] company
      def initialize(player, company)
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
          Action::PlaceTile
        ]
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
        false
      end

      private

      # Place a tile on the board
      #
      # @api private
      # @param [Baron::Action::PlaceTile] action
      # @return [void]
      def placetile(_)
        # TODO: Implement placetile
      end

      # Place a token on the board
      #
      # @api private
      # @param [Baron::Action::PlaceTile] action
      # @return [void]
      def placetoken(_)
        # TODO: Implement placetile
      end
    end
  end
end

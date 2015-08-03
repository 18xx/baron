module Baron
  class Round
    # The initial auction round of the game
    #
    # This is the phase of the game in which private companies are generally
    # distributed, sometimes also containing directorships of companies.
    class InitialAuction
      # The game which this initial auction is a part of
      #
      # @example
      #   round.game
      #
      # @api public
      # @return [Baron::Game]
      attr_reader :game

      # Create the initial auction round
      #
      # @example
      #   Baron::InitialAuction.new(game)
      #
      # @api public
      # @param [Baron::Game]
      def initialize(game)
        @game = game
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
        @current_operation ||= Operation::WinnerChooseAuction.new(
          game.players, game.bank
        )
      end
    end
  end
end

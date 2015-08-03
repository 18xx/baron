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
        new_auction
      end

      # The current operation in the game
      #
      # @example
      #   game.current_operation
      #
      # @api public
      # @return [Baron::Operation]
      def current_operation
        new_auction if @current_operation.done?
        @current_operation
      end

      private

      # Creates a new auction and assigns it to the current operation
      #
      # @api private
      # @return [Baron::Operation::WinnerChooseAuction]
      def new_auction
        @current_operation = Operation::WinnerChooseAuction.new(
          game.players, game.bank
        )
      end
    end
  end
end

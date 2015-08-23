module Baron
  class Round
    # An operating round in the game
    #
    # In the operating round, each company (private, minor, and major) gets
    # an operation which may include an opportunity to lay tiles, purchase
    # tokens, run trains, and buy trains.
    class OperatingRound < self
      # Create the operating round
      #
      # @example
      #   Baron::OperatingRound.new(game)
      #
      # @api public
      # @param [Baron::Game] game
      def initialize(game)
        @game = game
      end
    end
  end
end

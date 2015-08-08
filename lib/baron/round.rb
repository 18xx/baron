module Baron
  # A round in the 18xx game such as a share round, or operating round
  class Round
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
    # @param [Baron::Game] game
    def initialize(game)
      @game = game
    end
  end
end

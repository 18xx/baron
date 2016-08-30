# frozen_string_literal: true
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

    # Is the current round over?
    #
    # @example
    #   round.over?
    #
    # @api public
    # @return [Boolean]
    def over?
      fail NotImplementedError
    end
  end
end

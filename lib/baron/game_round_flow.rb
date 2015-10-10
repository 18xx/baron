module Baron
  # GameRoundFlow manages the flow of rounds that occur throughout the game,
  # deciding if there is a stock round, or operating round next as an example.
  class GameRoundFlow
    # Initialize the game round flow
    #
    # @example
    #   Baron::GameRoundFlow.new(game)
    #
    # @api public
    # @param [Baron::Game] game
    def initialize(game)
      @upcoming_rounds = []
      @game = game
    end

    # The current round in the game
    #
    # This will return a stock round, operating round, auction round or some
    # other round.
    #
    # @example
    #   game.current_round
    #
    # @api public
    # @return [Baron::Round]
    def current_round
      @current_round ||= Round::InitialAuction.new(@game)
      @current_round = next_round if @current_round.over?
      @current_round
    end

    private

    # Returns the next round to be played in the game
    #
    # The game will normally cycle between stock rounds and operating rounds
    #
    # @api private
    # @return [Baron::Round]
    def next_round
      @upcoming_rounds.push(*future_rounds) if @upcoming_rounds.empty?
      @upcoming_rounds.shift
    end

    # Get the next rounds be appended to the set of rounds upcoming
    #
    # @api private
    # @return [Array<Baron::Round>]
    def future_rounds
      if @current_round.instance_of?(Round::InitialAuction)
        new_stock_round
      elsif !@game.over?
        [
          Round::OperatingRound.new(@game),
          new_stock_round
        ]
      end
    end

    # Return a new stock round for the game
    #
    # @api private
    # @return [Baron::Round::StockRound]
    def new_stock_round
      Round::StockRound.new(@game, @current_round.next_priority_deal)
    end
  end
end

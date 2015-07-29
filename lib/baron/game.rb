module Baron
  # Base class for all games, this contains the logic for maintaining a
  # standard 18xx game, which can be customized through configuration.
  #
  # The basic information for the game is defined in yml files in the games
  # directory.
  class Game
    # The rules of this game
    #
    # @return [Baron::Rules]
    attr_reader :rules

    # The players involved in this game.
    #
    # @return [Array<Baron::Player>]
    attr_reader :players

    # Construct the game
    #
    # @param [Baron::Rules] rules
    # @param [Array<Baron::Player>] players The players of the game in the
    # order in which they are going to take turns. The player starting the
    # game with priority deal should be first in the array.
    def initialize(rules, players)
      @rules = rules
      @players = players
    end

    # The current action in the game.
    #
    # @return [Baron::Action]
    def current_action
      @action ||= Action::WinnerChooseAuction.new(@players)
    end
  end
end

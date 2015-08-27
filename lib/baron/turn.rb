module Baron
  # An turn is a group of a set of actions taken in a game
  #
  # It will be triggered by an event of some sort and will include things like
  # the following:
  #
  # - An auction of one private company
  # - A players share action turn composed of buy and sell actions
  # - A single company's turn turn during an operating round
  class Turn
    # Performs the action listed
    #
    # @example
    #   turn.perform(action)
    #
    # @api public
    # @param [Baron::Action] action
    # @return [void]
    def perform(action)
      validate_turn(action.player)
      __send__(action.symbol, action)
    end

    # The player whose turn it is
    #
    # This should be implemented by all classes which inherit from turn
    #
    # @example
    #   turn.player
    #
    # @api public
    # @return [Baron::Player]
    def player
      fail NotImplementedError
    end

    private

    # Validate that is the specified player's turn
    #
    # It will throw an WrongTurn if the player specified is not the current
    # player.
    #
    # @api private
    # @param [Baron::Player] acting_player
    # @return nil
    def validate_turn(acting_player)
      fail WrongTurn, "#{acting_player} attempted to act, but it is " \
        "#{player}'s turn" unless player.equal?(acting_player)
    end
  end
end

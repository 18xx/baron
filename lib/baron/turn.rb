# frozen_string_literal: true
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
      action_method = action.symbol
      validate(action)
      action.process
      public_send(action_method, action)
      taken_actions << action
    end

    # Returns a list of actions that the player can take
    #
    # @example
    #   turn.available_actions
    #
    # @api public
    # @return [Array<Baron::Action>]
    def available_actions
      fail NotImplementedError
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

    # The action that was taken is not currently allowed
    class InvalidActionError < StandardError
    end

    private

    # The actions which have been taken this turn
    #
    # @api private
    # @return [Array<Baron::Action>] The actions that have been taken this turn.
    # If no actions have been taken, an empty array is returned
    def taken_actions
      @taken_actions ||= []
    end

    # Validate that the action is currently allowed
    #
    # @api private
    # @param [Baron::Action] action
    # @return [void]
    def validate(action)
      validate_turn(action.player)
      klass = action.class
      fail InvalidActionError, "Attempted to perform #{klass}, " \
        "Allowed Actions: (#{available_actions})" unless
        available_actions.include?(klass)
    end

    # Validate that the action is currently allowed
    #
    # It will throw an WrongTurn if the player specified is not the current
    # player.
    #
    # @api private
    # @param [Baron::Player] acting_player
    # @return [void]
    def validate_turn(acting_player)
      fail WrongTurn, "#{acting_player} attempted to act, but it is " \
        "#{player}'s turn" unless player.equal?(acting_player)
    end
  end
end

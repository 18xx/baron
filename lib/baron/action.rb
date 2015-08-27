module Baron
  # The base class for all actions. Actions should inherit from this class.
  class Action
    # The player who has taken this action
    #
    # @example
    #   action.player
    #
    # @api public
    # @return [Baron::Player]
    attr_reader :player

    # Create the action
    #
    # @example
    #   Baron::Action.new(player)
    #
    # @api public
    # @param [Baron::Player] player The player taking the action
    def initialize(player)
      @player = player
    end

    # Returns a symbol representation of this action
    #
    # This is used to determine how to delegate the methods within the turn
    #
    # @api private
    # @return [Symbol]
    def symbol
      self.class.name.split('::').last.downcase.to_sym
    end
  end
end

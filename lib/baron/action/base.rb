module Baron
  module Action
    # The base class for all actions. Actions should inherit from this class.
    class Base
      # The player who has taken this action
      #
      # @return [Baron::Player]
      attr_reader :player

      # Create the action
      #
      # @param [Baron::Player] player The player taking the action
      def initialize(player)
        @player = player
      end
    end
  end
end

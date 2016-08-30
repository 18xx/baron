# frozen_string_literal: true
module Baron
  class Action
    # A company action is an action taken by a director on behalf of a company
    class CompanyAction < self
      # The turn that this action is a part of
      #
      # @example
      #   action.turn
      #
      # @api public
      # @return [Baron::Turn]
      attr_reader :turn

      # Create the company action
      #
      # This is designed to be called by the parent action
      #
      # @api private
      # @param [Baron::Turn] turn The turn this action is a part of
      def initialize(turn)
        @player = turn.player
        @turn = turn
      end
    end
  end
end

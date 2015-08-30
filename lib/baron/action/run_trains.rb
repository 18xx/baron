module Baron
  class Action
    # In this action the company runs its trains for an amount
    #
    # This is generally a required action for every company operating turn,
    # even if they have no trains (and therefore run for 0)
    class RunTrains < CompanyAction
      # The amount that the company ran for
      #
      # @example
      #   action.amount
      #
      # @api public
      # @return [Fixnum]
      attr_reader :amount

      # The amount of the corporate bonus paid
      #
      # @example
      #   action.corporate_bonus
      #
      # @api public
      # @return [Fixnum]
      attr_reader :corporate_bonus

      # Create the run trains action
      #
      # @example
      #   Baron::Action::RunTrains.new(turn, 100, 10)
      #
      # @api public
      # @param [Baron::Turn] turn
      # @param [Fixnum] amount The amount of the run
      # @param [Fixnum] corporate_bonus The additinonal amount that is provided
      # for osmething like a halt bonus, or mail contract
      def initialize(turn, amount, corporate_bonus)
        super(turn)
        @amount = amount
        @corporate_bonus = corporate_bonus
      end
    end
  end
end

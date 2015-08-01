module Baron
  module Action
    # A bid is made on an auction, by a player in a specific amount.
    class Bid < Base
      # Minimum bid increment
      BID_INCREMENT = 5

      # The amount bid
      #
      # @return [Fixnum]
      attr_reader :amount

      # Create the bid
      #
      # @param [Baron::Player] player The player making the bid.
      # @param [Fixnum] amount The amount being bid
      def initialize(player, amount)
        super(player)
        @amount = amount
        validate_non_negative
        validate_divisibility
      end

      private

      def validate_non_negative
        fail IllegalBidAmount, 'Amount cannot be negative' if @amount < 0
      end

      def validate_divisibility
        fail IllegalBidAmount, 'Amount must be divisible by 5' unless
          (@amount % BID_INCREMENT).zero?
      end
    end
  end
end

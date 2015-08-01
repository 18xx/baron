module Baron
  module Operation
    # A bid is made on an auction, by a player in a specific amount.
    class Bid
      # The player who has made the bid
      #
      # @return [Baron::Player]
      attr_reader :player

      # The amount bid
      #
      # @return [Fixnum]
      attr_reader :amount

      # Create the bid
      #
      # @param [Baron::Player] player The player making the bid.
      # @param [Fixnum] amount The amount being bid
      def initialize(player, amount)
        @player = player
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
          (@amount % 5).zero?
      end
    end
  end
end

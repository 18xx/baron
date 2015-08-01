module Baron
  module Action
    # A bid is made on an auction, by a player in a specific amount.
    class Bid < Base
      # Minimum bid increment
      BID_INCREMENT = 5

      # The amount bid
      #
      # @example
      #   bid.amount
      #
      # @api public
      # @return [Fixnum]
      attr_reader :amount

      # Create the bid
      #
      # @example
      #   Baron::Action::Bid.new(player, 20)
      #
      # @api public
      # @param [Baron::Player] player The player making the bid.
      # @param [Fixnum] amount The amount being bid
      def initialize(player, amount)
        super(player)
        @amount = amount
        validate_non_negative
        validate_divisibility
      end

      private

      # Validate that the bid is greater than or equal to zero
      #
      # This will raise an IllegalBidAmount error if the amount bid is
      # negative
      #
      # @api private
      # @return nil
      def validate_non_negative
        fail IllegalBidAmount, 'Amount cannot be negative' if @amount < 0
      end

      # Validate that the bid is divisible by the minimum increment
      #
      # This will raise an IllegalBidAmount error if the amount bid is not
      # divisible by the minimum increment
      #
      # @api private
      # @return nil
      def validate_divisibility
        fail(
          IllegalBidAmount,
          "Amount must be divisible by #{BID_INCREMENT}"
        ) unless (@amount % BID_INCREMENT).zero?
      end
    end
  end
end

module Baron
  class Action
    # Buy certificate allows a player to purchase a certificate from a
    # shareholder. Usually the initial offering or the bank pool.
    class BuyCertificate < self
      # Create a buy certificate action
      #
      # @example
      #   Baron::Action::BuyCertificate.new(player, certificate, source)
      #
      # @api public
      # @param [Baron::Player] player The player making the purchase
      # @param [Baron::Shareholder] source The source of the certificiate
      # @param [Baron::Certificate] certificate The certificate being purchased
      # @param [Baron::Money] price The price being paid
      def initialize(player, source, certificate, price)
        @player = player
        @source = source
        @certificate = certificate
        @price = price
        create_transaction
      end

      private

      # Create a transaction to transfer the certificate for money
      #
      # @api private
      # @return [Baron::Transaction] The transaction created
      def create_transaction
        Transaction.new(
          @player,
          [@certificate],
          @source,
          [@price]
        )
      end
    end
  end
end

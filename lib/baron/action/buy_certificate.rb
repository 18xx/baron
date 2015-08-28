module Baron
  class Action
    # Buy certificate allows a player to purchase a certificate from a
    # shareholder. Usually the initial offering or the bank pool.
    class BuyCertificate < self
      # The certificate being purchased
      #
      # @example
      #   action.certificate
      #
      # @api public
      # @return [Baron::Certificate]
      attr_reader :certificate

      # Create a buy certificate action
      #
      # @example
      #   Baron::Action::BuyCertificate.new(player, certificate, source)
      #
      # @api public
      # @param [Baron::Player] player The player making the purchase
      # @param [Baron::Shareholder] source The source of the certificiate
      # @param [Baron::Certificate] certificate The certificate being purchased
      def initialize(player, source, certificate)
        @player = player
        @source = source
        @certificate = certificate
      end

      # Create a transaction to transfer the certificate for money
      #
      # @api private
      # @return [Baron::Transaction] The transaction created
      def create_transaction
        Transaction.new(
          @player,
          [@certificate],
          @source,
          [@source.cost(@certificate)]
        )
      end
    end
  end
end

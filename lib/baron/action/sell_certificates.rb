# frozen_string_literal: true
module Baron
  class Action
    # Sell one or more certificates to the bank for the current market price
    class SellCertificates < self
      # Create the sell certificates action
      #
      # @example
      #   Baron::Action::SellCertificates.new(player, bank, certificates)
      #
      # @api public
      # @param [Baron::Player] player
      # @param [Baron::Bank] bank
      # @param [Baron::Market] market
      # @param [Array<Baron::Certificate>] certificates
      def initialize(player, bank, market, certificates)
        @player = player
        @bank = bank
        @market = market
        @certificates = certificates
      end

      # Create the transaction to transfer the certificates to the bank
      #
      # The player will receive the appropriate value of each of the
      # certificates
      #
      # @example
      #   sell_certificates.create_transaction
      #
      # @api public
      # @return [void]
      def create_transaction
        Transaction.new(
          @bank,
          @certificates,
          player,
          [proceeds]
        )
        reduce_prices
      end

      private

      # Reduce the prices of the companies for shares sold
      #
      # @api private
      # @return [void]
      def reduce_prices
        @certificates.each do |cert|
          @market.change_price(cert.company, -cert.num_shares)
        end
      end

      # Determine how much the certificates will be sold for
      #
      # @api private
      # @return [Baron::Money]
      def proceeds
        @certificates.map do |cert|
          @market.price(cert.company) * cert.num_shares
        end.inject(:+)
      end
    end
  end
end

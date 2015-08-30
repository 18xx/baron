module Baron
  class Action
    # BuyTrain allows a company to purchase a train from either the
    # initial offering, bank pool, or another company
    class BuyTrain < self
      # The train being purchased
      #
      # @example
      #   action.train
      #
      # @api public
      # @return [Baron::Train]
      attr_reader :train

      # Create a buy train action
      #
      # @example
      #   Baron::Action::BuyTrain.new(company, source, train, amount)
      #
      # @api public
      # @param [Baron::Company] company The company making the purchase
      # @param [Baron::Shareholder] source The source of the train
      # @param [Baron::Train] certificate The certificate being purchased
      # @param [Baron::Money] amount The amount that the train is being
      # purchased for. If not specified, it will be bought at face value
      def initialize(company, source, train, amount)
        @company = company
        @source = source
        @train = train
        @amount = amount
      end

      # Create a transaction to transfer the certificate for money
      #
      # @api private
      # @return [Baron::Transaction] The transaction created
      def create_transaction
        Transaction.new(
          @company,
          [@train],
          @source,
          [@amount]
        )
      end
    end
  end
end

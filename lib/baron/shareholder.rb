module Baron
  # A shareholder is someone who can hold certificates in a company. This will
  # include things like players, companies (if the game supports companies
  # owning their own shares, private companies, or shares in other companies),
  # the bank pool, and the initial offering.
  module Shareholder
    # The current amount of money that this shareholder has
    #
    # @example
    #   shareholder.balance
    #   # returns the amount of money they currently have
    #
    # @api public
    # @return [Money] The total amount of money this sharehold currently has
    def balance
      money_total(:credits) - money_total(:debits)
    end

    # Adds a transaction to this shareholder
    #
    # @example
    #   shareholder.add_transaction(transaction)
    #   # adds the transaction to the list of transactions, then
    #   # returns all transactions for this shareholder
    #
    # @api public
    # @param [Baron::Transaction] transaction
    # @return [Array<Baron::Transaction>] The transactions that this shareholder
    # has participated in
    def add_transaction(transaction)
      transactions.push transaction
    end

    private

    # The total amount that was given in credits or debits
    #
    # @api private
    # @param [Symbol] type :credits or :debits
    # @return [Baron::Money]
    def money_total(type)
      transaction_details(type).select do |value|
        value.instance_of? Money
      end.inject(:+)
    end

    # Get the credits or debits from the transaction
    #
    # @api private
    # @param [Symbol] type :credits or :debits
    # @return [Array<Baron::Transaction>]
    def transaction_details(type)
      transactions.flat_map do |transaction|
        transaction.public_send type, self
      end
    end

    # The transactions that this shareholder has made
    #
    # @api private
    # @return [Array<Baron::Transaction>]
    def transactions
      @transactions ||= []
    end
  end
end

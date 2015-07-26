module Baron
  # A shareholder is someone who can hold certificates in a company. This will
  # include things like players, companies (if the game supports companies
  # owning their own shares, private companies, or shares in other companies),
  # the bank pool, and the initial offering.
  module Shareholder
    # The current amount of money that this shareholder has
    #
    # @return [Money]
    def balance
      money_total(:credits) - money_total(:debits)
    end

    # Adds a transaction to this shareholder
    #
    # @param [Transaction] transaction
    def add_transaction(transaction)
      transactions.push transaction
    end

    private

    def money_total(type)
      transaction_details(type).select do |value|
        value.instance_of? Money
      end.inject(:+)
    end

    def transaction_details(type)
      transactions.flat_map do |transaction|
        transaction.public_send type, self
      end
    end

    def transactions
      @transactions ||= []
    end
  end
end

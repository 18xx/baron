module Baron
  # The bank represents the source of money for turns and other financial
  # aspects of the company. It can hold money, company shares (in the bank pool)
  # trains, and more.
  class Bank
    include Shareholder

    # Return a string representation of the bank
    #
    # @api private
    # @return [String]
    def inspect
      "#<Baron::Bank:#{object_id}>"
    end
  end
end

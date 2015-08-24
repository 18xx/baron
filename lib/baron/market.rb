module Baron
  # The market manages the open market pricing for shares in a company
  #
  # The market price is affected by dividend payouts, share sales, and more.
  # The price will generally increase for paying dividends, decrease for not
  # paying a dividend, and decrease for sales of shares in the company.
  class Market
    # Initialize the market
    #
    # @example
    #   Baron::Market.new rules
    #
    # @api public
    # @param [Baron::Rules]
    def initialize(rules)
      @rules = rules
      @current_prices = {}
    end

    # Add a company to the market
    #
    # This action will generally be taken when the company's directors
    # certificate is purchased.
    #
    # @example
    #   market.add_company(company, Baron::Money.new(90))
    #
    # @api public
    # @param [Baron::Company] company
    # @param [Baron::Money] starting_price
    # @return [void]
    def add_company(company, starting_price)
      amount = starting_price.amount
      fail InvalidStartingPrice unless
        @rules.market_values.include?(amount)
      @current_prices[company] = amount
    end

    # Get the current price for a share in a company
    #
    # @example
    #   market.price(company)
    #
    # @api public
    # @param [Baron::Company] company
    # @return Baron::Money
    def price(company)
      Money.new @current_prices.fetch(company)
    end

    # The price used is not a valid starting price on the market
    class InvalidStartingPrice < StandardError
    end
  end
end
module Baron
  # The bank represents the source of money for operations and other financial
  # aspects of the company. It can hold money, company shares (in the bank pool)
  # trains, and more.
  module Bank
    include Shareholder
  end
end

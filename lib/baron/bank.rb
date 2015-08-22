module Baron
  # The bank represents the source of money for turns and other financial
  # aspects of the company. It can hold money, company shares (in the bank pool)
  # trains, and more.
  class Bank
    include Shareholder
  end
end

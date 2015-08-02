module Baron
  class Company
    # A major company represents a 10 share company in an 18xx Game
    # It has a directors certificate which represents a 20% stake in the company
    # and eight standard certificates each representing a 10% stake
    class MajorCompany < self
      include Shareholder
    end
  end
end

# frozen_string_literal: true
module Baron
  class Company
    # A major company represents a 10 share company in an 18xx Game
    # It has a directors certificate which represents a 20% stake in the company
    # and eight standard certificates each representing a 10% stake
    class MajorCompany < self
      include Shareholder

      # Has this company floated?
      #
      # Once a company has sold a particular threshold of certificates, the
      # company is floated, and begins operating. The first thing that happens
      # when a company floats is that it is given is operating capital.
      #
      # @example
      #   company.floated?
      #
      # @api public
      # @return [Boolean]
      def floated?
        transactions.any?
      end
    end
  end
end

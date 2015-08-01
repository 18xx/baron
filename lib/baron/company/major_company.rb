module Baron
  module Company
    # A major company represents a 10 share company in an 18xx Game
    # It has a directors certificate which represents a 20% stake in the company
    # and eight standard certificates each representing a 10% stake
    class MajorCompany
      include Shareholder

      # The full name of the company
      #
      # @example
      #   company.abbreviation #=> 'London and North Western Railway'
      #
      # @api public
      # @return [String]
      attr_reader :name

      # The short abbreviation for the company
      #
      # @example
      #   company.abbreviation #=> 'LNWR'
      #
      # @api public
      # @return [String]
      attr_reader :abbreviation

      # Initialize the Company
      #
      # @example
      #   Baron::Company::MajorCompany.new('CPR', 'Canadian Pacific Railway')
      #
      # @api public
      # @param [String] abbreviation
      # @param [String] name
      def initialize(abbreviation, name)
        @name = name
        @abbreviation = abbreviation
      end

      # Convert the company to a string containing their abbreviation
      #
      # @example
      #  company.to_s #=> 'CPR'
      #
      # @api public
      # @return [String]
      def to_s
        abbreviation
      end
    end
  end
end

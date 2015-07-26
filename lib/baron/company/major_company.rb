module Baron
  module Company
    # A major company represents a 10 share company in an 18xx Game
    # It has a directors certificate which represents a 20% stake in the company
    # and eight standard certificates each representing a 10% stake
    class MajorCompany
      include Shareholder

      # The full name of the company
      # Example: London and North Western Railway
      #
      # @return [String]
      attr_reader :name

      # The short abbreviation for the company.
      # Example: LNWR
      #
      # @return [String]
      attr_reader :abbreviation

      # Initialize the Company
      #
      # @param [String] abbreviation
      # @param [String] name
      def initialize(abbreviation, name)
        @name = name
        @abbreviation = abbreviation
      end

      # Convert the company to a string containing their abbreviation
      #
      # @return [String]
      def to_s
        abbreviation
      end
    end
  end
end

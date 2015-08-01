module Baron
  module Company
    # A private company represents a single certificate company which can be
    # owned by a single player or company. It has a face value, and provides a
    # fixed income to the player every operating round.
    class PrivateCompany
      # The full name of the private company
      #
      # @example
      #   private_company.name #=> 'Camden & Amboy'
      #
      # @api public
      # @return [String]
      attr_reader :name

      # The face value of the company
      #
      # @example
      #   private_company.face_value #=> 100
      #
      # @api public
      # @return [Fixnum]
      attr_reader :face_value

      # The recurring revenue earned every operating round
      #
      # This revenue is paid during the private operation phase of the turn.
      #
      # @example
      #   private_company.revenue #=> 10
      #
      # @api public
      # @return [Fixnum]
      attr_reader :revenue

      # Initialize the private company
      #
      # @example
      #   Baron::Company::PrivateCompany.new(
      #     'company',
      #     face_value: 100,
      #     revenue: 10
      #   )
      #
      # @api public
      # @param [Fixnum] name
      # @param [Fixnum] face_value
      # @param [Fixnum] revenue
      def initialize(name, face_value:, revenue:)
        @name = name
        @face_value = face_value
        @revenue = revenue
      end

      # Convert the company to a string containing their full name
      #
      # @example
      #   private_company.to_s
      #
      # @api public
      # @return [String] The name of the company
      def to_s
        name
      end
    end
  end
end

# frozen_string_literal: true
module Baron
  class Company
    # A private company represents a single certificate company which can be
    # owned by a single player or company. It has a face value, and provides a
    # fixed income to the player every operating round.
    class PrivateCompany < self
      # The face value of the company
      #
      # @example
      #   private_company.face_value #=> $100
      #
      # @api public
      # @return [Baron::Money]
      attr_reader :face_value

      # The recurring revenue earned every operating round
      #
      # This revenue is paid during the private turn phase of the turn.
      #
      # @example
      #   private_company.revenue #=> $10
      #
      # @api public
      # @return [Baron::Money]
      attr_reader :revenue

      # Initialize the private company
      #
      # @example
      #   Baron::Company::PrivateCompany.new(
      #     'company',
      #     'P1',
      #     face_value: Baron::Money.new(100),
      #     revenue: Baron::Money.new(10)
      #   )
      #
      # @api public
      # @param [String] abbreviation
      # @param [String] name
      # @param [Baron::Money] face_value
      # @param [Baron::Money] revenue
      def initialize(abbreviation, name, face_value:, revenue:)
        super(abbreviation, name)
        @face_value = face_value
        @revenue = revenue
      end
    end
  end
end

module Baron
  module Action
    # This action allows the player to select a private company that they are
    # permitted to purchase.
    class SelectPrivateCompany < Base
      # The private company the player has selected
      #
      # @return [Baraon::Company::PrivateCompany]
      attr_reader :company

      # Create the action where the player is selecting the company.
      #
      # @param [Baron::Player] player The player acting
      # @param [Baron::Company::PrivateCompany] company The company the player
      # has chosen to purchase.
      def initialize(player, company)
        super(player)
        @company = company
      end
    end
  end
end

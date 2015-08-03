module Baron
  # The initial offering is where company certificates, and trains are held
  # until they are purchased by a player or corporation.
  #
  # Note: Many games treat things held in the initial offering differently
  # than things held in the bank pool for the purposes of pricing, dividend
  # payouts and more.
  class InitialOffering
    include Shareholder

    # Returns the cost of the certificate
    #
    # This will be determined by its face value or par price.
    #
    # @example
    #   initial_offering.cost(certificate) #=> $100
    #
    # @api public
    # @param [Baron::Certificate] certificate
    # @return [Baron::Money]
    def cost(certificate)
      certificate.company.face_value
    end
  end
end

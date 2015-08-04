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
      company = certificate.company
      if company.respond_to?(:face_value)
        company.face_value
      else
        get_par_price(company) * certificate.num_shares
      end
    end

    # Set the par price for a major company
    #
    # @example
    #   initial_offering.get_par_price(company) #=> Baron::Money.new(100)
    #
    # @api public
    # @param [Baron::Company] company
    # @return [Baron::Money]
    def get_par_price(company)
      @par_prices ||= {}
      @par_prices[company]
    end

    # Set the par price for a major company
    #
    # @example
    #   initial_offering.set_par_price(company, Baron::Money.new(100))
    #
    # @api public
    # @param [Baron::Company] company
    # @param [Baron::Money] par_price
    # @return [void]
    def set_par_price(company, par_price)
      fail(
        ParPriceAlreadySet,
        "Attempted to reset par price for #{company}"
      ) if get_par_price(company)
      @par_prices[company] = par_price
    end

    # The par price has alreay been set
    #
    # It can only be set once on a major company
    class ParPriceAlreadySet < StandardError
    end
  end
end

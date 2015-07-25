module Baron
  # A certificate represents a portion of ownership in a company.
  #
  # This entitlesthe owner to certain privileges including payment of dividends.
  # Players are generally limited on the number of certificates that they can
  # own at any given time.
  class Certificate
    # The company which this certificate is for
    #
    # @return Baron::Company
    attr_reader :company

    # The portion of the company this share is for
    #
    # @return BigDecimal
    attr_reader :portion

    # Initialize the certificate
    #
    # @param [Company] company
    # @param [BigDecimal] portion
    def initialize(company, portion)
      @company = company
      @portion = portion
    end
  end
end

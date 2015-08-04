module Baron
  # A certificate represents a portion of ownership in a company.
  #
  # This entitlesthe owner to certain privileges including payment of dividends.
  # Players are generally limited on the number of certificates that they can
  # own at any given time.
  class Certificate
    # The company which this certificate is for
    #
    # @example
    #   certificate.company
    #
    # @api public
    # @return Baron::Company
    attr_reader :company

    # The portion of the company this share is for
    #
    # @example
    #   certificate.portion
    #
    # @api public
    # @return BigDecimal
    attr_reader :portion

    # Initialize the certificate
    #
    # @example
    #   Baron::Certificate(company, BigDecimal.new('0.20'))
    #
    # @api public
    # @param [Company] company
    # @param [BigDecimal] portion
    def initialize(company, portion)
      @company = company
      @portion = portion
    end

    # Returns the number of shares that this certificate provides
    #
    # For a standard 10 share major company, this will be 2 shares for the
    # directors certificate, and 1 share for all others.
    #
    # @example
    #   Baron::Certificate(company, BigDecimal.new('0.20')).num_shares #=> 2
    #
    # @api public
    # @return [Fixnum] The number of shares this represents.
    def num_shares
      case portion
      when BigDecimal.new('0.2')
        2
      else
        1
      end
    end
  end
end

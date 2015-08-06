module Baron
  # The unavailable certificates pool will store companies that can't be
  # purchased for whatever reason. Examples would be shares in companies that
  # can't be purchased, because they haven't been started.
  class UnavailableCertificatesPool
    include Shareholder

    # Makes a company certificate available to the pool
    #
    # If the company is a major company, it will transfer its directors
    # certificate to the pool, otherwise it will transfer the private
    # comapny certificate to the pool.
    #
    # @example
    #   unavailable_certificates_pool.make_available company, initial_offering
    #
    # @api public
    # @param [Baron::Company] company
    # @param [Baron::InitialOffering] initial_offering
    # @return [void]
    def make_available(company, initial_offering)
      Transaction.new(
        initial_offering,
        [find_controlling_certificate(company)],
        self,
        []
      )
    end

    private

    # Finds the controlling certificate for a company
    #
    # If this is a company which has a directors certificate, it will return
    # that, otherwise the only certificate.
    #
    # @api private
    # @param [Baron::Company] company
    # @return [Baron::Certificate]
    def find_controlling_certificate(company)
      certificates.select(&:controlling?).find do |cert|
        cert.company.equal? company
      end
    end
  end
end

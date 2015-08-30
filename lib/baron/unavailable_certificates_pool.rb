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
    #   unavailable_certificates_pool.make_company_available(
    #     company, initial_offering
    #   )
    #
    # @api public
    # @param [Baron::Company] company
    # @param [Baron::InitialOffering] initial_offering
    # @return [void]
    def make_company_available(company, initial_offering)
      make_certificate_available(
        find_controlling_certificate(company),
        initial_offering
      )
    end

    # Makes a specific certificate available
    #
    # @example
    #   unavailable_certificates_pool.make_certificate_available
    #
    # @api public
    # @param [Baron::Certificate] certificate
    # @param [Baron::InitialOffering] initial_offering
    # @return [void]
    def make_certificate_available(certificate, initial_offering)
      give initial_offering, certificate
    end

    # Return a string representation of the pool
    #
    # @api private
    # @return [String]
    def inspect
      "#<Baron::UnavailableCertificatesPool:#{object_id}>"
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

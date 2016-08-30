# frozen_string_literal: true
module Baron
  # A shareholder is someone who can hold certificates in a company. This will
  # include things like players, companies (if the game supports companies
  # owning their own shares, private companies, or shares in other companies),
  # the bank pool, and the initial offering.
  module Shareholder
    # The current amount of money that this shareholder has
    #
    # @example
    #   shareholder.balance
    #   # returns the amount of money they currently have
    #
    # @api public
    # @return [Money] The total amount of money this sharehold currently has
    def balance
      money_total(:credits) - money_total(:debits)
    end

    # The certificates this shareholder currently has
    #
    # @example
    #   shareholder.certificates
    #
    # @api public
    # @return [Array<Baron::Certificate>] All certificates this shareholder has
    def certificates
      currently_owned(Transaction::IS_CERTIFICATE)
    end

    # The trains this shareholder currently has
    #
    # @example
    #   shareholder.trains
    #
    # @api public
    # @return [Array<Baron::Train>] All trains this shareholder has
    def trains
      currently_owned(Transaction::IS_TRAIN)
    end

    # The largest train by major station allowance
    #
    # @example
    #   shareholder.largest_train
    #
    # @api public
    # @return [Fixnum] The number of major stations the largest train is
    # allowed to hit. nil if the company has no trains
    def largest_train
      trains.map { |train| train.type.major_station_allowance }.max
    end

    # Returns all of the certificates for the matching company
    #
    # @example
    #   sharholder.certificates_for(company)
    #
    # @api public
    # @return [Array<Baron::Certificate>] The certificates for the matching
    # company. If the sharholder has no certificates, then an empty array
    # will be returned
    def certificates_for(company)
      certificates.select do |cert|
        cert.company.equal? company
      end
    end

    # Returns the percentage of the company by this sharedholder
    #
    # @example
    #   shareholder.percentage_owned(company)
    #
    # @api public
    # @return [BigDecimal] The percantage of this company owned by the
    # shareholder. If this shareholder owns no shares, then 0 is returned.
    def percentage_owned(company)
      certificates_for(company).map(&:portion).inject(:+) || 0
    end

    # Return the companies that this shareholder is a director of
    #
    # @example
    #   shareholder.directorships
    #
    # @api public
    # @return [Array<Baron::Company>] The companies that this shareholder is
    # the director of. If the player is not a director of any companies it will
    # be an empty array.
    def directorships
      certificates.select(&:director?).map(&:company)
    end

    # Return the private companies that this shareholder currently owns
    #
    # @example
    #   shareholder.private_companies
    #
    # @api public
    # @return [Array<Baron::Company::PrivateCompany>] The private companies
    # that this shareholder currently owns
    def private_certificates
      certificates.select do |cert|
        cert.company.instance_of? Company::PrivateCompany
      end
    end

    # Adds a transaction to this shareholder
    #
    # @example
    #   shareholder.add_transaction(transaction)
    #   # adds the transaction to the list of transactions, then
    #   # returns all transactions for this shareholder
    #
    # @api public
    # @param [Baron::Transaction] transaction
    # @return [Array<Baron::Transaction>] The transactions that this shareholder
    # has participated in
    def add_transaction(transaction)
      transactions.push transaction
    end

    # Give the shareholder the transferrable item at no cost
    #
    # @example
    #   bank.give(shareholder, Baron::Money.new(10))
    #
    # @api public
    # @param [Baron::Shareholder] shareholder The recipient of the transfer
    # @param [Baron::Transferrable] transferrable The thing to transfer
    # @return [Baron::Transaction] The transaction transferring things
    def give(shareholder, transferrable)
      Transaction.new shareholder, Array(transferrable), self, []
    end

    # Get the transferrable item from no recipient
    #
    # This should not generally be used in the course of the normal game,
    # as money will move between the bank, and players. However, to set the
    # game up, the bank money needs to come from somewhere. Therefore, we
    # can grant something to come from no source.
    #
    # @example
    #   bank.grant(Baron::Money.new(12_000))
    #
    # @api public
    # @param [Baron::Transferrable] transferrable The thing to transfer. This
    # can also take in an array of Transferrable objects
    # @return [Baron::Transaction] The transaction transferring things
    def grant(transferrable)
      Transaction.new self, Array(transferrable), nil, []
    end

    private

    # The type of items to purchase
    #
    # @api private
    # @param [Symbol] type A symbol accepted by trains incoming/outgoing such
    # as :certificates or :trains
    # @return [Array<Baron::Train>] All trains this shareholder has
    def currently_owned(type)
      transactions.each_with_object([]) do |transaction, certs|
        certs.concat(transaction.incoming(self, type))
        certs.reject! do |cert|
          transaction.outgoing(self, nil).any? do |outgoing_cert|
            outgoing_cert.equal?(cert)
          end
        end
      end
    end

    # The total amount that was given in credits or debits
    #
    # @api private
    # @param [Symbol] type :credits or :debits
    # @return [Baron::Money]
    def money_total(type)
      transaction_details(type).select do |value|
        value.instance_of? Money
      end.inject(:+) || Money.new
    end

    # Get the credits or debits from the transaction
    #
    # @api private
    # @param [Symbol] type :credits or :debits
    # @return [Array<Baron::Transaction>]
    def transaction_details(type)
      transactions.flat_map do |transaction|
        transaction.public_send type, self
      end
    end

    # The transactions that this shareholder has made
    #
    # @api private
    # @return [Array<Baron::Transaction>]
    def transactions
      @transactions ||= []
    end
  end
end

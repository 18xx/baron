# frozen_string_literal: true
module Baron
  # A transaction is the exchange of money, trains, certificates, or other
  # purchasable items between two parties.
  #
  # The parties involved in the transaction could be the players, companies,
  # the bank pool, the initial offering, or other concepts in the game.
  #
  # The transaction will have a buyer, and a seller. The buyer receives the
  # buyer items and the seller receives the seller items.
  #
  # The names buyer and seller are not important to the transaction, but merely
  # a convenient metaphor as these actions usually involve cash.
  class Transaction
    # A simple proc for determining if an item is a certificate
    IS_CERTIFICATE = -> (item) { item.instance_of? Certificate }
    #
    # A simple proc for determining if an item is a train
    IS_TRAIN = -> (item) { item.instance_of? Train }

    # One of the parties participating in the transacion, labelled as the buyer
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.buyer #=> buyer
    #
    # @api public
    # @return [Object]
    attr_reader :buyer

    # The items the buyer is receiving
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.buyer_items #=> buyer_items
    #
    # @api public
    # @return [Array<Object>]
    attr_reader :buyer_items

    # The second party participating in the transaction, labelled as the seller
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.seller #=> seller
    #
    # @api public
    # @return [Object]
    attr_reader :seller

    # The items the seller is receiving
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.seller_items #=> seller_items
    #
    # @api public
    # @return [Array<Object>]
    attr_reader :seller_items

    # Initialize the object
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #
    # @api public
    # @param [Object] buyer
    # @param [Array<Object>] buyer_items
    # @param [Object] seller
    # @param [Array<Object>] seller_items
    def initialize(buyer, buyer_items, seller, seller_items)
      @buyer = buyer
      @buyer_items = buyer_items
      @seller = seller
      @seller_items = seller_items

      validate_items
      validate_transferrable
      validate_ownership
      notify_parties
      notify_item_ownership
    end

    # The items which the shareholder transferred away
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.debits(buyer) #=> seller_items
    #
    # @api public
    # @param [Shareholder] shareholder
    # @return [Array<Object>] The objects transferred away
    def debits(shareholder)
      shareholder_effects(shareholder, :debit)
    end

    # The items which the shareholder received
    #
    # @example
    #   transaction = Baron::Transaction.new(
    #     buyer, buyer_items, seller, seller_items
    #   )
    #   transaction.credits(buyer) #=> buyuer_items
    #
    # @api public
    # @param [Shareholder] shareholder
    # @return [Array<Object>] The objects receieved
    def credits(shareholder)
      shareholder_effects(shareholder, :credit)
    end

    # The items the shareholder receieves in this transaction
    #
    # @api private
    # @param [Baron::Shareholder] shareholder
    # @param [Proc] filter A selector such as IS_CERTIFICATE or IS_TRAIN
    # @return [Array<Baron::Certificate>]
    def incoming(shareholder, filter)
      credits(shareholder).select(&filter)
    end

    # The items the shareholder loses in this transaction
    #
    # @api private
    # @param [Baron::Shareholder] shareholder
    # @param [Proc] filter A selector such as IS_CERTIFICATE or IS_TRAIN
    # @return [Array<Baron::Certificate>]
    def outgoing(shareholder, filter)
      debits(shareholder).select(&filter)
    end

    private

    # Return the items that changed hands for the type and shareholder
    #
    # The items the shareholder was debited if type is :debit, or credited
    # if type is :credit
    #
    # @api private
    # @param [Baron::Shareholder] shareholder
    # @param [Symbol] type Either :debit or :credit
    # @return [Array<Object>] The objects transferred
    def shareholder_effects(shareholder, type)
      validate(shareholder)
      effects.fetch(shareholder).fetch(type)
    end

    # Return a hash explaining the effects of this transaction
    #
    # The hash format is as follows:
    # {
    #   buyer => {
    #     :debit => {the items the buyer gave up},
    #     :credit => {the items the buyer received}
    #   },
    #   seller => {
    #     :debit => {the items the seller gave up},
    #     :credit => {the items the seller received}
    #   }
    # }
    #
    # @api private
    # @return [Hash] The effects for buyer and seller
    def effects
      {
        buyer => { debit: seller_items, credit: buyer_items },
        seller => { debit: buyer_items, credit: seller_items }
      }
    end

    # Validate that the shareholder is a party to this transaction
    #
    # It will raise an InvalidPartyError if they are not a party to this
    # transaction
    #
    # @api private
    # @param [Baron::Shareholder] shareholder
    # @return [void]
    def validate(shareholder)
      fail InvalidPartyError unless [buyer, seller].include?(shareholder)
    end

    # Validate the items are an array of items
    #
    # @api private
    # @return [void]
    def validate_items
      [buyer_items, seller_items].each do |items|
        fail InvalidItemsError unless items.kind_of?(Enumerable)
      end
    end

    # Validate the items in this transaction are all transferrable
    #
    # @api private
    # @return [void]
    def validate_transferrable
      (buyer_items + seller_items).each do |item|
        fail NonTransferrableError unless item.kind_of?(Transferrable)
      end
    end

    # Validate the items being transferred to the buyer are owned by the seller
    #
    # @api private
    # @return [void]
    def validate_ownership
      buyer_items.each { |item| item.validate_owner seller }
      seller_items.each { |item| item.validate_owner buyer }
    end

    # Notifies the parties that the transaction has taken place
    #
    # @api private
    # @return [void]
    def notify_parties
      buyer.add_transaction self
      seller.add_transaction self if seller
    end

    # Notifies the items that they are now owned by someone
    #
    # @api private
    # @return [void]
    def notify_item_ownership
      [[buyer, buyer_items], [seller, seller_items]].each do |set|
        shareholder, items = set
        items.each do |item|
          item.owner = shareholder
        end
      end
    end

    # This party is not involved in the transaction
    class InvalidPartyError < StandardError
    end

    # Items must be an array, or nil
    class InvalidItemsError < StandardError
    end

    # Items must be tranferrable to be involved in a transaction
    class NonTransferrableError < StandardError
    end
  end
end

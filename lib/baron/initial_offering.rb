module Baron
  # The initial offering is where company certificates, and trains are held
  # until they are purchased by a player or corporation.
  #
  # Note: Many games treat things held in the initial offering differently
  # than things held in the bank pool for the purposes of pricing, dividend
  # payouts and more.
  module InitialOffering
    include Shareholder
  end
end

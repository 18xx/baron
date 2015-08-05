module Baron
  # The unavailable certificates pool will store companies that can't be
  # purchased for whatever reason. Examples would be shares in companies that
  # can't be purchased, because they haven't been started.
  class UnavailableCertificatesPool
    include Shareholder
  end
end

# frozen_string_literal: true
RSpec.describe Baron::Action::StartCompany do
  let(:action) do
    described_class.new(
      game,
      player_a,
      company,
      par_price
    )
  end
  let(:game) { Baron::Game.new(rules, players) }
  let(:rules) { Baron::Rules.new('1860') }
  let(:player_a) { Baron::Player.new('a') }
  let(:player_b) { Baron::Player.new('b') }
  let(:players) do
    [
      player_a,
      player_b
    ]
  end
  let(:company) do
    game.rules.companies.find { |c| c.abbreviation == 'FYN' }
  end
  let(:par_price) { Baron::Money.new(68) }

  describe '#setup' do
    subject { action.setup }

    it 'sets the par price of the company' do
      subject
      expect(game.initial_offering.get_par_price(company).amount).to be 68
    end

    it 'sets the market price of the company' do
      subject
      expect(game.market.price(company).amount).to be 68
    end

    it 'makes the certificates available' do
      subject
      expect(game.initial_offering.certificates_for(company).count).to be 8
    end

    it 'transfers the directors certificate to the player' do
      subject
      certs = player_a.certificates_for(company)
      expect(certs.count).to be 1
      expect(certs.first.director?).to be true
    end

    it 'transfers money away from the player' do
      game
      expect { subject }.to change { player_a.balance }.by(
        Baron::Money.new(-136)
      )
    end
  end
end

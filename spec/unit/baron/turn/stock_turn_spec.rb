RSpec.describe Baron::Turn::StockTurn do
  let(:turn) { described_class.new player, round }

  let(:player) { instance_double Baron::Player }
  let(:round) { instance_double Baron::Round::StockRound, game: game }
  let(:game) do
    instance_double Baron::Game, initial_offering: ipo, bank: bank
  end
  let(:ipo) { instance_double Baron::InitialOffering }
  let(:bank) { Baron::Bank.new }

  let(:certificate) { instance_double Baron::Certificate, company: company }
  let(:company) { instance_double Baron::Company }

  describe '#player' do
    subject { turn.player }

    it 'returns the player' do
      should be player
    end
  end

  describe '#round' do
    subject { turn.round }

    it 'returns the round' do
      should be round
    end
  end

  describe '#done?' do
    subject { turn.done? }
    let(:company) do
      instance_double Baron::Company::MajorCompany, floated?: true
    end
    let(:certificate) do
      instance_double Baron::Certificate, company: company
    end

    context 'when the user has not bought a certificate' do
      it { should be false }
    end

    context 'when the user has bought a certificate' do
      let(:action) do
        Baron::Action::BuyCertificate.new(
          player,
          nil,
          certificate
        )
      end

      before do
        allow(action).to receive(:create_transaction)
        allow(action).to receive(:symbol).and_return(:buycertificate)
        turn.perform action
      end

      it { should be true }
    end
  end

  describe 'buy certificate' do
    let(:source) { double }
    let(:floated) { true }
    let(:company) do
      Baron::Company::MajorCompany.new('LNWR', 'LNWR')
    end
    let(:certificate) do
      instance_double Baron::Certificate, company: company
    end
    let(:action) do
      Baron::Action::BuyCertificate.new(
        player,
        source,
        certificate
      )
    end
    subject { turn.perform action }
    let(:percent_in_ipo) { BigDecimal.new('0.8') }

    before do
      allow(action).to receive(:create_transaction)
      allow(ipo).to receive(:percentage_owned).with(company).and_return(
        percent_in_ipo
      )
      allow(ipo).to receive(:get_par_price).with(company).and_return(
        Baron::Money.new(90)
      )
    end

    it 'makes the turn done' do
      subject
      expect(turn).to be_done
    end

    it 'creates the transaction' do
      expect(action).to receive(:create_transaction).once
      subject
    end

    context 'when the certificate does not cause the company to float' do
      let(:percent_in_ipo) { BigDecimal.new('0.6') }

      it 'does not transfers starting capital to the company' do
        subject
        expect(company.balance).to eq Baron::Money.new(0)
      end
    end

    context 'when that certificate causes the company to float' do
      let(:percent_in_ipo) { BigDecimal.new('0.5') }

      it 'transfers starting capital to the company' do
        subject
        expect(company.balance).to eq Baron::Money.new(900)
      end

      it 'takes the money from the bank' do
        expect { subject }.to change { bank.balance }.by(
          Baron::Money.new(-900)
        )
      end
    end
  end

  describe 'pass' do
    subject { turn.perform Baron::Action::Pass.new(player) }

    it 'makes the turn done' do
      subject
      expect(turn).to be_done
    end

    it 'makes the turn passed' do
      subject
      expect(turn).to be_passed
    end
  end

  describe '#available_actions' do
    subject { turn.available_actions }

    context 'when the player has not taken an action' do
      it 'allows the player to buy, or pass' do
        should match_array([
          Baron::Action::BuyCertificate,
          Baron::Action::Pass
        ])
      end
    end
  end

  describe '#passed?' do
    subject { turn.passed? }

    context 'when this action was a pass' do
      before { turn.perform Baron::Action::Pass.new(player) }
      it { should be true }
    end

    context 'when the action was not a pass' do
      it { should be false }
    end
  end
end

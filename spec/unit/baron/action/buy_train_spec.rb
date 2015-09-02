RSpec.describe Baron::Action::BuyTrain do
  let(:turn) do
    instance_double Baron::Turn::OperatingTurn, player: player, company: company
  end
  let(:player) { Baron::Player.new('a') }
  let(:company) { Baron::Company.new 'CPR', 'Canadian Pacific' }
  let(:source) { Baron::InitialOffering.new market }
  let(:market) { double }
  let(:train) { Baron::Train.new train_type }
  let(:train_type) { Baron::TrainType.new(3, Baron::Money.new(300)) }

  let(:action) do
    described_class.new turn, source, train, train.type.face_value
  end

  describe '#train' do
    subject { action.train }
    it 'returns the train for the action' do
      should be train
    end
  end

  describe '#process' do
    before do
      source.grant train
    end

    subject { action.process }

    it 'transfers the train to the company' do
      expect { subject }.to change { company.trains.count }.by(1)
    end

    it 'transfers the train away from the source' do
      expect { subject }.to change { source.trains.count }.by(-1)
    end

    it 'deducts money from the company' do
      expect { subject }.to change { company.balance }.by(
        Baron::Money.new(-300)
      )
    end

    it 'adds money to the source' do
      expect { subject }.to change { source.balance }.by(
        Baron::Money.new(300)
      )
    end
  end
end

RSpec.describe Baron::Train do
  let(:train) { described_class.new type }
  let(:type) { instance_double Baron::TrainType }

  subject { train }

  it 'can be owned' do
    should respond_to :owner
  end

  describe '#type' do
    subject { train.type }
    it 'returns the type of this train' do
      should be type
    end
  end
end

# frozen_string_literal: true
RSpec.describe Baron::Train do
  let(:train) { described_class.new type }
  let(:face_value) { Baron::Money.new(100) }
  let(:type) { instance_double Baron::TrainType, face_value: face_value }

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

  describe '#face_value' do
    subject { train.face_value }
    it 'returns the face value' do
      should be face_value
    end
  end
end

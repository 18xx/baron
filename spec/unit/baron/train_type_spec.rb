RSpec.describe Baron::TrainType do
  let(:face_value) { Baron::Money.new(300) }
  let(:train_type) do
    described_class.new(
      3,
      face_value,
      minor_station_allowance: 2,
      rusted_by: rusting_train_type
    )
  end

  let(:rusting_train_type) do
    described_class.new(
      6,
      Baron::Money.new(500),
      minor_station_allowance: 3
    )
  end

  describe '#major_station_allowance' do
    subject { train_type.major_station_allowance }
    it 'returns the major station allowance' do
      should be 3
    end
  end

  describe '#minor_station_allowance' do
    subject { train_type.minor_station_allowance }

    context 'when not specificed' do
      let(:train_type) do
        described_class.new(2, face_value)
      end
      it { should be_nil }
    end

    context 'when specified' do
      it 'returns the minor station allowance' do
        should be 2
      end
    end
  end

  describe '#face_value' do
    subject { train_type.face_value }
    it 'returns the face value' do
      should be face_value
    end
  end

  describe '#rusted_by' do
    subject { train_type.rusted_by }

    context 'when not specificed' do
      let(:train_type) do
        described_class.new(2, face_value)
      end
      it { should be_nil }
    end

    context 'when specified' do
      it 'returns the rusting train type' do
        should be rusting_train_type
      end
    end
  end

  describe '#to_s' do
    subject { train_type.to_s }
    context 'when there is a minor station allowance' do
      it 'returns a string representation containing the minor allowance' do
        should == '3+2T'
      end
    end

    context 'when there is not a minor station allowance' do
      let(:train_type) { described_class.new 2, Baron::Money.new(100) }
      it 'returns a string representation with only the major allowance' do
        should == '2T'
      end
    end
  end
end

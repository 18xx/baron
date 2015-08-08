RSpec.describe Baron::Ownable do
  # Dummy class to test baron ownable
  class Dummy
    include Baron::Ownable
  end
  let(:dummy) { Dummy.new }

  describe '#owner' do
    let(:first_owner) { double }
    let(:second_owner) { double }

    subject { dummy.owner }

    context 'when it has no owner' do
      it { should be_nil }
    end

    context 'when it has an owner' do
      before { dummy.owner = first_owner }

      it { should be first_owner }

      context 'when the owner is changed' do
        before { dummy.owner = second_owner }

        it { should be second_owner }
      end
    end
  end

  describe '#validate_owner' do
    subject { dummy.validate_owner shareholder }
    let(:shareholder) { double Baron::Shareholder, to_s: 'One' }
    before { dummy.owner = owner }

    context 'when the owner is the same as the shareholder' do
      let(:owner) { shareholder }
      it 'does not throw an error' do
        expect { subject }.to_not raise_error
      end
    end

    context 'when the owner is different than the shareholder' do
      let(:owner) { double Baron::Shareholder, to_s: 'Two' }
      it 'raises a NotOwnerError' do
        expect { subject }.to raise_error(
          Baron::Ownable::NotOwnerError,
          'One attempted to sell item owned by Two'
        )
      end
    end
  end
end

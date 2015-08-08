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
end

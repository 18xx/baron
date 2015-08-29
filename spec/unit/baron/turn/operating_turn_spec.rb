RSpec.describe Baron::Turn::OperatingTurn do
  let(:turn) { described_class.new director, company }
  let(:company) { instance_double Baron::Company }
  let(:director) { instance_double Baron::Player }

  describe '#company' do
    subject { turn.company }
    it 'returns the company' do
      should be company
    end
  end

  describe '#director' do
    subject { turn.director }
    it 'returns the director of the company' do
      should be director
    end
  end
end

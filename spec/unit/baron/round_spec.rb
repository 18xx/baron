# frozen_string_literal: true
RSpec.describe Baron::Round do
  let(:round) { described_class.new }

  describe '#over?' do
    subject { round.over? }
    it 'raises an error' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe Baron::Bank do
  describe '#inspect' do
    it 'returns a string representation of the object' do
      expect(subject.inspect).to eq(
        "#<Baron::Bank:#{subject.object_id}>"
      )
    end
  end
end

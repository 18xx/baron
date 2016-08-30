# frozen_string_literal: true
RSpec.describe Baron::Company::MajorCompany do
  let(:abbreviation) { 'LNWR' }
  let(:company) { described_class.new(abbreviation, name) }
  let(:name) { 'London and North Western Railway' }

  describe '#abbrevation' do
    subject { company.abbreviation }
    it 'returns the company abbreviation' do
      should eq 'LNWR'
    end
  end

  describe '#name' do
    subject { company.name }
    it 'returns the company name' do
      should eq 'London and North Western Railway'
    end
  end

  describe '#to_s' do
    subject { company.to_s }
    it 'returns the company abbreviation' do
      should eq 'LNWR'
    end
  end

  describe '#floated?' do
    subject { company.floated? }
    context 'when the company has no transactions' do
      it { should be false }
    end

    context 'when the company has a transaction' do
      before do
        company.grant Baron::Money.new(1000)
      end
      it { should be true }
    end
  end
end

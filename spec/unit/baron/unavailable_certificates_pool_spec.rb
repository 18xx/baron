RSpec.describe Baron::UnavailableCertificatesPool do
  let(:pool) { described_class.new }

  describe '#make_available' do
    let(:major_company_a) { Baron::Company::MajorCompany.new('A', 'Alpha') }
    let(:major_company_b) { Baron::Company::MajorCompany.new('B', 'Bravo') }
    let(:private_company_d) do
      Baron::Company::PrivateCompany.new(
        'D',
        'Delta',
        face_value: 100,
        revenue: 10
      )
    end
    let(:private_company_e) do
      Baron::Company::PrivateCompany.new(
        'E',
        'Echo',
        face_value: 160,
        revenue: 25
      )
    end

    let(:initial_offering) { Baron::InitialOffering.new }

    before do
      certificates = []
      [private_company_d, private_company_e].each do |company|
        certificates << Baron::Certificate.new(
          company, BigDecimal.new('1')
        )
      end

      [major_company_a, major_company_b].each do |company|
        8.times do
          certificates << Baron::Certificate.new(
            company, BigDecimal.new('0.1')
          )
        end
        certificates << Baron::Certificate.new(
          company, BigDecimal.new('0.2')
        )
      end

      Baron::Transaction.new(
        pool,
        certificates,
        nil,
        []
      )
    end

    subject { pool.make_available company, initial_offering }

    context 'when the company is a major company' do
      let(:company) { major_company_a }

      it 'transfers the companies directors certifiate' do
        expect { subject }.to change { pool.certificates.count }.by(-1)
        expect(initial_offering.certificates.count).to be 1
        expect(initial_offering.certificates.first.director?).to be true
        expect(initial_offering.certificates.first.company.name).to eq 'Alpha'
      end
    end

    context 'when the company is a private company' do
      let(:company) { private_company_d }

      it 'transfers the companies directors certifiate' do
        expect { subject }.to change { pool.certificates.count }.by(-1)
        expect(initial_offering.certificates.count).to be 1
        expect(initial_offering.certificates.first.company.name).to eq 'Delta'
      end
    end
  end
end
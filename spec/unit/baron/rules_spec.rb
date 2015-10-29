RSpec.describe Baron::Rules do
  let(:rules_file) { '1860' }
  let(:rules) { described_class.new rules_file }

  describe '#private_companies' do
    subject { rules.private_companies }

    it 'loads all the private companies' do
      expect(subject.count).to eq 5
    end

    it 'initializes them as private companies' do
      expect(subject.all? do |c|
        c.is_a? Baron::Company::PrivateCompany
      end).to be true
    end

    it 'loads their abbreviations' do
      expect(subject.map(&:abbreviation)).to match_array(
        %w(BHC YHC CM&H RP&SC FFC)
      )
    end

    it 'loads their names' do
      expect(subject.map(&:name)).to match_array([
        'Brading Harbour Company',
        'Yarmouth Harbour Company',
        'Cowes Marina and Harbour',
        'Ryde Pier & Shipping Company',
        'Fishbourne Ferry Company'
      ])
    end

    it 'loads their face values' do
      expect(subject.map(&:face_value)).to match_array([
        Baron::Money.new(30),
        Baron::Money.new(50),
        Baron::Money.new(90),
        Baron::Money.new(130),
        Baron::Money.new(200)
      ])
    end

    it 'loads their revenues' do
      expect(subject.map(&:revenue)).to match_array([
        Baron::Money.new(5),
        Baron::Money.new(10),
        Baron::Money.new(20),
        Baron::Money.new(30),
        Baron::Money.new(25)
      ])
    end
  end

  describe '#major_companies' do
    subject { rules.major_companies }

    it 'loads all the major companies' do
      expect(subject.count).to eq 8
    end

    it 'initializes them as major companies' do
      expect(subject.all? do |c|
        c.is_a? Baron::Company::MajorCompany
      end).to be true
    end

    it 'loads their names' do
      expect(subject.map(&:name)).to match_array([
        'Cowes & Newport',
        'Isle of Wight (Eastern Section)',
        'Freshwater, Yarmouth & Newport',
        'Isle of Wight, Newport Junction',
        'Brading Harbour Improvement & Railway',
        'Newport, Godshill & St. Lawrence',
        'Shanklin & Chale',
        'Ventnor, Yarmouth & South Coast'
      ])
    end

    it 'loads their abbreviations' do
      expect(subject.map(&:abbreviation)).to match_array([
        'BHI&R',
        'C&N',
        'FYN',
        'IOW',
        'IWNJ',
        'NGStL',
        'S&C',
        'VYSC'
      ])
    end
  end

  describe '#companies' do
    subject { rules.companies }

    it 'returns their abbreviations' do
      expect(subject.map(&:abbreviation)).to match_array(%w(
        BHC
        YHC
        CM&H
        RP&SC
        FFC
        BHI&R
        C&N
        FYN
        IOW
        IWNJ
        NGStL
        S&C
        VYSC
      ))
    end
  end

  describe '#share_configuration' do
    subject { rules.share_configuration }

    it 'returns the configuration for this company' do
      expect(subject).to match_array([
        0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1
      ])
    end
  end

  describe '#starting_cash' do
    subject { rules.starting_cash 3 }

    it 'returns the money for the number of players' do
      expect(subject).to eq Baron::Money.new(670)
    end
  end

  describe '#auctionable_companies' do
    subject { rules.auctionable_companies }

    it 'returns the 6 auctionable companies' do
      expect(subject.count).to be 6
    end

    it 'returns the set of companies that can be auctioned' do
      expect(subject.map(&:abbreviation)).to match_array(
        %w(BHC YHC CM&H RP&SC IOW C&N)
      )
    end
  end

  describe '#market_values' do
    subject { rules.market_values }

    it 'returns an array of numbers representing the market' do
      expect(subject).to match_array([
        0, 7, 14, 20, 26, 31, 36, 40, 44, 47, 50, 52, 54, 56, 58, 60, 62, 65,
        68, 71, 74, 78, 82, 86, 90, 95, 100, 105, 110, 116, 122, 128, 134, 142,
        150, 158, 166, 174, 182, 191, 200, 210, 220, 230, 240, 250, 260, 270,
        280, 290, 300, 310, 320, 330, 340
      ])
    end
  end

  describe '#trains' do
    subject { rules.trains }

    describe 'types' do
      let(:types) { subject.map(&:type).uniq }
      it 'has 8 types of trains' do
        expect(types.count).to be 8
      end

      it 'has major station allowances for each train' do
        expect(types.map(&:major_station_allowance)).to match_array((2..9).to_a)
      end

      it 'has the face value for each train' do
        expect(types.map { |type| type.face_value.amount }).to contain_exactly(
          250,
          300,
          350,
          400,
          500,
          600,
          700,
          800
        )
      end
    end

    it 'has 34 trains in total' do
      expect(subject.count).to be 34
    end
  end
end

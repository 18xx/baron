RSpec.describe Baron::Rules do
  let(:config_file) { '1860' }
  let(:config) { described_class.new config_file }

  describe '.private_companies' do
    subject { config.private_companies }

    it 'loads all the private companies' do
      expect(subject.count).to eq 5
    end

    it 'initializes them as private companies' do
      expect(subject.all? do |c|
        c.is_a? Baron::Company::PrivateCompany
      end).to be true
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

  describe '.major_companies' do
    subject { config.major_companies }

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
end

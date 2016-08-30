# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Baron::Company do
  let(:company) { described_class.new('Baltimore & Ohio', 'B&O') }

  describe '#face_value' do
    subject { company.face_value }
    it { should be_nil }
  end
end

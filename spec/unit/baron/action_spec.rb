# frozen_string_literal: true
RSpec.describe Baron::Action do
  let(:action) { described_class.new player }
  let(:player) { double }

  describe '#player' do
    subject { action.player }
    it 'returns the player' do
      should be player
    end
  end

  describe '#symbol' do
    subject { action.symbol }

    it 'returns a symbol representation of the class' do
      should be :action
    end

    context 'when the class is subclassed' do
      module Foo
        module Bar
          class Baz < Baron::Action
          end
        end
      end

      let(:action) { Foo::Bar::Baz.new player }

      it 'returns a symbol representation of the class' do
        should be :baz
      end
    end
  end

  describe '#process' do
    subject { action.process }

    it 'is a no-op' do
      expect { subject }.to_not raise_error
    end
  end
end

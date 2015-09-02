RSpec.describe Baron::Turn do
  let(:turn) { Baron::Turn.new }

  # Simple shunt for testing turn related stuff
  class MyTurnNoPass < Baron::Turn
    attr_reader :called, :player

    def initialize(player, available_action)
      @player = player
      @available_action = available_action
    end

    def available_actions
      [@available_action]
    end
  end

  # Simple shunt for testing turn related stuff
  class MyTurn < MyTurnNoPass
    def pass(action)
      @called = action
    end
  end

  describe '#available_actions' do
    subject { turn.available_actions }
    it 'raises a not implemented error' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end

  describe '#player' do
    subject { turn.player }
    it 'raises a not implemented error' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end

  describe '#perform' do
    let(:action) { Baron::Action::Pass.new player }
    let(:player) { double }
    let(:turn) { MyTurn.new(player, available_action) }
    let(:available_action) { action.class }

    subject { turn.perform action }

    context 'when performing an action that is not available' do
      let(:available_action) { Baron::Action::Bid }
      it 'raises as invalid action error' do
        expect { subject }.to raise_error(
          Baron::Turn::InvalidActionError,
          'Attempted to perform Baron::Action::Pass, Allowed Actions: (' \
           '[Baron::Action::Bid])'
        )
      end
    end

    context 'when it is not the players turn' do
      let(:action) { Baron::Action::Pass.new double }
      it 'raises as wrong turn error' do
        expect { subject }.to raise_error(
          Baron::Turn::WrongTurn
        )
      end
    end

    context 'when performing an available action on my turn' do
      it 'calls action process' do
        expect(action).to receive(:process)
        subject
      end

      context 'when the corresponding method exists' do
        it 'calls the corresponding method' do
          expect { subject }.to change { turn.called }.from(nil).to(action)
        end
      end

      context 'when the corresponding method does not exist' do
        let(:turn) { MyTurnNoPass.new(player, available_action) }

        it 'does not call the method' do
          expect { subject }.to_not change { turn.called }
        end

        it 'does not raise an error' do
          expect { subject }.to_not raise_error
        end
      end
    end
  end
end

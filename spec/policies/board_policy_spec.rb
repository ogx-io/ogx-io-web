require 'spec_helper'

describe BoardPolicy do

  let(:user) { create(:user) }
  let(:moderator) { create(:moderator) }
  let(:admin) { create(:user, :admin) }
  let(:board) { create(:board) }
  let(:new_board) { build(:board) }

  subject { BoardPolicy }

  before(:each) { board.moderators << moderator }

  permissions :create? do
    it 'allows creating board by admin' do
      expect(subject).not_to permit(user, new_board)
      expect(subject).to permit(admin, new_board)
    end
  end

  permissions :update? do
    it 'allows updating board by admin' do
      expect(subject).not_to permit(user, board)
      expect(subject).to permit(moderator, board)
    end
  end

  permissions :favor? do
    it 'allows favoring a board by any user signed in' do
      expect(subject).to permit(user, board)
      expect(subject).not_to permit(nil, board)
    end
  end

  permissions :disfavor? do
    it 'allows disfavoring a board by any user signed in' do
      expect(subject).to permit(user, board)
      expect(subject).not_to permit(nil, board)
    end
  end
end

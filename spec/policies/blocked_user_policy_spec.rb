require 'spec_helper'

describe BlockedUserPolicy do

  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:moderator) }
  let(:board) { create(:board) }
  let(:blocked_user) { create(:blocked_user, user: user, blocker: admin, blockable: board) }
  let(:new_blocked_user) { build(:blocked_user, user: user, blocker: admin, blockable: board) }

  subject { BlockedUserPolicy }

  before(:each) { board.moderators << moderator }

  permissions :create? do
    it 'allows moderator and admin to add blocked users to the board' do
      expect(subject).not_to permit(user, new_blocked_user)
      expect(subject).to permit(moderator, new_blocked_user)
      expect(subject).to permit(admin, new_blocked_user)
    end
  end

  permissions :destroy? do
    it 'allows moderator and admin to remove blocked users of the board' do
      expect(subject).not_to permit(user, blocked_user)
      expect(subject).to permit(moderator, blocked_user)
      expect(subject).to permit(admin, blocked_user)
    end
  end
end

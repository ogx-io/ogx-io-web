require 'spec_helper'

describe Elite::CategoryPolicy do

  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:moderator) }
  let(:board) { create(:board) }
  let(:elite_category) { create(:elite_category, board: board, parent: Elite::Category.root_for(board), moderator: moderator) }
  let(:new_elite_category) { build(:elite_category, board: board, parent: Elite::Category.root_for(board), moderator: moderator) }

  subject { Elite::CategoryPolicy }

  before(:each) { board.moderators << moderator }

  permissions :create? do
    it 'allows creating new elite category by moderator and admin' do
      expect(subject).not_to permit(user, new_elite_category)
      expect(subject).to permit(moderator, new_elite_category)
      expect(subject).to permit(admin, new_elite_category)
    end
  end

  permissions :update? do
    it 'allows updating elite category by moderator and admin' do
      expect(subject).not_to permit(user, elite_category)
      expect(subject).to permit(moderator, elite_category)
      expect(subject).to permit(admin, elite_category)
    end
  end

  permissions :resume? do
    it 'allows creating new elite category by moderator and admin' do
      expect(subject).not_to permit(user, new_elite_category)
      expect(subject).to permit(moderator, new_elite_category)
      expect(subject).to permit(admin, new_elite_category)
    end
  end

  permissions :destroy? do
    it 'allows updating elite category by moderator and admin' do
      expect(subject).not_to permit(user, elite_category)
      expect(subject).to permit(moderator, elite_category)
      expect(subject).to permit(admin, elite_category)
    end
  end
end

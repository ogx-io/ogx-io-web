require 'spec_helper'

describe BoardPolicy do

  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:board) { create(:board) }
  let(:new_board) { build(:board) }

  subject { BoardPolicy }

  permissions :create? do
    it 'allows creating board by admin' do
      expect(subject).not_to permit(user, new_board)
      expect(subject).to permit(admin, new_board)
    end
  end

  permissions :update? do
    it 'allows updating board by admin' do
      expect(subject).not_to permit(user, board)
      expect(subject).to permit(admin, board)
    end
  end
end

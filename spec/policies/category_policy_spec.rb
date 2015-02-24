require 'spec_helper'

describe CategoryPolicy do

  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:category) { create(:category) }
  let(:new_category) { build(:category) }

  subject { CategoryPolicy }

  permissions :create? do
    it 'allows creating category by admin' do
      expect(subject).not_to permit(user, new_category)
      expect(subject).to permit(admin, new_category)
    end
  end

  permissions :update? do
    it 'allows updating category by admin' do
      expect(subject).not_to permit(user, category)
      expect(subject).to permit(admin, category)
    end
  end

end

require 'spec_helper'

describe Notification::BasePolicy do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:notification) { create(:notification_comment, user: user) }

  subject { Notification::BasePolicy }

  permissions :index? do
    it 'succeeds only if user signed in' do
      expect(subject).to permit(user)
      expect(subject).not_to permit(nil)
    end
  end

  permissions :clean? do
    it 'succeeds only if user signed in' do
      expect(subject).to permit(user)
      expect(subject).not_to permit(nil)
    end
  end

  permissions :destroy? do
    it 'succeeds only if the current user is the owner' do
      expect(subject).to permit(user, notification)
      expect(subject).not_to permit(another_user, notification)
    end
  end
end

require 'spec_helper'

describe PicturePolicy do

  let(:user) { create(:user) }
  let(:new_picture) { build(:picture) }

  subject { PicturePolicy }

  permissions :create? do
    it 'prevents uploading pictures too fast' do
      last_picture = create(:picture, user: user)
      expect(subject).not_to permit(user, new_picture)
    end

    it 'allows uploading a new picture if the last picture by the user was 5 seconds ago' do
      last_picture = create(:picture, user: user, created_at: 5.seconds.ago)
      expect(subject).to permit(user, new_picture)
    end
  end

end

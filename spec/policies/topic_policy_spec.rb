require 'spec_helper'

describe TopicPolicy do

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:board) { create(:board) }
  let(:moderator) { create(:moderator) }
  let(:topic) { create(:post, author: author).topic }

  subject { TopicPolicy }

  before(:each) { topic.board.moderators << moderator }

  permissions ".scope" do
  end

  permissions :show? do
    it 'allows all user to see the topic if it is normal' do
      expect(subject).to permit(user, topic)
      expect(subject).to permit(author, topic)
      expect(subject).to permit(moderator, topic)
      expect(subject).to permit(admin, topic)
    end

    it 'denies access the deleted topic if not an admin or a moderator' do
      topic.delete_by(author)
      expect(subject).not_to permit(user, topic)
      expect(subject).not_to permit(author, topic)
      expect(subject).to permit(moderator, topic)
      expect(subject).to permit(admin, topic)
    end
  end

  permissions :update? do
    it 'allows moderator and admin to update a topic' do
      expect(subject).not_to permit(user, topic)
      expect(subject).to permit(moderator, topic)
      expect(subject).to permit(admin, topic)
    end
  end

  permissions :destroy? do
    it 'allows moderator and admin to delete a topic' do
      expect(subject).not_to permit(user, topic)
      expect(subject).to permit(moderator, topic)
      expect(subject).to permit(admin, topic)
    end
  end

  permissions :resume? do
    it 'allows moderator and admin to resume a deleted topic' do
      expect(subject).not_to permit(user, topic)
      expect(subject).to permit(moderator, topic)
      expect(subject).to permit(admin, topic)
    end
  end

  permissions :toggle_lock? do
    it 'allows author and admin to lock a topic' do
      expect(subject).not_to permit(user, topic)
      expect(subject).to permit(author, topic)
      expect(subject).to permit(moderator, topic)
      expect(subject).to permit(admin, topic)
    end

    it 'allows author moderator and admin to unlock a topic locked by author' do
      topic.lock_by(author)
      expect(subject).not_to permit(user, topic)
      expect(subject).to permit(moderator, topic)
      expect(subject).to permit(admin, topic)
      expect(subject).to permit(author, topic)
    end

    it 'allows moderator and admin to unlock a topic locked by admin or moderator' do
      topic.lock_by(moderator)
      expect(subject).not_to permit(user, topic)
      expect(subject).not_to permit(author, topic)
      expect(subject).to permit(moderator, topic)
      expect(subject).to permit(admin, topic)
      topic.lock_by(admin)
      expect(subject).not_to permit(user, topic)
      expect(subject).not_to permit(author, topic)
      expect(subject).to permit(moderator, topic)
      expect(subject).to permit(admin, topic)
    end
  end
end

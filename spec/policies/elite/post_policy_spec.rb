require 'spec_helper'

describe Elite::PostPolicy do

  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:board) { create(:board) }
  let(:post) { create(:post, author: author, board: board) }
  let(:moderator) { create(:moderator) }
  let(:elite_post) do
    Elite::Post.add_post(post, moderator)
    Elite::Post.find_by(original_id: post.id)
  end

  subject { Elite::PostPolicy }

  before(:each) { board.moderators << moderator }

  permissions :show? do
    it 'allows seeing a deleted elite post by moderator or author' do
      elite_post.delete_by(moderator)
      expect(subject).not_to permit(nil, elite_post)
      expect(subject).not_to permit(user, elite_post)
      expect(subject).to permit(author, elite_post)
      expect(subject).to permit(moderator, elite_post)
      expect(subject).to permit(admin, elite_post)
    end

    it 'allows seeing a normal elite post by everyone' do
      expect(subject).to permit(nil, elite_post)
      expect(subject).to permit(user, elite_post)
      expect(subject).to permit(author, elite_post)
      expect(subject).to permit(moderator, elite_post)
      expect(subject).to permit(admin, elite_post)
    end
  end

  permissions :update? do
    it 'allows updating elite post by moderator or admin' do
      expect(subject).not_to permit(nil, elite_post)
      expect(subject).not_to permit(user, elite_post)
      expect(subject).not_to permit(author, elite_post)
      expect(subject).to permit(moderator, elite_post)
      expect(subject).to permit(admin, elite_post)
    end
  end

  permissions :destroy? do
    it 'allows deleting elite post by author or moderator or admin' do
      expect(subject).not_to permit(nil, elite_post)
      expect(subject).not_to permit(user, elite_post)
      expect(subject).to permit(author, elite_post)
      expect(subject).to permit(moderator, elite_post)
      expect(subject).to permit(admin, elite_post)
    end
  end

  permissions :resume? do
    it 'allows resuming elite post deleted by author by himself' do
      elite_post.delete_by(author)
      expect(subject).not_to permit(nil, elite_post)
      expect(subject).not_to permit(user, elite_post)
      expect(subject).to permit(author, elite_post)
      expect(subject).not_to permit(moderator, elite_post)
      expect(subject).not_to permit(admin, elite_post)
    end

    it 'allows resuming elite post deleted by moderator by moderator or admin' do
      elite_post.delete_by(moderator)
      expect(subject).not_to permit(nil, elite_post)
      expect(subject).not_to permit(user, elite_post)
      expect(subject).not_to permit(author, elite_post)
      expect(subject).to permit(moderator, elite_post)
      expect(subject).to permit(admin, elite_post)
    end
  end

end

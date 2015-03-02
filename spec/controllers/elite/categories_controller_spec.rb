require 'rails_helper'

RSpec.describe Elite::CategoriesController, type: :controller do

  let(:root_category) { create(:elite_category) }
  let(:brother1) { create(:elite_category) }
  let(:brother2) { create(:elite_category) }
  let(:child1) { create(:elite_category, parent: root_category) }
  let(:child2) { create(:elite_category, parent: root_category) }
  let(:author) { create(:user) }
  let(:moderator) { create(:user) }
  let(:board) { create(:board, moderators: [moderator]) }
  let(:old_post) { create(:post, author: author, board: board) }

  before do
    root_category
    brother1
    brother2
    child1
    child2
    Elite::Post.add_post(old_post, moderator)
  end

  describe '#show' do
    it 'succeeds' do
      get :show, id: root_category.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end
  end
end
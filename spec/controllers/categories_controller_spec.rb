require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  let(:root_category) { create(:category) }
  let(:brother1) { create(:category) }
  let(:brother2) { create(:category) }
  let(:child1) { create(:category, parent: root_category) }
  let(:child2) { create(:category, parent: root_category) }

  before do
    root_category
    brother1
    brother2
    child1
    child2
  end

  describe '#show' do
    it 'succeeds' do
      get :show, id: root_category.id
      expect(response).to be_success
      expect(request.flash[:error]).to be_blank
    end
  end

end
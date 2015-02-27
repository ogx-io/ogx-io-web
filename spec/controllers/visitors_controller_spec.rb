require 'rails_helper'

RSpec.describe VisitorsController, type: :controller do

  describe '#index' do
    it 'succeeds' do
      get :index
      expect(response).to be_success
    end
  end

end
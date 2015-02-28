require 'rails_helper'

RSpec.describe PicturesController, type: :controller do
  let(:user) { create(:user) }
  let(:test_file) { fixture_file_upload('public/favicon.ico', 'image/ico') }

  describe '#create' do
    it 'succeeds when the current user is a normal user' do
      pending('Do not know how to simulate file uploading yet')
      raise "broken"
    end
  end
end
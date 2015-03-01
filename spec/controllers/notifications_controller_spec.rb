require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:notification_comment) { create(:notification_comment, user: user) }
  let(:notification_mention) { create(:notification_mention, user: user) }
  let(:notification_post_reply) { create(:notification_post_reply, user: user) }
  let(:another_notification_comment) { create(:notification_comment, user: another_user) }

  before do
    notification_comment
    notification_mention
    notification_post_reply
    another_notification_comment
  end

  describe '#index' do
    context 'user signed in' do
      it 'succeeds' do
        sign_in :user, user
        get :index, user_id: user.id
        expect(response).to be_success
        expect(request.flash[:error]).to be_blank
      end
    end

    context 'user not signed in' do
      it 'fails' do
        get :index, user_id: user.id
        expect(request.flash[:error]).not_to be_blank
      end
    end
  end

  describe '#destroy' do
    context 'user signed in' do
      it 'succeeds if the current user is the owner' do
        sign_in :user, user
        request.env["HTTP_REFERER"] = user_notifications_path(user)
        delete :destroy, id: notification_comment.id
        expect(response).to redirect_to(user_notifications_path(user))
        expect(request.flash[:error]).to be_blank
        expect {
          Notification::Base.find(notification_comment.id)
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
      end

      it 'fails if the current user is not the owner' do
        sign_in :user, another_user
        request.env["HTTP_REFERER"] = user_notifications_path(user)
        delete :destroy, id: notification_comment.id
        expect(request.flash[:error]).not_to be_blank
        expect {
          Notification::Base.find(notification_comment.id)
        }.not_to raise_error
      end
    end

    context 'user not signed in' do
      it 'fails' do
        request.env["HTTP_REFERER"] = user_notifications_path(user)
        delete :destroy, id: notification_comment.id
        expect(request.flash[:error]).not_to be_blank
        expect {
          Notification::Base.find(notification_comment.id)
        }.not_to raise_error
      end
    end
  end

  describe '#clean' do
    context 'user signed in' do
      it 'succeeds if the current user is the owner' do
        sign_in :user, user
        request.env["HTTP_REFERER"] = user_notifications_path(user)
        delete :clean, user_id: user.id
        expect(response).to redirect_to(user_notifications_path(user))
        expect(request.flash[:error]).to be_blank
        expect {
          Notification::Base.find(notification_comment.id)
        }.to raise_error(Mongoid::Errors::DocumentNotFound)
        expect {
          Notification::Base.find(another_notification_comment.id)
        }.not_to raise_error
      end
    end
  end

  context 'user not signed in' do
    it 'fails' do
      request.env["HTTP_REFERER"] = user_notifications_path(user)
      delete :clean, user_id: user.id
      expect(request.flash[:error]).not_to be_blank
      expect {
        Notification::Base.find(notification_comment.id)
      }.not_to raise_error
    end
  end
end
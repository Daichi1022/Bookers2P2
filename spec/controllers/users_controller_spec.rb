require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }

  describe 'GET #edit' do
    render_views
    context 'ログインユーザーの場合' do
      before do
        sign_in user
        get :edit, params: { id: user.id }
      end

      it 'レスポンスが成功すること' do
        expect(response).to have_http_status(:success)
      end

      it '@userが正しく設定されていること' do
        expect(response.body).to include user.name
      end
    end
  end
end
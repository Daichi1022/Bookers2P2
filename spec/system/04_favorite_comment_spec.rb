require 'rails_helper'

describe '[STEP4] いいねとコメントのテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:book) { create(:book, user: user) }
  let!(:other_book) { create(:book, user: other_user) }
  let!(:user_book_comment) { create(:book_comment, book: book, user: user) }
  let!(:user_other_favorite) { create(:favorite, book: other_book, user: user) }  # 削除テスト用に、他人の投稿に対して自分がいいねを作成
  let!(:other_user_book_comment) { create(:book_comment, book: book, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  describe '投稿一覧画面のテスト[課題4追加分]' do
    before do
      visit books_path
    end
    context '表示の確認' do
      it 'いいねボタンのハートアイコンが表示される' do
        expect(page).to have_selector('.fa-heart')
      end
      it 'いいねボタンが表示される' do
        expect(page).to have_link '', href: book_favorites_path(book)
        expect(page).to have_link '', href: book_favorites_path(other_book)
      end
      it 'コメント数が表示される' do
        expect(page).to have_content book.book_comments.count
        expect(page).to have_content other_book.book_comments.count
      end
    end
    context 'いいね作成機能のテスト' do
      it '自分のいいねが正しく保存される' do
        expect { click_link '', href: book_favorites_path(book) }.to change(user.favorites, :count).by(1)
      end
      it 'リダイレクト先が投稿一覧画面になっている' do
        click_link '', href: book_favorites_path(book)
        expect(current_path).to eq '/books'
      end
      it 'リダイレクト先でいいね数が正しく更新されている' do
        click_link '', href: book_favorites_path(book)
        expect(page).to have_content book.favorites.count
      end
    end
    context 'いいね削除機能のテスト' do
      it '自分のいいねが正しく削除される' do
        expect { click_link '', href: book_favorites_path(other_book) }.to change(user.favorites, :count).by(-1)
      end
      it 'リダイレクト先が投稿一覧画面になっている' do
        click_link '', href: book_favorites_path(other_book)
        expect(current_path).to eq '/books'
      end
      it 'リダイレクト先でいいね数が正しく更新されている' do
        click_link '', href: book_favorites_path(other_book)
        expect(page).to have_content other_book.favorites.count
      end
    end
  end

  describe '自分の投稿詳細画面のテスト[課題4追加分]' do
    before do
      visit book_path(book)
    end
    context '表示の確認' do
      it 'いいねボタンのハートアイコンが表示される' do
        expect(page).to have_selector('.fa-heart')
      end
      it 'いいねボタンが表示される' do
        expect(page).to have_link '', href: book_favorites_path(book)
      end
      it 'コメント数が表示される' do
        expect(page).to have_content book.book_comments.count
      end
      it 'コメント一覧でコメント投稿者の画像が表示される: fallbackの画像がサイドバーの1つ＋Book detail直下の1つ＋コメント一覧(2人)の2つの計4つ存在する' do
        expect(all('img').size).to eq(4)
      end
      it 'コメント一覧でコメント投稿者の名前が表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      it 'コメント一覧でコメントの内容が表示される' do
        expect(page).to have_content user_book_comment.comment
        expect(page).to have_content other_user_book_comment.comment
      end
      it '自分が投稿したコメントの削除ボタンが表示される' do
        expect(page).to have_link 'Destroy', href: book_book_comment_path(book_id: book.id, id: user_book_comment.id)
      end
      it '他人が投稿したコメントの削除ボタンは表示されない' do
        expect(page).not_to have_link 'Destroy', href: book_book_comment_path(book_id: book.id, id: other_user_book_comment.id)
      end
      it 'コメント投稿フォームが表示される' do
        expect(page).to have_field 'book_comment[comment]'
      end
      it '送信ボタンが表示される' do
        expect(page).to have_button '送信'
      end
    end
    context 'いいね機能のテスト' do
      it '自分のいいねが正しく保存される' do
        expect { click_link '', href: book_favorites_path(book) }.to change(user.favorites, :count).by(1)
      end
      it 'リダイレクト先が、いいねをした投稿詳細画面になっている' do
        click_link '', href: book_favorites_path(book)
        expect(current_path).to eq '/books/' + book.id.to_s
      end
      it 'リダイレクト先でいいね数が正しく更新されている' do
        click_link '', href: book_favorites_path(book)
        expect(page).to have_content book.favorites.count
      end
    end
    context 'コメント追加機能のテスト' do
      before do
        @comment = Faker::Lorem.characters(number: 10)
        fill_in 'book_comment[comment]', with: @comment
      end
      it '自分のコメントが正しく保存される' do
        expect { click_button '送信' }.to change(user.book_comments, :count).by(1)
      end
      it 'リダイレクト先が、コメントをした投稿詳細画面になっている' do
        click_button '送信'
        expect(current_path).to eq '/books/' + book.id.to_s
      end
      it 'リダイレクト先でコメント数が正しく更新されている' do
        click_button '送信'
        expect(page).to have_content book.book_comments.count
      end
      it 'リダイレクト先で新しいコメントが表示されている' do
        click_button '送信'
        expect(page).to have_content @comment
        expect(page).to have_link 'Destroy', href: book_book_comment_path(book_id: book.id, id: user.book_comments.last.id)
      end
    end
    context 'コメント削除機能のテスト' do
      before do
        @destroy_link = book_book_comment_path(book_id: book.id, id: user_book_comment.id)
        @destroyed_comment = user_book_comment.comment
      end
      it '自分のコメントが正しく削除される' do
        expect { click_link 'Destroy', href: @destroy_link }.to change(user.book_comments, :count).by(-1)
      end
      it 'リダイレクト先が、コメントをしていた投稿詳細画面になっている' do
        click_link 'Destroy', href: @destroy_link
        expect(current_path).to eq '/books/' + book.id.to_s
      end
      it 'リダイレクト先でコメント数が正しく更新されている' do
        click_link 'Destroy', href: @destroy_link
        expect(page).to have_content book.book_comments.count
      end
      it 'リダイレクト先で削除したコメントは表示されない' do
        click_link 'Destroy', href: @destroy_link
        expect(page).not_to have_content @destroyed_comment
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト[課題4追加分]' do
    before do
      visit user_path(user)
    end
    context '表示の確認' do
      it 'いいねボタンのハートアイコンが表示される' do
        expect(page).to have_selector('.fa-heart')
      end
      it 'いいねボタンが表示される' do
        expect(page).to have_link '', href: book_favorites_path(book)
      end
      it 'コメント数が表示される' do
        expect(page).to have_content book.book_comments.count
      end
    end
    context 'いいね作成機能のテスト' do
      it '自分のいいねが正しく保存される' do
        expect { click_link '', href: book_favorites_path(book) }.to change(user.favorites, :count).by(1)
      end
      it 'リダイレクト先が自分のユーザ詳細画面になっている' do
        click_link '', href: book_favorites_path(book)
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it 'リダイレクト先でいいね数が正しく更新されている' do
        click_link '', href: book_favorites_path(book)
        expect(page).to have_content book.favorites.count
      end
    end
  end
end
class ChatsController < ApplicationController
 before_action :reject_reciprocal_follow, only: [:show]
  def show
    @user = User.find(params[:id]) #チャットする相手は誰？
    rooms = current_user.user_rooms.pluck(:room_id) #ログイン中のユーザーの部屋情報を全て取得  pluck  プラク　指定したカラムのレコードの配列を取得
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)#その中にチャットする相手とのルームがあるか確認
     unless user_rooms.nil?#ユーザールームがある場合
       @room = user_rooms.room#変数@roomにユーザー（自分と相手）と紐づいているroomを代入
     else#ユーザールームが無かった場合
       @room = Room.new#新しくRoomを作る
       @room.save
       UserRoom.create(user_id: current_user.id, room_id: @room.id)#自分の中間テーブルを作成
       UserRoom.create(user_id: @user.id, room_id: @room.id)#相手の中間テーブルを作成 
     end
        @chats = @room.chats#チャットの一覧
        @chat = Chat.new(room_id: @room.id)#チャットの投稿
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @room = @chat.room
    @chats = @room.chats
    render :validater unless @chat.save
  end


  private
  def reject_reciprocal_follow
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to books_path
    end
  end
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end
end

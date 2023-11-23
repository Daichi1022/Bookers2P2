class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    @book = Book.new
    @groups = Group.all
    @user = current_user
  end

  def join  
    @group = Group.find(params[:group_id]) #@group.usersに、current_userを追加している
    @group.users << current_user #collectionくくメソッドは1つ以上のオブジェクトをコレクションに追加する。追加できるオブジェクトの外部キーは呼び出し側のモデルの主キーが設定される
    # @group.users = current_user.groups.new(group_id: group.id)
    # @group.users.save   やってることは同じ
    redirect_to  groups_path
  end

  def new
    @group = Group.new
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
    @user = @group.owner
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    if @group.save
      redirect_to groups_path, method: :post
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render "edit"
    end
  end


  def destroy
    @group = Group.find(params[:id])   #current_userは、@group.usersから消される
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :image)
  end

  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end
end

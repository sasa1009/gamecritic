class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.activated_user.page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールアドレスの確認のためにメールを送信しました。
                      メール内のリンクをクリックしてアカウントの登録を完了して下さい。"
      redirect_to games_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    redirect_to games_path and return unless @user.activated?
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールが更新されました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if @user = User.find_by(id: params[:id])
      @user.destroy
      flash[:success] = "ユーザが削除されました"
      redirect_to users_url
    else
      flash[:danger] = "ユーザは存在しません"
      redirect_to users_url
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # beforeアクション

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(login_path) unless current_user?(@user)
    end
end

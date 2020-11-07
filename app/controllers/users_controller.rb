class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :delete_account]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.activated_user.order_desc.page(params[:page])
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
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @user = User.includes(reviews: :user).find(params[:id])
    redirect_to root_path and return unless @user.activated?
    @reviews = @user.reviews.sort_review.page(params[:page]).per(10)
  end

  def recruitment
    @user = User.includes(recruitments: :user).find(params[:id])
    redirect_to root_path and return unless @user.activated?
    @recruitments = @user.recruitments.sort_recruitment.page(params[:page]).per(10)
    render "show"
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:remove_profile_image]
      @user.profile_image.purge 
    end   
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールが更新されました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    c_user = current_user
    if @user == nil
      flash[:danger] = "ユーザを削除できません"
      redirect_to users_url
    elsif @user != c_user && !@user.admin? && c_user.admin?
      @user.destroy
      flash[:success] = "ユーザが削除されました"
      redirect_to users_url
    elsif @user == c_user && !@user.admin? && params[:user][:delete_account] == "0"
      flash.now[:danger] = "アカウントを削除するには、チェックボックスにチェックをしてください"
      render 'delete_account'
    elsif @user == c_user && !@user.admin? && params[:user][:delete_account] == "1"
      @user.destroy
      log_out
      flash[:success] = "アカウントが削除されました。gamecriticをご利用頂きありがとうございました。"
      redirect_to root_path
    else
      flash[:danger] = "ユーザを削除できません"
      redirect_to root_path
    end
  end

  def delete_account
    @user = User.find(params[:id])
    if current_user?(@user)
      render 'delete_account'
    else
      flash[:danger] = "このページにはアクセスできません"
      redirect_to root_path
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :profile_image,
                                   :self_introduction)
    end

    # beforeアクション

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(login_path) unless current_user?(@user)
    end
end

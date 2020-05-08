class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "アカウントの登録が完了していません。メール内のリンクから登録を完了して下さい。"
        redirect_to games_path
      end
    else
      flash.now[:danger] = "メールアドレスかパスワードが間違っています"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

end

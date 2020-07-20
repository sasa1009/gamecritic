module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    current_user
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # レビューかフレンド募集を編集する際にゲーム詳細ページから編集した場合はゲーム詳細ページに、ユーザープロフィールページから編集した場合はユーザープロフィールページにリダイレクトする
  def redirect_to_previous_page(default)
    if session["previous_page"]
      if session["previous_page"]["controller"] == "games"
        if session["previous_page"]["action"] == "show"
          redirect_to(game_path(session["previous_page"]["id"]))
        elsif session["previous_page"]["action"] == "recruitments"
          redirect_to(recruitments_game_path(session["previous_page"]["id"]))
        end
      elsif session["previous_page"]["action"] == "show"
        redirect_to(user_path(session["previous_page"]["id"]))
      elsif session["previous_page"]["action"] == "recruitment"
        redirect_to(recruitment_user_path(session["previous_page"]["id"]))
      else
        redirect_to(default)
      end
    else
      redirect_to(default)
    end
    session.delete(:previous_page)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end

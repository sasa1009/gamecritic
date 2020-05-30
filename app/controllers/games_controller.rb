class GamesController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :admin_user, except: [:index, :show]

  def index
    @games = Game.page(params[:page])
  end

  def new
    @game = current_user.games.new
  end

  def create
    @game = Game.new(game_params)
    @game.user_id = current_user.id
    @game.youtube_url = Game.get_video_id(game_params[:youtube_url])
    if @game.save
      flash[:info] = "ゲームデータが登録されました。"
      redirect_to @game
    else
      render 'new'
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    # youtube_urlの値を編集
    params_data = game_params
    params_data["youtube_url"] = Game.get_video_id(params_data["youtube_url"])
    if @game.update_attributes(params_data)
      flash[:success] = "ゲームデータが更新されました。"
      redirect_to @game
    else
      render "edit"
    end
  end

  def destroy
    if @game = Game.find(params[:id])
      @game.destroy
      flash[:success] = "ゲームデータが削除されました"
      redirect_to root_path
    else
      flash[:danger] = "ゲームデータは存在しません"
      redirect_to root_path
    end
  end

  private

    def game_params
      params.require(:game).permit(:title, :developer, :release_date,
                                   :summary, :jacket, :youtube_url)
    end
end

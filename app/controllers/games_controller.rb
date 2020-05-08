class GamesController < ApplicationController
  before_action :logged_in_user, except: :index
  before_action :admin_user, except: :index

  def index
    @games = Game.page(params[:page])
  end

  def new
    @game = current_user.games.new
  end

  def create
    @game = Game.new(game_params)
    @game.user_id = current_user.id
    if @game.save
      flash[:info] = "ゲームデータが登録されました。"
      redirect_to games_path
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
    if @game.update_attributes(game_params)
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
      redirect_to games_path
    else
      flash[:danger] = "ゲームデータは存在しません"
      redirect_to games_path
    end
  end

  private

    def game_params
      params.require(:game).permit(:title, :developer, :release_date,
                                   :summary)
    end
end

class GamesController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :admin_user, except: [:index, :show]
  before_action :find_resource, except: [:index, :new, :create]
  
  def index
    @games = Game.page(params[:page])
  end

  def new
    @game = current_user.games.new
  end

  def create
    @game = current_user.games.new(game_params)
    if @game.save
      flash[:info] = "ゲームデータが登録されました。"
      redirect_to @game
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @game.update_attributes(game_params)
      flash[:success] = "ゲームデータが更新されました。"
      redirect_to @game
    else
      render "edit"
    end
  end

  def destroy
    if @game.destroy
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
                                   :summary, :jacket, :youtube_video_id)
    end

    def find_resource
      @game = Game.find(params[:id])
    end
end

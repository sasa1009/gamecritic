class GamesController < ApplicationController
  include ReviewsHelper
  include RecruitmentsHelper
  before_action :logged_in_user, except: [:index, :show, :recruitments]
  before_action :admin_user, except: [:index, :show, :recruitments]
  before_action :find_resource, except: [:index, :new, :create, :show]
  
  def index
    @games = Game.order_desc.page(params[:page]).per(6)
  end

  def new
    @game = current_user.games.new
  end

  def create
    @game = current_user.games.new(game_params)
    if @game.save
      flash[:info] = "ゲームデータが登録されました"
      redirect_to @game
    else
      render 'new'
    end
  end

  def show
    @game = Game.includes(reviews: :user).find(params[:id])
    @reviews = @game.reviews.review_with_value.page(params[:page]).per(10)
  end

  def recruitments
    @game = Game.includes(recruitments: :user).find(params[:id])
    @recruitments = @game.recruitments.sort_recruitment.page(params[:page]).per(10)
    render "show"
  end

  def edit
  end

  def update
    if @game.update_attributes(game_params)
      flash[:success] = "ゲームデータが更新されました"
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

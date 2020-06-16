class ReviewsController < ApplicationController
  before_action :find_resource, except: [:new, :create]
  # reviewカラムに含まれている<br>タグを改行コードに変換する
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @review = Review.new
    @review.game_id = params[:game_id]
  end

  def create
    @review = current_user.reviews.new(review_params)
    @review.game_id = params[:game_id]
    if @review.save
      flash[:success] = "レビューが投稿されました"
      redirect_to Game.find(params[:game_id])
    else
      render "new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if current_user == User.find(@review.user_id)
      if @review.update_attributes(review_params)
        flash[:success] = "レビューが更新されました"
        redirect_to game_path(@review.game_id)
      else
        render "edit"
      end
    else
      flash[:danger] = "このレビューは編集できません"
      redirect_to game_path(@review.game_id)
    end
  end

  def destroy
    if current_user == User.find(@review.user_id)
      if @review.destroy
        flash[:success] = "レビューが削除されました"
        redirect_to game_path(@review.game_id)
      else
        flash[:danger] = "レビューは存在しません"
        redirect_to game_path(@review.game_id)
      end
    else
      flash[:danger] = "このレビューは削除できません"
      redirect_to game_path(@review.game_id)
    end
  end

  private
    def review_params
      params.require(:review).permit(:score,
                                    :title,
                                    :review)
    end

    def find_resource
      @review = Review.find(params[:id])
    end
end

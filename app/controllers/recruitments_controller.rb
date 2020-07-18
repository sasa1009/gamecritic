class RecruitmentsController < ApplicationController
  before_action :find_resource, except: [:new, :create]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @recruitment = Recruitment.new
    @recruitment.game_id = params[:game_id]
  end
  
  def create
    @recruitment = current_user.recruitments.new(recruitment_params)
    @recruitment.game_id = params[:game_id]
    if @recruitment.save
      flash[:success] = "フレンド募集が投稿されました"
      redirect_to recruitments_game_path(params[:game_id])
    else
      render "new"
    end
  end
  
  def edit
  end
  
  def update
    if current_user == User.find(@recruitment.user_id)
      if @recruitment.update_attributes(recruitment_params)
        flash[:success] = "投稿が更新されました"
        redirect_to recruitments_game_path(@recruitment.game_id)
      else
        render "edit"
      end
    else
      flash[:danger] = "この投稿は編集できません"
      redirect_to recruitments_game_path(@recruitment.game_id)
    end
  end
  
  def destroy
    if current_user == User.find(@recruitment.user_id)
      if @recruitment.destroy
        flash[:success] = "投稿が削除されました"
        redirect_to recruitments_game_path(@recruitment.game_id)
      else
        flash[:danger] = "投稿は存在しません"
        redirect_to recruitments_game_path(@recruitment.game_id)
      end
    else
      flash[:danger] = "この投稿は削除できません"
      redirect_to recruitments_game_path(@recruitment.game_id)
    end

  end

  private
    def recruitment_params
      params.require(:recruitment).permit(:title,
                                    :description)
    end

    def find_resource
      @recruitment = Recruitment.find(params[:id])
    end
  
end

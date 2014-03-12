class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, only: [:create]
  skip_before_filter :teacher, only: [:create, :index, :show]

  # GET /users
  # GET /users.json
  def index
    @active = 2
    @users = User.all
  end

  def create
    @user = User.new(user_create_params)

    respond_to do |format|
      if @user.save
        format.js
      else
        format.js
      end
    end
  end

  def update
    unless 0==@current_user.admin or @user.id==@current_user.id
      flash[:alert] = '未授权'
      render status: 403
    else
      if @user.update((0==@current_user.admin) ? user_create_params : user_update_params)
        flash[:notice] = '修改保存成功'
      else
        flash[:notice] = '没有任何修改'
      end
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    unless 0==@current_user.admin or @user.id==@current_user.id
      flash[:alert] = '未授权'
      render status: 403
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_create_params
      params.require(:user).permit(:administration, :password, :password_confirmation, :name, :true_name, :email, :renren, :qq, :mobile, :gender, :class_name)
    end

    def user_update_params
      params.require(:user).permit(:name, :true_name, :email, :renren, :qq, :mobile, :gender, :class_name)
    end
end

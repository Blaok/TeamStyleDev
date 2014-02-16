class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, only: [:index, :show]
  skip_before_filter :teacher, only: [:index, :show]
  before_action {@active = 1}

  def index
    @courses = Course.all
  end

  def show
    @course = Course.find_by_id(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def create
    unless 0==@current_user.admin or 1==@current_user.admin 
      flash[:alert] = '未授权'
      render status: 403
    else
      @course = Course.new(course_params)
      @course.user_id = @current_user.id

      respond_to do |format|
        @course.save
        format.js
      end
    end
  end

  def update
    unless 0==@current_user.admin or 1==@current_user.admin 
      flash[:alert] = '未授权'
      render status: 403
    else
      if @course.update(course_params)
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
    unless 0==@current_user.admin or 1==@current_user.admin 
      flash[:alert] = '未授权'
      render status: 403
    else
      @course.destroy
      respond_to do |format|
        format.html { redirect_to courses_url }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :category, :information)
    end

end

class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, only: [:index, :show]
  skip_before_filter :teacher, only: [:index, :show]
  before_action {@active = (@current_user==nil || 1==@current_user.admin || 2==@current_user.admin ) ? 1 : 2}

  def index
    @assignments = Assignment.all
  end

  def show
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def create
    unless 0==@current_user.admin or 1==@current_user.admin 
      flash[:alert] = '未授权'
      render status: 403
    else
      @assignment = Assignment.new(assignment_params)
      params[:assignment][:startat ].empty? || (@assignment.startat  = params[:assignment][:startat ].to_time)
      params[:assignment][:deadline].empty? || (@assignment.deadline = params[:assignment][:deadline].to_time)
      
      respond_to do |format|
        @assignment.save
        format.js
      end
    end
  end

  def update
    unless 0==@current_user.admin or 1==@current_user.admin
      flash[:alert] = '未授权'
      render status: 403
    else
      params[:assignment][:startat ].empty? || (@assignment.startat  = params[:assignment][:startat ].to_time)
      params[:assignment][:deadline].empty? || (@assignment.deadline = params[:assignment][:deadline].to_time)
      if @assignment.update(assignment_params)
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
      @assignment.destroy
      respond_to do |format|
        format.html { redirect_to assignments_url }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assignment
      @assignment = Assignment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assignment_params
      params.require(:assignment).permit(:name, :category, :file, :information, :course_id,)
    end

end

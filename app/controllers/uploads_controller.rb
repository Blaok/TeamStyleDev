class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, only: [:index, :show]
  before_action {@active = 1}

  def index
    @uploads = Upload.all
  end

  def courses
    @uploads = Upload.all - Upload.find_all_by_course_id(nil)
    render action: 'index'
  end

  def assignments
    @uploads = Upload.all - Upload.find_all_by_assignment_id(nil)
    render action: 'index'
  end

  def show
    @upload = Upload.find_by_id(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def course
    @upload = Upload.find_by_id(params[:id])
    if @upload.course_id
      send_file "#{Rails.root}/#{@upload.path}", filename: (File.extname(@upload.name).empty? ? @upload.name+File.extname(@upload.path) : @upload.name)
    else
      render :html, status: 404
    end
  end

  def assignment
    @upload = Upload.find_by_id(params[:id])
    if @upload.assignment_id
      send_file "#{Rails.root}/#{@upload.path}", filename: (File.extname(@upload.name).empty? ? @upload.name+File.extname(@upload.path) : @upload.name)
    else
      render :html, status: 404
    end
  end

  def create
    unless 0==@current_user.admin or 1==@current_user.admin 
      flash[:alert] = '未授权'
      render status: 403
    else
      @upload = Upload.new(upload_params)
      unless @upload.name
        @upload.errors.add(:name, '附件名称不能为空')
        respond_to do |format|
          format.js
          format.html action: 'course#index'
        end
      else
        file = params[:upload][:file]
        file && ((@upload.path = Upload.upload_file('upload',Time.now.to_i.to_s+'_'+file.original_filename,file)))

        unless saved = @upload.save
          File.exists?(@upload.path.to_s) and File.delete(@upload.path.to_s)
          render action: 'course#index' #{ redirect_to '', msg: (saved ? '上传成功' : '上传失败') }
          
        else
          respond_to do |format|
            format.js
            format.html action: 'course#index' #{ redirect_to '', msg: (saved ? '上传成功' : '上传失败') }
          end
        end
      end
    end
  end

  def update
    unless 0==@current_user.admin or 1==@current_user.admin 
      flash[:alert] = '未授权'
      render status: 403
    else
      if @upload.update(upload_params)
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
      File.exists?(@upload.path.to_s) and File.delete(@upload.path.to_s)
      @upload.destroy
      respond_to do |format|
        format.html { redirect_to uploads_url }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_upload
      @upload = Upload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def upload_params
      params.require(:upload).permit(:name, :category, :information, :course_id, :assignment_id)
    end
end

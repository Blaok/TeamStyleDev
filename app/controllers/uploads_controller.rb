class UploadsController < ApplicationController
  before_action :set_upload, only: [:show, :edit, :update, :destroy]
  skip_before_filter :authorize, only: [:index, :courses, :course ]
  skip_before_filter :teacher
  before_action {@active = 1}

  def index
    @uploads = Upload.all
  end

  def courses
    @uploads = Upload.all - Upload.find_all_by_course_id(nil)
  end

  def assignments
    @uploads = Upload.all - Upload.find_all_by_assignment_id(nil)
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
      send_file "#{Rails.root}/#{@upload.path}", filename: (File.extname(@upload.name).empty? ? @upload.name.gsub('\\','＼').gsub('/','／').gsub(':','：').gsub('*','＊',).gsub('?','？').gsub('"','＂').gsub('<','＜').gsub('>','＞').gsub('|','｜')+File.extname(@upload.path) : @upload.name.gsub('\\','＼').gsub('/','／').gsub(':','：').gsub('*','＊',).gsub('?','？').gsub('"','＂').gsub('<','＜').gsub('>','＞').gsub('|','｜'))
    else
      render :html, status: 404
    end
  end

  def assignment
    @upload = Upload.find_by_id(params[:id])
    if @upload.assignment_id
      send_file "#{Rails.root}/#{@upload.path}", filename: (File.extname(@upload.name).empty? ? @upload.name.gsub('\\','＼').gsub('/','／').gsub(':','：').gsub('*','＊',).gsub('?','？').gsub('"','＂').gsub('<','＜').gsub('>','＞').gsub('|','｜')+File.extname(@upload.path) : @upload.name.gsub('\\','＼').gsub('/','／').gsub(':','：').gsub('*','＊',).gsub('?','？').gsub('"','＂').gsub('<','＜').gsub('>','＞').gsub('|','｜'))
    else
      render :html, status: 404
    end
  end

  def create
    unless 0==@current_user.admin or 1==@current_user.admin or params[:upload][:assignment_id]
      flash[:alert] = '未授权'
      render status: 403
    else
      @upload = Upload.new(upload_params)
      @upload.user_id = current_user.id
      unless @upload.name
        flash[:msg] = @upload.name

        @upload.errors.add(:name, '附件名称不能为空')
        respond_to do |format|
          format.js
        end
      else
        file = params[:upload][:file]
        file && ((@upload.path = Upload.upload_file('upload',Time.now.to_i.to_s+'_'+file.original_filename,file)))
        
        saved = @upload.save
        flash[:msg] = (saved ? '上传成功' : '上传失败：附件名称不能为空')
        File.exists?(@upload.path.to_s) and File.delete(@upload.path.to_s) unless saved

        respond_to do |format|
          format.js
          format.html { redirect_to :back  }
        end
      end
    end
  end

  def update
    unless 0==@current_user.admin or 1==@current_user.admin
      flash[:alert] = '未授权'
      render status: 403
    else
      file = params[:upload][:file]
      unless file
        @upload.errors.add(:path, '附件不能为空')
        params[:upload][:name].blank? && @upload.errors.add(:name, '附件名称不能为空')
        respond_to do |format|
          format.js
        end
      else
        old_path = @upload.path
        @upload.path = Upload.upload_file('upload',Time.now.to_i.to_s+'_'+file.original_filename,file)
        
        saved = @upload.update(upload_params)
        flash[:msg] = (saved ? '上传成功' : '上传失败：附件名称不能为空')
        File.exists?(@upload.path.to_s) and File.delete(@upload.path.to_s) unless saved
        File.exists?(old_path.to_s) and File.delete(old_path.to_s)

        respond_to do |format|
          format.js
          format.html { redirect_to :back  }
        end
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

  def zip
    uploads = params[:uploads].split(',')
    tmp_dir = "#{Rails.root}/tmp/#{Time.now.to_i.to_s}"
    Dir.mkdir(tmp_dir)
    Dir.chdir(tmp_dir)
    zip_file = "#{tmp_dir}.7z"
    for upload in uploads
      upload = Upload.find_by_id(upload)
      timestrap = File.basename(upload.path).split('_')[0]
      name = "#{timestrap}_"+(File.extname(upload.name).empty? ? upload.name.gsub('\\','＼').gsub('/','／').gsub(':','：').gsub('*','＊',).gsub('?','？').gsub('"','＂').gsub('<','＜').gsub('>','＞').gsub('|','｜')+File.extname(upload.path) : upload.name.gsub('\\','＼').gsub('/','／').gsub(':','：').gsub('*','＊',).gsub('?','？').gsub('"','＂').gsub('<','＜').gsub('>','＞').gsub('|','｜'))
      user = User.find_by_id(upload.user_id)
      if user
        user = '/'+user.name.gsub('\\','＼').gsub('/','／').gsub(':','：').gsub('*','＊',).gsub('?','？').gsub('"','＂').gsub('<','＜').gsub('>','＞').gsub('|','｜')
        Dir.exists?(tmp_dir+user) || Dir.mkdir(tmp_dir+user)
      end
      FileUtils.cp("../../#{upload.path}","#{tmp_dir}#{user}/#{name}")
    end
    system "7za a #{zip_file} ."
    FileUtils.rm_r(tmp_dir)
    params[:filename] ? (send_file zip_file, filename: params[:filename]+'.7z') : (send_file zip_file)
    system "sh -c \"sleep 600s;rm #{zip_file}\"&"
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

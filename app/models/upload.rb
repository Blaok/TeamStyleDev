require 'open-uri'
class Upload < ActiveRecord::Base

  validates :name, 
    presence: {presence: true, message: '附件名称不能为空'}

  validates :category, 
    presence: {presence: true, message: '附件类别不能为空'}

  validates :path, 
    presence: {presence: true, message: '上传文件不能为空'}


  def Upload.upload_file(path,filename,file)  #将file中上传的文件写入相对Rails根目录的path路径下并以filename作为文件名
    path=path.split('/').split('\\').compact().join('/')  #去掉没有用的斜杠或者反斜杠
    if file
      upload_file=path+'/'+filename
      File.open("#{Rails.root}/#{upload_file}", 'wb') do |f|  
        f.write(file.read)
        f.close()
      end
      return upload_file  #返回相对Rails根目录的文件名
    else
      errors.add(:path, '上传文件错误') 
      return nil
    end
  end
end

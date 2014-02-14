class User < ActiveRecord::Base
  
  before_save { self.email = self.email.downcase; self.mobile &&= self.mobile.to_i; self.qq &&= self.qq.to_i; self.renren &&= self.renren.to_i; ('admin'==self.name) ? (self.administration = 0) : (self.administration &&= self.administration.to_i) }
  
  has_many :sessions, :dependent => :destroy
  has_many :courses

  validates :name, 
    presence: {presence: true, message: '用户名不能为空'},
    uniqueness: {uniqueness: true, message: '该用户名已经被注册'},
    length: {maximum: 20, message: '用户名不能超过20个字符'},
    format: {without: /\s/, message: '用户名不能含有空字符'},
    format: {without: /@/, message: '用户名不能包含"@"'}

  validates :true_name, 
    presence: {presence: true, message: '姓名不能为空'},
    length: {maximum: 20, message: '姓名不能超过20个字符'},
    format: {without: /\s/, message: '姓名不能含有空字符'}

  validates :email,
    presence: {presence: true, :message => "邮箱不能为空"},
    uniqueness: {case_sensitive: false, :message => "该邮箱已经被注册"},
    format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, message: '电子邮件地址无效'}

  validates :class_name,
    presence: {presence: true, :message => "班级不能为空"},
    format: {with: /\w+\d+/, message: '班级信息无效'}

  validates :gender, 
    inclusion: {in: [true,false], message: '性别不能为空'}

  validates :administration, 
    presence: {presence: true, message: '组别不能为空'}

  validates :mobile,
    presence: {presence: true, message: '联系电话不能为空'},
    format: {with: /\d+/, message: '联系电话只能含有数字'}

  validates :qq,
    format: {with: /\d*/, message: 'QQ号只能含有数字'}

  validates :renren,
    format: {with: /\d*/, message: '人人ID只能含有数字'}

  validates :password,
    confirmation: {confirmation: true, message: '密码不匹配'}

  attr_accessor :password_confirmation
  attr_reader :password

  validate :password_must_be_present
  
  def User.authenticate(name, password)
    if user=find_by_email(name.downcase) || user=find_by_name(name)
      if user.hashed_password == encrypt_password(password, user.salt)
        user
      end
    end
  end

  def User.encrypt_password(password, salt)
    Digest::SHA512.hexdigest(password+'TeamStyleDev'+salt)
  end

  def password=(password)
    @password = password
    if password.present?
      generate_salt
      self.hashed_password=self.class.encrypt_password(password,salt)
    end
  end

  def admin
    (self.name=='admin') ? 0 : (0==self.administration ? -1 : self.administration)
  end 

  private

    def password_must_be_present
      errors.add(:password, "密码不能为空") unless hashed_password.present?
    end

    def generate_salt
      self.salt=Digest::MD5.hexdigest(self.object_id.to_s+rand.to_s+Time.now.to_s)
    end

end

class Assignment < ActiveRecord::Base
  has_many :uploads
  belongs_to :course

  validates :name, 
    presence: {presence: true, message: '作业名称不能为空'},
    length: {maximum: 20, message: '作业名称不能超过20个字符'}

  validates :information,
    presence: {presence: true, :message => "作业说明不能为空"},
    length: {minimum: 10, message: '作业说明不能少于10个字符'}

  validates :startat,
    presence: {presence: true, :message => "作业开始时间不能为空"}

  validates :deadline,
    presence: {presence: true, :message => "作业截止时间不能为空"}

  validate :time_validate

  private

    def time_validate
      errors.add(:deadline, '作业截止时间必须晚于开始时间') unless self.startat && self.deadline && self.startat < self.deadline
      #errors.add(:deadline, '作业截止时间必须晚于当前时间') unless self.deadline && self.deadline > Time.now
    end

end

class Course < ActiveRecord::Base

  has_many :assignments
  has_many :uploads
  belongs_to :user

  validates :name, 
    presence: {presence: true, message: '课程名不能为空'},
    length: {maximum: 20, message: '课程名不能超过20个字符'}

  validates :category,
    presence: {presence: true, :message => "课程类别不能为空"},
    length: {maximum: 10, message: '课程类别不能超过10个字符'}

  validates :information,
    presence: {presence: true, :message => "课程简介不能为空"},
    length: {minimum: 10, message: '课程简介不能少于10个字符'}

end

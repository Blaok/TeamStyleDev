module ApplicationHelper

  def admin0?(user)
    0==user.admin
  end

  def admin1?(user)
    0==user.admin or 1==user.admin
  end

end

class HomeController < ApplicationController
  skip_before_filter :authorize, only: [:index]
  skip_before_filter :teacher, only: [:index]

  def index
    @active = 0
  end
  
  def admin
    @active = 2
  end

end

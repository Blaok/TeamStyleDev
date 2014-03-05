require 'ya2yaml'

class HomeController < ApplicationController
  skip_before_filter :authorize, only: [:index]
  skip_before_filter :teacher, only: [:index]

  def index
    @active = 0
    @annoucements_config = "#{Rails.root}/config/annoucements.yml"
    if File.exists?(@annoucements_config)
      @annoucements=YAML::load(File.read(@annoucements_config))
    end
  end
  
  def admin
    @active = 2
  end

  def update_annoucements
    @annoucements = params[:annoucement]
    @annoucements_config = "#{Rails.root}/config/annoucements.yml"
    File.open(@annoucements_config, 'w') { |f|
      f.puts @annoucements.ya2yaml
    }
  end

end

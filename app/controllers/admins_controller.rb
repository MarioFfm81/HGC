class AdminsController < ApplicationController
    before_action :require_admin, only: [:show, :update]
    
    
    def show
		#res = open("#{@@URI}#{@@API_CURR}/#{@@LEAGUE}").read
		#@currentMatchday = JSON.parse res
		@currentMatchday = "34"
        @users = User.all
        @lastCalculated = Result.where(:year => @@SAISON).maximum(:matchday)
        @results = Result.where(:year => 2017)
        @tipps = Tipp.all
    end
    
    def update
        session[:user_id] = params[:id]
        redirect_to '/admin'
    end
end

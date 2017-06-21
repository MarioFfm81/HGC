class AdminsController < ApplicationController
    before_action :require_admin, only: [:show, :update]
    
    
    def show
		res = open("#{@@URI}#{@@API_CURR}/#{@@LEAGUE}").read
		@currentMatchday = JSON.parse res
        @users = User.all
        @lastCalculated = Result.where(:year => @@SAISON).maximum(:matchday)
    end
    
    def update
        session[:user_id] = params[:id]
        redirect_to '/admin'
    end
end

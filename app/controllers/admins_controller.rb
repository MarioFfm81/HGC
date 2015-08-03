class AdminsController < ApplicationController
    before_action :require_admin, only: [:show, :update]
    
    
    def show
		url = URI.parse(@@URI)
		res = Net::HTTP.start(url.host,url.port) do |http|
		  http.get("#{@@API_CURR}/#{@@LEAGUE}")
		end
		@currentMatchday = JSON.parse res.body
        @users = User.all
        @lastCalculated = Result.where(:year => @@SAISON).maximum(:matchday)
    end
    
    def update
        session[:user_id] = params[:id]
        redirect_to '/admin'
    end
end

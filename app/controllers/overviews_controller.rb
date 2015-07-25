class OverviewsController < ApplicationController
	def index
		currentMatchday=[]
		url = URI.parse(@@URI)
		res = Net::HTTP.start(url.host,url.port) do |http|
		  http.get("#{@@API_CURR}/#{@@LEAGUE}")
		end
		currentMatchday = JSON.parse res.body
		@test = currentMatchday
		if currentMatchday['GroupOrderID']
			redirect_to "/overviews/#{currentMatchday['GroupOrderID']}"
		end
	end
	
	def show
		@currentMatchday = params['id']
		if @currentMatchday.to_i>34 || @currentMatchday.to_i<1
			redirect_to "/overviews"
		end
		@games=[]
		url = URI.parse(@@URI)
		res = Net::HTTP.start(url.host,url.port) do |http|
		  http.get("#{@@API_PATH}/#{@@LEAGUE}/#{@@SAISON}/#{@currentMatchday}")
		end
		@games = JSON.parse res.body
		@users = User.all
	end
end

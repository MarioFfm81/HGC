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
		@resultPerUser=[]
		@users.each do |user|
			#r = Result.find_by year: @@SAISON, user_id: user.id	
			upperEnd = params[:id].to_f-1
			r = Result.where(year: @@SAISON, user_id: user.id, matchday: 0..upperEnd).all
			res = 0.0
			if r != nil
				r.each do |matchdayResult|
					res += matchdayResult.result
				end
			end
			@resultPerUser[user.id] = res
		end
	end
end

class GamesController < ApplicationController
	def show
		@games=[]
		url = URI.parse("http://www.openligadb.de")
		res = Net::HTTP.start(url.host,url.port) do |http|
		  http.get("/api/getmatchdata/bl1/2014/15")
		end
		@games = JSON.parse res.body
	end
end

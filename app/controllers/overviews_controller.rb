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
		@games.each do |game|
		    t = DateTime.parse(game['MatchDateTime'])
		    n = Time.now
		    n = n - n.gmt_offset + 7200
		    game['active'] = t<n
		    @users.each do |user|
		       game[user.id] = []
		       #put result per user in game JSON
		       tipp = user.tipps.find_by(:user_id=>user.id, :spiel=> game['MatchID']) 
		       if tipp
		       		if  user==current_user || game['active']
		           		game[user.id][0] = "#{tipp.tipp1.to_s} : #{tipp.tipp2.to_s}"
		           	else
		           		game[user.id][0] = "n/a"
		           	end
		           #put class information for cell and costs for player/game in game JSON
		           if game['MatchIsFinished'] #if game has ended
                        if tipp.tipp1==game['MatchResults'][0]['PointsTeam1'] && tipp.tipp2 ==game['MatchResults'][0]['PointsTeam2']
                            game[user.id][1]="tippCell greenCell"
                            game[user.id][2]=-0.5
                        else 
                            if (tipp.tipp1 && tipp.tipp2) && tipp.tipp2-tipp.tipp1 == game['MatchResults'][0]['PointsTeam2']-game['MatchResults'][0]['PointsTeam1']
                                game[user.id][1]="tippCell yellowCell"
                                game[user.id][2]=-0.25
                            else
                                game[user.id][1]="tippCell redCell"
                                game[user.id][2]=0.25
                            end
                        end
		           else
		                game[user.id][1] = "tippCell"
		                game[user.id][2] = 0.25
		           end
		       else
		           if game['MatchIsFinished'] #if game has ended
		                game[user.id][1] = "tippCell redCell"
		                game[user.id][2] = 0.25
		           else
		                game[user.id][0] = " "
		                game[user.id][1] = "tippCell"
		                game[user.id][2] = 0.25
		           end
		       end
		       
		       
		    end
		end
		
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

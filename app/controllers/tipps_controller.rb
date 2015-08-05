class TippsController < ApplicationController
    before_action :require_user
    def index
		currentMatchday=[]
		url = URI.parse(@@URI)
		res = Net::HTTP.start(url.host,url.port) do |http|
		  http.get("#{@@API_CURR}/#{@@LEAGUE}")
		end
		currentMatchday = JSON.parse res.body
		@test = currentMatchday
		if currentMatchday['GroupOrderID']
			redirect_to "/tippen/#{currentMatchday['GroupOrderID']}"
		end
	end
	
	def show
	    @tipp=Tipp.new
		@currentMatchday = params['id']
		if @currentMatchday.to_i>34 || @currentMatchday.to_i<1
			redirect_to "/tippen"
		end
		@games=[]
		url = URI.parse(@@URI)
		res = Net::HTTP.start(url.host,url.port) do |http|
		  http.get("#{@@API_PATH}/#{@@LEAGUE}/#{@@SAISON}/#{@currentMatchday}")
		end
		@games = JSON.parse res.body
		@previousGames={}
		@oneActive = false
		@games.each do |game|
			@oneActive = true if game['MatchIsFinished'] == false
		    t = DateTime.parse(game['MatchDateTime'])
		    oldTipp = Tipp.find_by user_id: session[:user_id], spiel: game['MatchID']
		    if oldTipp
		    	game['class'] = ""
		        game['tipp1'] = oldTipp.tipp1
		        game['tipp2'] = oldTipp.tipp2
		        if game['MatchIsFinished'] && game['MatchResults'][0]
		        	if game['MatchResults'][0]['PointsTeam1'] == oldTipp.tipp1 && game['MatchResults'][0]['PointsTeam2'] == oldTipp.tipp2
		        		game['class'] = "greenCell"
		        	else
		        		if (oldTipp.tipp1 != nil && oldTipp.tipp2 != nil) && game['MatchResults'][0]['PointsTeam2'] - game['MatchResults'][0]['PointsTeam1'] == oldTipp.tipp2 - oldTipp.tipp1
		        			game['class'] = "yellowCell"
		        		else
		        			game['class'] = 'redCell'
		        		end
		        	end
		        end
		    else
		    	if game['MatchIsFinished']
		    		game['class'] = 'redCell'
		    	end
            end
		    game['date'] = t.strftime("%d.%m.%Y")
		    game['time'] = t.strftime("%H:%M")
		    game['active'] = t>Time.now
		    
		    @previousGames[game['Team1']['TeamId']] = {}
		    @previousGames[game['Team2']['TeamId']] = {}
		end
		
		myMatchday = @currentMatchday.to_i
		mySaison = @@SAISON.to_i
		5.times do |i|
			myMatchday -= 1
			if myMatchday == 0
				myMatchday = 34
				mySaison -= 1
			end
			
			tempGames=[]
			url = URI.parse(@@URI)
			res = Net::HTTP.start(url.host,url.port) do |http|
		  		http.get("#{@@API_PATH}/#{@@LEAGUE}/#{mySaison}/#{myMatchday}")
			end
			tempGames = JSON.parse res.body
			tempGames.each do |tempGame|
				t = DateTime.parse(tempGame['MatchDateTime'])
				if @previousGames[tempGame['Team1']['TeamId']]
					@previousGames[tempGame['Team1']['TeamId']]["#{i}"] = {}
					@previousGames[tempGame['Team1']['TeamId']]["#{i}"]['date'] = t.strftime("%d.%m.%Y")
					@previousGames[tempGame['Team1']['TeamId']]["#{i}"]['icon1'] = tempGame['Team1']['TeamIconUrl']
					@previousGames[tempGame['Team1']['TeamId']]["#{i}"]['icon2'] = tempGame['Team2']['TeamIconUrl']
					if tempGame['MatchResults'][0]
						@previousGames[tempGame['Team1']['TeamId']]["#{i}"]['result1'] = tempGame['MatchResults'][0]['PointsTeam1']
						@previousGames[tempGame['Team1']['TeamId']]["#{i}"]['result2'] = tempGame['MatchResults'][0]['PointsTeam2']
					else
						@previousGames[tempGame['Team1']['TeamId']]["#{i}"]['result1'] = ""
						@previousGames[tempGame['Team1']['TeamId']]["#{i}"]['result2'] = ""
					end
				end
				
				if @previousGames[tempGame['Team2']['TeamId']]
					@previousGames[tempGame['Team2']['TeamId']]["#{i}"] = {}
					@previousGames[tempGame['Team2']['TeamId']]["#{i}"]['date'] = t.strftime("%d.%m.%Y")
					@previousGames[tempGame['Team2']['TeamId']]["#{i}"]['icon1'] = tempGame['Team1']['TeamIconUrl']
					@previousGames[tempGame['Team2']['TeamId']]["#{i}"]['icon2'] = tempGame['Team2']['TeamIconUrl']
					if tempGame['MatchResults'][0]
						@previousGames[tempGame['Team2']['TeamId']]["#{i}"]['result1'] = tempGame['MatchResults'][0]['PointsTeam1']
						@previousGames[tempGame['Team2']['TeamId']]["#{i}"]['result2'] = tempGame['MatchResults'][0]['PointsTeam2']
					else
						@previousGames[tempGame['Team2']['TeamId']]["#{i}"]['result1'] = ""
						@previousGames[tempGame['Team2']['TeamId']]["#{i}"]['result2'] = ""
					end
				end
			end
		end
		
	end
	
    def new
        @tipp=Tipp.new()
    end
    
    def create
        allSaved=true
        for i in 0..8
        	#check if tipp has already been entered for this game
            oldTipp = Tipp.find_by user_id: session[:user_id], spiel: params['tipp']['spiel'][i]
            if oldTipp
                tipp = oldTipp
            else
            	tipp = Tipp.new
            	tipp.user_id = session[:user_id]
            	tipp.spiel = params['tipp']['spiel'][i]
            end
            tipp.tipp1 = params['tipp']['tipp1'][i]
            tipp.tipp2 = params['tipp']['tipp2'][i]
            
            
            
            #save new tipp
            if tipp.tipp1!=nil || tipp.tipp2!=nil || oldTipp
                if !tipp.save #in case of an error whilst saving
                    allSaved=false
                end
            end
        end
        if allSaved
            flash.notice = "Tipps erfolgreich gespeichert"
        else
            flash.alert = "Fehler beim Speichern"
        end
        redirect_to "/tippen/"+params[:id]
    end
    
    private
	def tipp_params
		params.require(:tipp).permit(:user_id, :spiel, :tipp1, :tipp2)
	end
end

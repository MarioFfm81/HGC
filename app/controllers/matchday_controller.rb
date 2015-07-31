class MatchdayController < ApplicationController
    before_action :require_admin
    
    def calculate
        @currentMatchday = params['matchdaySelected']
		if (@currentMatchday.to_i>34 || @currentMatchday.to_i<1) && @currentMatchday != 'all'
			flash.alert = 'Fehler beim Berechnen'
		else
            if @currentMatchday == 'all'
                currentMatchday=[]
        		url = URI.parse(@@URI)
        		res = Net::HTTP.start(url.host,url.port) do |http|
        		  http.get("#{@@API_CURR}/#{@@LEAGUE}")
        		end
        		currentMatchday = JSON.parse res.body
        		if currentMatchday['GroupOrderID'] && currentMatchday['GroupOrderID'].to_i > 1
        			(1..(currentMatchday['GroupOrderID'].to_i)-1).each do |i|
                        calculateOneMatchday(i)
        			end
        		end
            else
                calculateOneMatchday(@currentMatchday.to_i)
                newPost = Post.new
                newPost.title = "Berechnung für Spieltag #{@currentMatchday.to_s} abgeschlossen"
                newPost.content = ""
                Result.where(:year => @@SAISON, :matchday => @currentMatchday.to_i).order(result: :asc).each do |res|
                    tempRes = '%.2f' % res.result
                    if res.user.nickname != ""
                        newPost.content += "#{res.user.nickname}: #{tempRes.to_s.gsub('.',',')}€\n"
                    else
                        newPost.content += "#{res.user.username}: #{tempRes.to_s.gsub('.',',')}€\n" 
                    end
                end
                newPost.save
            end
		end
		
        flash.notice = "Berechnung abgeschlossen"
        redirect_to '/admin'
    end
    
    def calculateOneMatchday(matchday)
		@games=[]
		url = URI.parse(@@URI)
		res = Net::HTTP.start(url.host,url.port) do |http|
		  http.get("#{@@API_PATH}/#{@@LEAGUE}/#{@@SAISON}/#{matchday}")
		end
		@games = JSON.parse res.body
		if !@games
		    flash.alert= "Probleme beim Webservuce-Zugriff"
		end
		users=User.all
		users.each do |user|
		    total = 0.0
	        @games.each do |game|
	            tipp = user.tipps.find_by(:user_id=>user.id, :spiel=> game['MatchID']) 
		        if tipp
        	        #if tipp.tipp1==game['MatchResults'][0]['PointsTeam1'] && tipp.tipp2 ==game['MatchResults'][0]['PointsTeam2']
                    if tipp.tipp1==1 && tipp.tipp2 ==1
                        total +=-0.5
                    else 
                        #if tipp.tipp2-tipp.tipp1 == game['MatchResults'][0]['PointsTeam2']-game['MatchResults'][0]['PointsTeam1']
                        if tipp.tipp2-tipp.tipp1 == 1-2
                            total +=-0.25
                        else
                            total +=0.25
                        end
                    end
        	    else
        	        total += 0.25
        	    end
        	end
        	total=0.0 if total<0.0
        	res = Result.find_by(:user_id => user.id, :matchday => matchday, :year => @@SAISON)
        	if !res
        	    res = Result.new
        	    res.year = @@SAISON
        	    res.matchday = matchday
        	    res.user_id = user.id
        	end
        	res.result = total
        	res.save
        end
        	   
		                
	end
end

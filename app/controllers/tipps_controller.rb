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
		@games.each do |game|
		    t = DateTime.parse(game['MatchDateTime'])
		    oldTipp = Tipp.find_by user_id: session[:user_id], spiel: game['MatchID']
		    if oldTipp
		        game['tipp1'] = oldTipp.tipp1
		        game['tipp2'] = oldTipp.tipp2
            end
		    game['date'] = t.strftime("%d.%m.%Y")
		    game['time'] = t.strftime("%H:%M")
		    game['active'] = t>Time.now
		end
	end
	
    def new
        @tipp=Tipp.new()
    end
    
    def create
        allSaved=true
        for i in 0..8
            tipp = Tipp.new
            tipp.user_id = session[:user_id]
            tipp.spiel = params['tipp']['spiel'][i]
            tipp.tipp1 = params['tipp']['tipp1'][i]
            tipp.tipp2 = params['tipp']['tipp2'][i]
            
            #delete existing tipp for this user and match
            oldTipp = Tipp.find_by user_id: session[:user_id], spiel: params['tipp']['spiel'][i]
            if oldTipp
                oldTipp.destroy
            end
            
            #save new tipp
            if tipp.tipp1!=nil || tipp.tipp2!=nil
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

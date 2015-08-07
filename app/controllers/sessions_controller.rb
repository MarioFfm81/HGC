class SessionsController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:destroy]
	def new
	end
	
	def create
		@user = User.find_by_username(params[:session][:username].downcase)
		if @user && @user.authenticate(params[:session][:password])
			session[:user_id] = @user.id
			puts "INFO: id in session: #{session[:user_id]}"
			if params[:session][:username].downcase=='marioffm81'
				session[:hgcAdmin]=true
			end
			puts "INFO: login erfolgreich für: #{params[:session][:username].downcase}"
			redirect_to '/'
		else
			puts "ERROR: Login für: #{params[:session][:username].downcase}"
			redirect_to '/login'
		end
	end
	
	def destroy
		session[:user_id] = nil
		session[:hgcAdmin] = nil
		redirect_to '/'
	end
end

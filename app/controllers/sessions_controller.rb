class SessionsController < ApplicationController
	skip_before_action :verify_authenticity_token, only: [:destroy]
	def new
	end
	
	def create
		@user = User.find_by_username(params[:session][:username])
		if @user && @user.authenticate(params[:session][:password])
			session[:user_id] = @user.id
			if params[:session][:username]=='marioffm81'
				session[:hgcAdmin]=true
			end
			redirect_to '/'
		else
			redirect_to '/login'
		end
	end
	
	def destroy
		session[:user_id] = nil
		session[:hgcAdmin] = nil
		redirect_to '/'
	end
end

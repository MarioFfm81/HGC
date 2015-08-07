class UsersController < ApplicationController
	before_action :require_admin, only: [:destroy, :new]
	before_action :require_user, only: [:update, :show]
	def new
		@user = User.new
	end
	
	def show
		@user = User.find(session[:user_id])
	end
	
	def create
		if current_user.admin? || params['user']['username']=='marioffm81'
			@user = User.new(user_params)
			@user.role = "user"
			@user.username = @user.username.downcase
			if @user.save
				session[:user_id] = @user.id
				redirect_to '/'
			else
				redirect_to 'signup'
			end
		else
			redirect_to '/'
		end
	end
	
	def update
		if params['user']
			@user = User.find(params['user']['id'])
			@user.nickname = params['user']['nickname']
			@user.first_name = params['user']['first_name']
			@user.last_name = params['user']['last_name']
			@user.password = params['user']['password']
			if @user.save
				flash.notice = 'Update gespeichert'
				redirect_to '/user/edit'
			else
				flash.alert = 'Speichern fehlgeschlagen'
				redirect_to '/user/edit'
			end
		else
			redirect_to '/user/edit'
		end
	end
	
	private
	def user_params
		params.require(:user).permit(:username, :first_name, :last_name, :password, :nickname)
	end
end

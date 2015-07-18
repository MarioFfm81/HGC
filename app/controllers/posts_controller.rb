class PostsController < ApplicationController
	before_action :require_admin, only: [:new, :create, :destroy]
	
	def new
		@post = Post.new
	end
	
	def create
		@post = Post.new(post_params)
		if @post.save
			redirect_to '/home'
		else
			redirect_to '/posts/new'
		end
	end
	
	def index
		@posts = Post.last(10).sort_by{|created_at| created_at}.reverse
	end

	private
	def post_params
		params.require(:post).permit(:title, :content)
	end
end

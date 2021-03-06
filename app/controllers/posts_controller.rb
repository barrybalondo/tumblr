class PostsController < ApplicationController
	before_action :authenticate_user!, 	except: [:index, :show]
	before_action :find_post, only: [:show, :edit, :update, :destroy]
	before_action :require_same_user, only: [:edit, :update, :destroy]


	def index
		@posts = Post.all.order('created_at DESC')
	end

	def new
		@post = current_user.posts.build
	end

	def create
		@post = current_user.posts.build(post_params)
		@post.user_id = current_user.id
		if @post.save
			redirect_to @post
		else
			render 'new'
		end
	end

	def show
	end

	def edit
	end

	def update
		if @post.update(params.require(:post).permit(:title, :body))
			redirect_to @post
		else
			render 'edit'
		end
	end

	def destroy
		@post.destroy

		redirect_to root_path

	end

	private
	
		def post_params
			params.require(:post).permit(:title, :body)
		end

		def find_post
			@post = Post.find(params[:id])
		end

		def require_same_user
      # set restriction for editing articles only to the one created them
      if current_user.id != @post.user_id
        flash = "You can only edit or delete your own post"
        redirect_to root_path
      end
    end




end

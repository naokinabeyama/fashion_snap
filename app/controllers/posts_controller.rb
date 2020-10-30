class PostsController < ApplicationController
	before_action :authenticate_user!, only: [:edit, :new, :show, :create]
  before_action :correct_user, only: [:update, :edit]

  def index
  	@posts = Post.all
    @post = Post.new
    @user = current_user
  end

  def edit
    @post = Post.find(params[:id])
  end

  def show
  	@post = Post.find(params[:id])
  	@user = @post.user
    @post_comment = PostComment.new
  end

  def new
  	@post = Post.new
  end

  def search
    @posts = Post.all
    @posts = @posts.where('title LIKE ? OR body LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
  end

  def create
  	@post = Post.all
  	@post = Post.new(post_params)
  	@post.user = current_user
  	if @post.save
  	  redirect_to post_path(@post)
    else
      render :index
    end
  end

  def update
    @user = current_user
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @user = current_user
    @post.destroy
    redirect_to user_path(@user)
  end

  private
  def post_params
    params.require(:post).permit(:title, :body, :post_image, :user_id)
  end

  def correct_user
    post = Post.find(params[:id])
    if current_user != post.user
      redirect_to root_path
    end
  end

end
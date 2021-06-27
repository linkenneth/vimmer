class PostsController < ApplicationController
  before_action :authenticate_user!

  ##
  # GET /posts
  #
  # Returns posts of those the current user follows.

  def index
    Post.where(user: current_user.followed_users)
  end

  ##
  # POST /posts
  # TODO: validation

  def create
    content = params.require(:post).require(:content)
    post = Post.create!(author: current_user, content: content)

    # TODO: show info of author
    render json: post.as_json
  end

  ##
  # GET /posts/:id

  def show
  end

  ##
  # PATCH /posts/:id
  # PUT /posts/:id

  def update
  end

  ##
  # DELETE /posts/:id

  def destroy
  end

end

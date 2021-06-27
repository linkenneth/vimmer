class PostsController < ApplicationController
  before_action :authenticate_user!

  ##
  # GET /posts

  def index
    render json: Post.all.map(&:as_json)
  end

  ##
  # POST /posts
  # TODO: validation

  def create
    content = params.require(:post).require(:content)
    Post.create!(user: current_user, content: content)
    # TODO: show info of author
    render json: p.as_json
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

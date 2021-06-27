class FollowsController < ApplicationController
  before_action :authenticate_user!

  ##
  # GET /follows

  def index
    render json: current_user.follows.map(&:as_json)
  end

  ##
  # POST /follows
  # TODO: validation

  def create
    content = params.require(:post).require(:content)
    follow = Follow.create!(user: current_user, content: content)
    render json: follow.as_json
  end

  ##
  # GET /follows/:id

  def show
  end

  ##
  # PATCH /follows/:id
  # PUT /follows/:id

  def update
  end

  ##
  # DELETE /follows/:id

  def destroy
  end

end

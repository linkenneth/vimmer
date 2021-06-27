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
    followed_user_id = params.require(:post).require(:followed_user_id)
    follow = Follow.create!(
      following_user: current_user,
      followed_user: followed_user_id
    )
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

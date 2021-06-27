class PostsController < ApplicationController
  before_action :authenticate_user!

  ##
  # GET /posts
  #
  # Returns posts of those the current user follows.
  # Posts are naively ordered by the number of likes they have.

  def index
    posts = (
      Post
        .where(user: current_user.followed_users)
        .left_joins(:likes)
        .group('posts.id')
        .order('COUNT(likes.id) DESC')
    )
    render json: posts.as_json
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

  ##
  # POST /posts/:id/like

  def like
    post_id = params.require(:post_id)
    Like.create!(
      user: current_user,
      likable_type: 'Post',
      likable_id: post_id
    )
    head :ok
  end

end

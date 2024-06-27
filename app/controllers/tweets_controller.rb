class TweetsController < ApplicationController
  before_action :require_login, only: [:create, :destroy]
  def create
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)

    if session
      user = session.user
      @tweet = user.tweets.new(tweet_params)

      if @tweet.save
        render 'tweets/create' 
      else
        render json: { success: false }
      end
    else
      render json: { success: false }
    end
  end

  def destroy
    @tweet = Tweet.find_by(id: params[:id])

    if @tweet&.destroy
      render json: { success: true }
    else
      render json: { success: false }
    end
  end
  
  def index
    @tweets = Tweet.order(created_at: :desc)
    render 'tweets/index'
  end
 
  def index_by_user
    user = User.find_by(username: params[:username])
    if user
      @tweets = user.tweets.order(created_at: :desc) 
      render 'tweets/index'
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private
  def tweet_params
    params.require(:tweet).permit(:message)
  end

  def require_login
    token = cookies.signed[:twitter_session_token]
    session = Session.find_by(token: token)
    unless session
      render json: { success: false }
    end
  end

  # def current_user
  #   token = cookies.signed[:twitter_session_token]
  #   session = Session.find_by(token: token)
  #   session&.user
  # end


end



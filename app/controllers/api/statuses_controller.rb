class Api::StatusesController < ApplicationController
  
  include ActionController::Live
  
  skip_before_filter :verify_authenticity_token

  respond_to :json
  
  def create
    username, status = params[:username], params[:status]
    user = User.find_or_create_by nickname: username
    status = user.statuses.create! message: status
    render json: status
  end
  
  def subscribe
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 300, event: "status-created")
    username = params[:username]
    sse.write({id: 0, message: "Hola #{username} #{Time.now}", created_at: Time.now})
    Status::SSE_PER_NICKNAME[username] = sse
    render nothing: true
  end
  
  def fetch
    username = params[:username]
    statuses = []
    
    if user = User.find_by(nickname: username)
      statuses = user.statuses.limit(5)
    end
    
    render json: statuses
  end
  
end
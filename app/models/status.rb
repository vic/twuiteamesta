class Status < ActiveRecord::Base
  
  SSE_PER_NICKNAME = {
  
  }
  
  belongs_to :user
  
  default_scope -> { order('created_at DESC') }
  
  after_create :stream
  
  def stream
    sse = SSE_PER_NICKNAME[user.nickname]
    return unless sse
    sse.write(self.as_json)
  end

end

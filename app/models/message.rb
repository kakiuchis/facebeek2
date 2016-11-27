class Message < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user
  
  validates_presence_of :body, :conversation_id, :user_id
  def message_time
    created_at.strftime("%Y年%d月%m日 %p %l:%M" )
  end
end

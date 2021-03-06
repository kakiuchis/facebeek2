class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @topic = @comment.topic
    respond_to do |format|
      if @comment.save
        format.html { redirect_to topic_path(@topic), notice: 'コメントを投稿しました。' }
        format.js { render :index }
      else
        format.html { render :new }
      end
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id != current_user.id
      render :index
    else
      @comment.destroy
      render :index
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:topic_id, :content)
    end
end

class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :edit, :update, :destroy]
  before_action :set_friends, only: [:index, :show, :create, :destroy]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.order(:created_at).reverse_order
    @topic = Topic.new
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    if @friends.include?(@topic.user)
      @comment = @topic.comments.build
      @comments = @topic.comments
    elsif @topic.user == current_user
      @comment = @topic.comments.build
      @comments = @topic.comments
    else
      redirect_to controller: 'topics', action: 'index'
    end
  end

  # GET /topics/1/edit
  def edit
    if @topic.user_id != current_user.id
      redirect_to controller: 'topics', action: 'index'
    end
  end

  # POST /topics
  # POST /topics.json
  def create
    @topics = Topic.order(:created_at).reverse_order
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    respond_to do |format|
      if @topic.save
        #format.html { redirect_to topic_path(@topic) }
        format.js { render :index }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: '編集が完了しました' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    if @topic.user_id != current_user.id
      redirect_to controller: 'topics', action: 'index'
    else
      @topic.destroy
      respond_to do |format|
        format.html { redirect_to topics_url}
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:content)
    end

    def set_friends
      @friends = current_user.followers & current_user.followed_users
    end
end

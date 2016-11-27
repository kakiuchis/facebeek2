class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.order(:created_at).reverse_order
    @friends = current_user.followers & current_user.followed_users
    @topic = Topic.new
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @comment = @topic.comments.build
    @comments = @topic.comments
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topics = Topic.order(:created_at).reverse_order
    @friends = current_user.followers & current_user.followed_users
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    respond_to do |format|
      if @topic.save
        #format.html { redirect_to topic_path(@topic) }
        format.json { render :show, status: :created, location: @topic }
        format.js { render :index }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: '編集が完了しました' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url}
      format.json { head :no_content }
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
end

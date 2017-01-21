class FollowsController < ApplicationController
  before_filter(only: :index) { |c| c.send :check_sorting_params, Topic }

  # GET /follows
  # GET /follows.json
  def index
    @folded = true
    @widgets_mode = true
    @users = User.select('users.*').followed_by(current_user)
    @topics = Topic.and_stuff.followed_by(current_user).with_bookmarks(current_user).order(params[:sort] + " " + params[:direction]).page(params[:page])
    @meta = true

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @follows }
    end
  end

  # GET /follows/1
  # GET /follows/1.json
  def show
    @follow = Follow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @follow }
    end
  end

  # GET /follows/new
  # GET /follows/new.json
  def new
    @follow = Follow.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @follow }
    end
  end

  # GET /follows/1/edit
  def edit
    @follow = Follow.find(params[:id])
  end

  # POST /follows
  # POST /follows.json
  def create
    @follow = Follow.find_or_create_by_followable_type_and_followable_id_and_user_id(params[:follow][:followable_type], params[:follow][:followable_id], current_user.id)

    respond_to do |format|
      if @follow.save
        format.html { redirect_to redirect_url(@follow) }
        format.json { render json: @follow, status: :created, location: @follow }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /follows/1
  # PUT /follows/1.json
  def update
    @follow = Follow.find(params[:id])

    respond_to do |format|
      if @follow.update_attributes(params[:follow])
        format.html { redirect_to @follow, notice: 'Follow was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1
  # DELETE /follows/1.json
  def destroy
    @follow = Follow.find(params[:id])
    @follow.destroy

    respond_to do |format|
      format.html { redirect_to redirect_url(@follow) }
      format.json { head :no_content }
      format.js
    end
  end

  private

  def redirect_url(follow)
    case @follow.followable_type
    when 'User'
      user_url(@follow.followable)
    when 'Forum'
      forum_url(@follow.followable, page: params[:page])
    when 'Topic'
      topic_url(@follow.followable, page: params[:page])
    when 'Message'
      topic_url(@follow.followable.topic, page: params[:page], anchor: "m#{@follow.followable_id}")
    end
  end
end

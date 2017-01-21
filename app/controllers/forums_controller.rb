class ForumsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show, :feed]
  before_filter :get_stats, :only => :index
  before_filter(only: :show) { |c| c.send :check_sorting_params, Topic }

  # GET /forums
  # GET /forums.json
  def index
    @forums = Forum.includes(:children, last_message: [:user, :topic]).where(:parent_id => nil).accessible_for(current_user, 'view')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @forums }
    end
  end

  def feed
    @forum = Forum.includes(:children).find(params[:id])
    authorize! :read, @forum
    @topics = Topic.includes(:user, :first_message).child_of(@forum).accessible_for(nil, 'view').order('topics.id desc').limit(10)

    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  # GET /forums/1
  # GET /forums/1.json
  def show
    @forum = Forum.select('forums.*').with_follows(current_user).includes(:children).find(params[:id])
    if request.path != forum_path(@forum)
      return redirect_to @forum, :status => :moved_permanently
    end
    authorize! :read, @forum

    @topics = Topic.and_stuff.with_bookmarks(current_user).child_of(@forum).accessible_for(current_user, 'view').order('topics.pinned desc').order(params[:sort] + " " + params[:direction]).page(params[:page])
    @topics = @topics.includes(:forum) if @forum.children.any?

    @pinnable = true
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @forum }
    end
  end

  # GET /forums/new
  # GET /forums/new.json
  def new
    @forum = Forum.new
    authorize! :create, @forum

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @forum }
    end
  end

  # GET /forums/1/edit
  def edit
    @forum = Forum.find(params[:id])
    authorize! :update, @forum
  end

  # POST /forums
  # POST /forums.json
  def create
    @forum = Forum.new(params[:forum])
    authorize! :create, @forum
    if @forum.parent_id
      @forum.position = @forum.parent.position
      @forum.parent.touch
    end

    respond_to do |format|
      if @forum.save
        format.html { redirect_to forums_url, notice: t('forums.created') }
        format.json { render json: @forum, status: :created, location: @forum }
      else
        format.html { render action: "new" }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /forums/position
  def position
    authorize! :position, Forum.new
    i = 1
    params[:forums].each do |f|
      if f.present?
        f = Forum.find(f.to_i)
        f.update_column :position, i
        f.children.update_all :position => i
        i = i + 1
      end
    end

    respond_to do |format|
      format.html { redirect_to forums_url }
      format.json { head :no_content }
    end
  end

  # PUT /forums/1
  # PUT /forums/1.json
  def update
    @forum = Forum.find(params[:id])
    authorize! :update, @forum

    respond_to do |format|
      if @forum.update_attributes(params[:forum])
        format.html { redirect_to forums_url, notice: t('forums.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forums/1
  # DELETE /forums/1.json
  def destroy
    @forum = Forum.find(params[:id])
    authorize! :destroy, @forum
    @forum.destroy

    respond_to do |format|
      format.html { redirect_to forums_url }
      format.json { head :no_content }
    end
  end

  private

  def get_stats
    @users = User.where('updated_at >= ?', 5.minutes.ago)
  end
end

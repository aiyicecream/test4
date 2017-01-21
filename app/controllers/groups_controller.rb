class GroupsController < ApplicationController
  before_filter :authenticate_user!

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.for_user(current_user).includes(:users).page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    redirect_to users_url(group: params[:id])
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new
    authorize! :create, @group

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    authorize! :update, @group
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])
    authorize! :create, @group
    @group.user = current_user

    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_url, notice: t("groups.created.#{@group.status}") }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])
    authorize! :update, @group

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to groups_url, notice: t('groups.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    authorize! :destroy, @group
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end
end

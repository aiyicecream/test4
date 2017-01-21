class NotificationsController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!

  # GET /notifications
  # GET /notifications.json
  def index
    @folded = true
    @meta = true
    @as_notifications = true
    @messages = current_user.notified_messages.select('messages.*, notifications.id as notification_id, notifications.read as notification_read').includes(:topic, :user, :updater, :small_messages => :user).order('notifications.id desc').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @notifications }
    end
  end

  # PUT /notifications/1
  def mark_as_read
    Notification.where(:user_id => current_user.id, :id => params[:id]).first.update_column :read, true
    current_user.update_notifications_count

    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
      format.js
    end
  end

  # PUT /notifications
  def mark_all_as_read
    Notification.where(:user_id => current_user.id).update_all read: true
    current_user.update_column :notifications_count, 0

    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
      format.js
    end
  end

  # DELETE /notifications
  def clear
    Notification.where(:user_id => current_user.id).delete_all
    current_user.update_column :notifications_count, 0

    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to notifications_url }
      format.json { head :no_content }
      format.js { head :no_content }
    end
  end
end

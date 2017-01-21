class DomainsController < ApplicationController
  # @domain is already loaded in an application_controller before_filter

  # Keep dynamic CSS simple
  skip_filter(*_process_action_callbacks.map(&:filter), only: :css)

  def css
    @domain = Domain.find_by_name(request.host)
    respond_to do |format|
      format.css
    end
  end

  # GET /admin
  # GET /admin.json
  def show
    authorize! :manage, @domain
    respond_to do |format|
      format.html
      format.json { render json: @domain }
    end
  end

  def check
    params[:q].sub! /^(www\.)+/, ''
    render json: Domain.where(name: params[:q] + ".#{request.domain}").first.try(:users_count).to_i == 0
  end

  def delete_banner
    authorize! :manage, @domain
    @domain.banner.destroy
    respond_to do |format|
      format.html { redirect_to domains_url }
      format.json { head :no_content }
      format.js
    end
  end

  # PUT /admin
  # PUT /admin.json
  def update
    authorize! :manage, @domain
    respond_to do |format|
      if @domain.update_attributes(params[:domain])
        format.html { redirect_to domains_url, notice: t('domains.updated') }
        format.json { head :no_content }
      else
        format.html { render action: :show }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end
end

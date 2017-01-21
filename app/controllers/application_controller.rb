class ApplicationController < ActionController::Base
  set_current_tenant_through_filter
  prepend_before_filter :set_tenant

  protect_from_forgery
  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  private

  def set_tenant
    if request.subdomain.starts_with? 'www.'
      redirect_to request.url.sub(request.subdomain, request.subdomain.sub(/^(www\.)+/, ''))
    elsif request.subdomain.blank? && request.host != 'localhost'
      redirect_to request.url.sub(request.domain, "www.#{request.domain}")
    end
    ActionMailer::Base.default_url_options[:host] = request.host
    @domain = Domain.find_or_create_by_name(request.host)
    @domain.title = request.host if @domain.title.blank?
    set_current_tenant(@domain)
  end

  def set_locale
    Time.zone = cookies['time_zone']
    I18n.locale = http_accept_language.preferred_language_from(%w[en fr es])

    # Also update updated_at
    current_user.update_attribute :locale, I18n.locale if current_user
  end

  def check_sorting_params klass
    params[:sort] = klass.default_column unless klass.column_names.include?(params[:sort])
    params[:direction] = klass.default_direction(params[:sort]) unless %w[asc desc].include?(params[:direction])
  end
end

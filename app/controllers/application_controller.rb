class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  # before_action :authenticated_chatwork_user

  def all
    Rails.logger.info "---------------- request ------------------"
    Rails.logger.info params.inspect
    Rails.logger.info "---------------- end      -----------------"
    render plain: :ok
  end

  private

  def authenticated_chatwork_user
    return if !user_signed_in? || Service::Chatwork.access_token(force_refresh = true)
    render plain: "Watting for sync with chatwork account"
  end
end

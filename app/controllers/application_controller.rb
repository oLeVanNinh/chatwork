class ApplicationController < ActionController::Base
  before_action :authenticated_user

  private

  def authenticated_user
    return if Service::Chatwork.access_token(force_refresh = true)
    render plain: "Watting for sync with chatwork account"
  end
end

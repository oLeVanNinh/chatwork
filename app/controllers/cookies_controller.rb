class CookiesController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticated_user

  def update
    cookies_string = params[:cookie_string]
    if cookies_string
      Rails.cache.write(:cookie_string, cookies_string)

      if Service::Chatwork.access_token(true)
        Service::Chatwork.sync_room_info
        render json: { status: "success", message: 'OK' }
      else
        render json: { status: "fail", message: "Cookie is invalid" }
      end
    else
      render json: { status: "fail", message: "Cookie is required" }
    end
  end
end

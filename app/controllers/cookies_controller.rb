class CookiesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def update
    cookies_string = params[:cookie_string]
    if cookies_string
      Rails.cache.write(:cookie_string, cookies_string)
      render json: { status: "success" }
    else
      render json: { status: "false", message: "Cookie is required" }
    end
  end
end

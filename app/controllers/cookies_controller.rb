class CookiesController < ApplicationController
  skip_authorization_check

  def consent
    cookies["allow_cookies"] = cookies_consent_params[:allow_cookies]

    redirect_to request.referer
  end

  private

    def cookies_consent_params
      params.permit(:allow_cookies)
    end
end

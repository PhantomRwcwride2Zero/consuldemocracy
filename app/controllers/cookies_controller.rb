class CookiesController < ApplicationController
  skip_authorization_check

  def consent
    cookies["allow_cookies"] = cookies_consent_params[:allow_cookies]

    if cookies_by_vendor_params.present?
      Cookies::Vendor.find_each do |vendor|
        cookies[vendor.cookie] = cookies_by_vendor_params[vendor.cookie].present?
      end
    end

    redirect_to request.referer, notice: t("cookies_consent.notice")
  end

  private

    def cookies_consent_params
      params.permit(:allow_cookies)
    end

    def cookies_by_vendor_params
      params.permit(::Cookies::Vendor.pluck(:cookie))
    end
end

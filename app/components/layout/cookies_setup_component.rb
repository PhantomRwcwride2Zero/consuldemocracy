class Layout::CookiesSetupComponent < ApplicationComponent
  delegate :cookies, to: :helpers

  def third_party_cookies
    sanitize(Setting["cookies_consent.third_party"])
  end

  def vendors
    Cookies::Vendor.all
  end
end

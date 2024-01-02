class Layout::CookiesSetupComponent < ApplicationComponent
  def third_party_cookies
    sanitize(Setting["cookies_consent.third_party"])
  end
end

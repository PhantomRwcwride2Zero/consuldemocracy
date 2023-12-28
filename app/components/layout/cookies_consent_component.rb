class Layout::CookiesConsentComponent < ApplicationComponent
  delegate :cookies, to: :helpers

  def render?
    feature?(:cookies_consent) && missing_cookies_setup?
  end

  private

    def missing_cookies_setup?
      cookies[:allow_cookies].blank?
    end
end

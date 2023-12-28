class Layout::CookiesConsentComponent < ApplicationComponent
  delegate :cookies, to: :helpers

  def render?
    feature?(:cookies_consent) && missing_cookies_setup?
  end

  def more_info_link
    Setting["cookies_consent.more_info_link"]
  end

  private

    def missing_cookies_setup?
      cookies[:allow_cookies].blank?
    end
end

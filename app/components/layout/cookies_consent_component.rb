class Layout::CookiesConsentComponent < ApplicationComponent
  delegate :cookies, to: :helpers

  def render?
    feature?(:cookies_consent) && missing_cookies_setup?
  end

  def more_info_link
    Setting["cookies_consent.more_info_link"]
  end

  def third_party_cookies?
    Setting["cookies_consent.third_party"].present?
  end

  private

    def missing_cookies_setup?
      current_value.blank?
    end

    def current_value
      cookies[:allow_cookies]
    end
end

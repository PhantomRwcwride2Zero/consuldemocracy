require "rails_helper"

describe Layout::CookiesConsentComponent do
  before { Setting["feature.cookies_consent"] = true }

  it "renders the banner when cookies were not accepted" do
    render_inline Layout::CookiesConsentComponent.new

    expect(page).to have_css(".cookies-consent")
  end

  it "does not render the banner when cookies were accepted" do
    allow_any_instance_of(Layout::CookiesConsentComponent).to receive(:current_value).and_return("all")

    render_inline Layout::CookiesConsentComponent.new

    expect(page).not_to have_css(".cookies-consent")
  end

  it "does not render the banner when third party cookies were rejected" do
    allow_any_instance_of(Layout::CookiesConsentComponent).to receive(:current_value).and_return("essential")

    render_inline Layout::CookiesConsentComponent.new

    expect(page).not_to have_css(".cookies-consent")
  end

  it "does not render the banner when feature `cookies_consent` is disabled" do
    Setting["feature.cookies_consent"] = nil

    render_inline Layout::CookiesConsentComponent.new

    expect(page).not_to have_css(".cookies-consent")
  end

  it "renders a link when the setting `cookies_consent.more_info_link` is defined" do
    Setting["cookies_consent.more_info_link"] = "/cookies_policy"

    render_inline Layout::CookiesConsentComponent.new

    expect(page).to have_link("More information", href: "/cookies_policy")
  end

  it "does not renders a link when the setting `cookies_consent.more_info_link` is not defined" do
    Setting["cookies_consent.more_info_link"] = ""

    render_inline Layout::CookiesConsentComponent.new

    expect(page).not_to have_link("More information")
  end

  it "renders the cookies consent rejection link when the third_party setting is defined" do
    Setting["cookies_consent.third_party"] = "<li>Google Analytics</li>"

    render_inline Layout::CookiesConsentComponent.new

    expect(page).to have_button("Reject")
  end
end

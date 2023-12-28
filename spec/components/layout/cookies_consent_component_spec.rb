require "rails_helper"

describe Layout::CookiesConsentComponent do
  before { Setting["feature.cookies_consent"] = true }

  it "renders the banner when cookies were not accepted" do
    render_inline Layout::CookiesConsentComponent.new

    expect(page).to have_css(".cookies-consent")
  end

  it "does not render the banner when cookies were accepted" do
    allow_any_instance_of(Layout::CookiesConsentComponent)
      .to receive(:missing_cookies_setup?).and_return(false)

    render_inline Layout::CookiesConsentComponent.new

    expect(page).not_to have_css(".cookies-consent")
  end

  it "does not render the banner when feature `cookies_consent` is disabled" do
    Setting["feature.cookies_consent"] = nil

    render_inline Layout::CookiesConsentComponent.new

    expect(page).not_to have_css(".cookies-consent")
  end
end

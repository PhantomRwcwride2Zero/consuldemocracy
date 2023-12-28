require "rails_helper"

describe "Cookies consent" do
  before { Setting["feature.cookies_consent"] = true }

  scenario "Is not shown when feature is disabled" do
    Setting["feature.cookies_consent"] = false

    visit root_path

    expect(page).not_to have_css(".cookies-consent")
  end

  scenario "Hides the cookies consent banner when accepted and for consecutive visits" do
    visit root_path

    within ".cookies-consent" do
      click_button "Accept"
    end

    expect(page).not_to have_css(".cookies-consent")

    visit root_path

    expect(page).not_to have_css(".cookies-consent")
  end
end
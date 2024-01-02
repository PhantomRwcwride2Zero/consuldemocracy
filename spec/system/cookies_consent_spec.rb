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

  context "when third party setting is defined" do
    before { Setting["cookies_consent.third_party"] = "<li>Google Analytics</li>" }

    scenario "Hides the cookies consent banner when rejected and for consecutive visits" do
      visit root_path

      within ".cookies-consent" do
        click_button "Reject"
      end

      expect(page).not_to have_css(".cookies-consent")

      visit root_path

      expect(page).not_to have_css(".cookies-consent")
    end

    scenario "Opens the cookies setup modal" do
      visit root_path

      within ".cookies-consent" do
        click_button "Setup"
      end

      expect(page).to have_css(".cookies-setup")
      expect(page).to have_css("h2", text: "Cookies setup")
    end

    scenario "Allow users to accept all cookies from the cookies setup modal" do
      visit root_path

      within ".cookies-consent" do
        click_button "Setup"
      end

      within ".cookies-setup" do
        click_button "Accept all"
      end

      expect(page).not_to have_css(".cookies-consent")

      visit root_path

      expect(page).not_to have_css(".cookies-consent")
    end

    scenario "Allow users to accept essential cookies from the cookies setup modal" do
      visit root_path

      within ".cookies-consent" do
        click_button "Setup"
      end

      within ".cookies-setup" do
        click_button "Accept essential cookies"
      end

      expect(page).not_to have_css(".cookies-consent")

      visit root_path

      expect(page).not_to have_css(".cookies-consent")
    end
  end
end

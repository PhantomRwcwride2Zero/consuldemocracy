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

  context "when third party cookie vendors are defined" do
    scenario "users can accept all at once" do
      script = "$('body').append('Running third party script');"
      Cookies::Vendor.create!(name: "Vendor Name", cookie: "a_vendor_name", script: script)
      Cookies::Vendor.create!(name: "Cool Vendor", cookie: "cool_vendor_brand", script: script)
      visit root_path

      within ".cookies-consent" do
        click_button "Setup"
      end
      within ".cookies-setup" do
        click_button "Accept all"
      end

      expect(page).not_to have_css(".cookies-consent")
      notice = "Your cookies preferences were saved! You can change them anytime from the " \
               "\"Cookies setup\" link in the page footer."
      expect(page).to have_content(notice)

      expect(page).to have_content("Running third party script", count: 2)
    end

    scenario "users can reject third party cookies" do
      script = "$('body').append('Running third party script');"
      Cookies::Vendor.create!(name: "Vendor Name", cookie: "a_vendor_name", script: script)
      Cookies::Vendor.create!(name: "Cool Vendor", cookie: "cool_vendor_brand", script: script)
      visit root_path

      within ".cookies-consent" do
        click_button "Setup"
      end
      within ".cookies-setup" do
        click_button "Accept essential cookies"
      end

      expect(page).not_to have_css(".cookies-consent")
      notice = "Your cookies preferences were saved! You can change them anytime from the " \
               "\"Cookies setup\" link in the page footer."
      expect(page).to have_content(notice)

      expect(page).not_to have_content("Running third party script")
    end

    scenario "users can select which cookies accept or deny independently" do
      script = "$('body').append('Running third party script');"
      vendor_1 = Cookies::Vendor.create!(name: "Vendor Name", cookie: "a_vendor_name", script: script)
      vendor_2 = Cookies::Vendor.create!(name: "Cool Vendor", cookie: "cool_vendor_brand", script: script)
      visit root_path

      within ".cookies-consent" do
        click_button "Setup"
      end

      within ".cookies-setup" do
        within "#cookies_vendor_#{vendor_1.id}" do
          find("label", text: "No").click
        end

        click_button "Save preferences"
      end

      notice = "Your cookies preferences were saved! You can change them anytime from the " \
               "\"Cookies setup\" link in the page footer."
      expect(page).to have_content(notice)

      visit root_path

      expect(page).not_to have_css(".cookies-consent")

      within ".subfooter" do
        click_link "Cookies setup"
      end

      within "#cookies_vendor_#{vendor_1.id}" do
        expect(page).to have_css("label", text: "Yes")
      end

      within "#cookies_vendor_#{vendor_2.id}" do
        expect(page).to have_css("label", text: "No")
      end

      expect(page).to have_content("Running third party script", count: 1)

      within ".cookies-setup" do
        within "#cookies_vendor_#{vendor_2.id}" do
          find("label", text: "No").click
        end

        click_button "Save preferences"
      end

      expect(page).to have_content("Running third party script", count: 2)
    end
  end
end

require "rails_helper"

describe "Admin cookies vendors", :admin do
  context "Index" do
    scenario "Shows existing cookies and links to actions" do
      Cookies::Vendor.create!(name: "Vendor name", cookie: "cookie_name")
      visit admin_settings_path(anchor: "tab-cookies-consent")

      expect(page).to have_content("Vendor name")
      expect(page).to have_content("cookie_name")
      expect(page).to have_link("Edit")
      expect(page).to have_button("Delete")
      expect(page).to have_link("Create vendor")
    end
  end

  context "Create" do
    scenario "Shows a notice and the new cookie after creation" do
      visit admin_settings_path(anchor: "tab-cookies-consent")

      click_link "Create vendor"
      fill_in "Vendor name", with: "Vendor name"
      fill_in "Cookie name", with: "cookie_name"
      fill_in "Description", with: "Cookie details"
      click_button "Save"

      expect(page).to have_content("Cookie created successfully")
      expect(page).to have_content("Vendor name")
      expect(page).to have_content("cookie_name")
    end
  end

  context "Update" do
    scenario "Shows a notice and the cookie changes after update" do
      Cookies::Vendor.create!(name: "Vendor name", cookie: "cookie_name")
      visit admin_settings_path(anchor: "tab-cookies-consent")

      click_link "Edit"
      fill_in "Vendor name", with: "Cool Company Name"
      click_button "Save"

      expect(page).to have_content("Cookie updated successfully")
      expect(page).to have_content("Cool Company Name")
    end
  end

  context "Destroy" do
    scenario "Shows a notice and remove cookies information" do
      Cookies::Vendor.create!(name: "Vendor name", cookie: "cookie_name")
      visit admin_settings_path(anchor: "tab-cookies-consent")

      accept_confirm { click_button "Delete Vendor name" }

      expect(page).to have_content("Cookie vendor deleted successfully")
      expect(page).not_to have_content("Vendor name")
      expect(page).not_to have_content("vendor_name")
    end
  end
end

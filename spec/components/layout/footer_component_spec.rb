require "rails_helper"

describe Layout::FooterComponent do
  describe "description links" do
    it "generates links that open in the same tab" do
      render_inline Layout::FooterComponent.new

      page.find(".info") do |info|
        expect(info).to have_css "a", count: 2
        expect(info).to have_css "a[rel~=nofollow]", count: 2
        expect(info).to have_css "a[rel~=external]", count: 2
        expect(info).not_to have_css "a[target]"
      end
    end
  end

  describe "when the cookies consent feature is enabled" do
    before { Setting["feature.cookies_consent"] = true }

    it "does not show a link to the cookies setup modal when no third party cookies defined" do
      render_inline Layout::FooterComponent.new

      page.find(".subfooter") do |subfooter|
        expect(subfooter).not_to have_css "a[data-open=cookies_setup]", text: "Cookies setup"
      end
    end

    it "shows a link to the cookies setup modal when third party cookies are defined" do
      Setting["cookies_consent.third_party"] = "<li>Third party vendor</li>"

      render_inline Layout::FooterComponent.new

      page.find(".subfooter") do |subfooter|
        expect(subfooter).to have_css "a[data-open=cookies_setup]", text: "Cookies setup"
      end
    end

    it "shows a link to the cookies setup modal when third party cookies vendos are defined" do
      Cookies::Vendor.create!(name: "Vendor name", cookie: "vendor_name")

      render_inline Layout::FooterComponent.new

      page.find(".subfooter") do |subfooter|
        expect(subfooter).to have_css "a[data-open=cookies_setup]", text: "Cookies setup"
      end
    end
  end
end

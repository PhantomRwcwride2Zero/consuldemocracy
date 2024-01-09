require "rails_helper"

describe Cookies::Vendor do
  let(:cookies_vendor) { build(:cookies_vendor) }

  it "is valid" do
    expect(cookies_vendor).to be_valid
  end

  it "is not valid without a name" do
    cookies_vendor.name = nil

    expect(cookies_vendor).not_to be_valid
  end

  it "is not valid without the cookie name" do
    cookies_vendor.cookie = nil

    expect(cookies_vendor).not_to be_valid
  end
end

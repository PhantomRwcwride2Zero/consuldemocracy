class Cookies::Vendors::FormComponent < ApplicationComponent
  attr_reader :vendors
  delegate :cookies, :dom_id, to: :helpers

  def initialize(vendors)
    @vendors = vendors
  end

  def render?
    vendors.any?
  end

  def enabled?(vendor)
    cookies["allow_cookies#{version_name}"] == "all" ||
      (cookies[vendor.cookie] == "true" && cookies["allow_cookies#{version_name}"] == "custom")
  end

  def version_name
    Setting["cookies_consent.version_name"]
  end
end

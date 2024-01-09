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
    cookies["allow_cookies"] == "all" ||
      (cookies[vendor.cookie] == "true" && cookies["allow_cookies"] == "custom")
  end
end

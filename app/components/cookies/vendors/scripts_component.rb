class Cookies::Vendors::ScriptsComponent < ApplicationComponent
  attr_reader :vendors

  def initialize
    @vendors = ::Cookies::Vendor.all
  end
end

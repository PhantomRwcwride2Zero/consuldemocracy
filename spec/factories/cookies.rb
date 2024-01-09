FactoryBot.define do
  factory :cookies_vendor, class: "Cookies::Vendor" do
    sequence(:name) { |n| "Vendor name #{n}" }
    sequence(:cookie) { |n| "vendor_cookie_name_#{n}" }
    sequence(:description) { |n| "Vendor description #{n}" }
  end
end

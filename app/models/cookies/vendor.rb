class Cookies::Vendor < ApplicationRecord
  validates :name, presence: true
  validates :cookie, presence: true, uniqueness: true
end

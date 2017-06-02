class User < ApplicationRecord
  validates :email, {presence: true, uniqueness: true}
  validates :password, {presence: true}
  validates :confirmed, {inclusion: {in: [true, false] }}
  validates :visible, {inclusion: { in: [true, false] }}
  validates :role, {presence: true, inclusion: { in: ["User", "Artist", "Admin"] }}
  validates :access_level, {presence: true, inclusion: { in: ["Full", "Limited"] }}
  validates :first_name, {presence: true}
  validates :last_name, {presence: true}
end

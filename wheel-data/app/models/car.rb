class Car < ApplicationRecord
  belongs_to :manufacturer
  has_many :trims
end

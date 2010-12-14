class City < ActiveRecord::Base
  belongs_to :country
  has_and_belongs_to_many :ads

  validates_uniqueness_of :name
end

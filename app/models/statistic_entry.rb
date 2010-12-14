class StatisticEntry < ActiveRecord::Base
  belongs_to :ad
  belongs_to :platform

  attr_protected :views, :clicks, :expenses, :day, :month, :year
end

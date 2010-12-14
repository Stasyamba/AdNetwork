class Campaign < ActiveRecord::Base
  STATUS_STARTED, STATUS_STOPPED, STATUS_TMP_STOPPED = 0, 1, 2

  belongs_to :member
  has_many :ads

  validates_presence_of :name

  attr_accessor :ctr, :clicks, :views, :expenses

  attr_protected :balance

  def fresh_ads
    self.ads.sort {|a,b| b.created_at <=> a.created_at }
  end

  def calculate_statistics
      self.clicks = 0
      self.views = 0
      self.expenses = 0
      self.ads.each do |a|
        self.clicks = self.clicks + a.clicks
        self.views = self.views + a.views
        self.expenses = self.expenses + a.expenses
      end
      self.ctr = self.clicks / self.views if self.views != 0
  end
end

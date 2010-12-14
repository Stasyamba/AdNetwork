class Ad < ActiveRecord::Base
  STATUS_AWAITING, STATUS_AWAITING_STOPPED, STATUS_RUNNING, STATUS_STOPPED = 0, 1, 2, 3

  TYPE_BANNER, TYPE_TEXT_GRAPH = 0, 1

  AGE_MIN, AGE_MAX = 0, 999

  SEX_BOTH, SEX_MALE, SEX_FEMALE = 0, 1, 2

  ANY_CITY, ANY_PLATFORM = 0, 0

  validates_presence_of :image_url
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :link
  validates_numericality_of :click_cost

  validates_format_of :link, :with => 
/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix

  belongs_to :campaign
  has_many :statistic_entries
  has_and_belongs_to_many :cities
  has_and_belongs_to_many :platforms

  attr_protected :status, :clicks, :views, :expenses, :platforms, :cities, :campaign

  after_save :update_temp_table

  private

  def create_dynamic ad, city, platform
      d = AdDynamic.new
      d.ad_id = ad.id
      d.campaign_id = ad.campaign_id
      d.city_id = city
      d.platform_id = platform

      d.click_cost = ad.click_cost
      d.clicks = ad.clicks
      d.ctr = 0.0015
      d.description = ad.description
      d.link = ad.link
      d.image_url = ad.image_url
      d.name = ad.name
      d.max_age = ad.max_age
      d.min_age = ad.min_age
      d.sex = ad.sex
      d.ad_type = ad.ad_type
      d
  end

  def update_temp_table

    ActiveRecord::Base.transaction do

      AdDynamic.delete_all(["ad_id = ?", self.id])

      ad = self
      if ad.status == Ad::STATUS_RUNNING

        cities = ad.cities.to_a
        platforms = ad.platforms.to_a

        if (cities.empty? && platforms.empty?)
          dyn = create_dynamic ad, Ad::ANY_CITY, Ad::ANY_PLATFORM
          dyn.save
        end

        if (cities.empty? && !platforms.empty?)
          platforms.each do |p|
            dyn = create_dynamic ad, Ad::ANY_CITY, p.id
            dyn.save
          end
        end

        if (!cities.empty? && platforms.empty?)
          cities.each do |c|
            dyn = create_dynamic ad, c.id, Ad::ANY_PLATFORM
            dyn.save
          end
        end

        if (!cities.empty? && !platforms.empty?)
          cities.each { |c|
            platforms.each { |p|
              dyn = create_dynamic ad, c.id, p.id
              dyn.save
            }
          }
        end
      end

    end

  end
end

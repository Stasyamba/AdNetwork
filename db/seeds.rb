# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

russia = Country.create(:name => "Россия")
City.create([
    {:name => "Москва", :country => russia},
    {:name => "Санкт-Петербург", :country => russia},
    {:name => "Казань", :country => russia},
    {:name => "Нижний Новгород", :country => russia},
    {:name => "Новороссийск", :country => russia},
    {:name => "Екатеринбург", :country => russia},
    {:name => "Новосибирск", :country => russia}
])

ukraine = Country.create(:name => "Украина")
City.create([
    {:name => "Киев", :country => ukraine},
    {:name => "Харьков", :country => ukraine},
    {:name => "Одесса", :country => ukraine}
])

belarus = Country.create(:name => "Беларусь")
City.create([
    {:name => "Минск", :country => belarus},
    {:name => "Бобруйск", :country => belarus}
])



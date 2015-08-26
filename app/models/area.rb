class Area < ActiveRecord::Base
    has_many :orders
    has_many :people
end

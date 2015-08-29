class Person < ActiveRecord::Base
    #belongs_to :area
    validates :name, presence: true, uniqueness: { case_sensitive: false }
    validates :user_name, presence: true, length: { maximum: 50 }, uniqueness: {case_sensitive: false }
    validates :person_type, presence: true
    
    has_secure_password
    validates :password, presence: true, length: { minimum: 3 }
end

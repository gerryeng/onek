class Card < ActiveRecord::Base
  attr_accessible :description, :image_url, :name, :type

  has_and_belongs_to_many :effects
end

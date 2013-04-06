class Effect < ActiveRecord::Base
  attr_accessible :description, :effect_type, :value

  has_and_belongs_to_many :cards

end

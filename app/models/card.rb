class Card < ActiveRecord::Base
  attr_accessible :description, :image_url, :name, :card_type

  has_and_belongs_to_many :effects

  def self.create_effects
  	effects = [
	  	{
	  		effect_type: 'DISCARD',
	  		value: "{discard: 1}",
	  		description: 'Opponent discards 1 card from hand'
  		},
  		{
	  		effect_type: 'DESTROY',
	  		value: "{destroy: 1}",
	  		description: 'Opponent destroy 1 thing from hand'
  		},
  		{
	  		effect_type: 'REDUCE_ATTRIBUTE',
	  		value: "{}",
	  		description: 'Opponent discards 1 card from hand'
  		}
  	]
  	Effect.create effects
  end

  def self.create_sample_cards
  	cards = []
  	number_of_effects = Effect.count
  	40.times.each do 

  		card = create({
  			card_type: ["THING", "ACTION"].sample,
  			name: Faker::Name.name,
  			description: Faker::Lorem.sentence,
  			image_url: 'http://1.bp.blogspot.com/_IYGc_MWwkfw/TD-zxYV6vbI/AAAAAAAAA-c/I8qGqy6Oxjo/s1600/7_14_10_by_bernieg10_from_flickr_cc-nc-nd.jpg'
  		})

  		rand(1..3).times do
  			card.effects << Effect.first(offset: rand(number_of_effects))
  		end
	end
  end
end

class DiceSet
	attr_reader :values
  
	def roll(num_dice)
	  @values = Array.new(num_dice) { rand(1..6) }
	end
  end
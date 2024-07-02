# greed_score.rb
module GreedScore
	def self.score(dice)
	  counts = Hash.new(0)
	  dice.each { |value| counts[value] += 1 }
  
	  score = 0
  
	  counts.each do |num, count|
		if count >= 3
		  score += (num == 1 ? 1000 : num * 100)
		  count -= 3
		end
  
		score += count * (num == 1 ? 100 : num == 5 ? 50 : 0)
	  end
  
	  score
	end
  end
  
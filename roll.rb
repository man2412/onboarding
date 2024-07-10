class Roll
	attr_reader :no_of_dices, :outcome, :non_scoring_dices, :score

	def initialize(no_of_dices, options = {})
		@no_of_dices = no_of_dices
		@outcome = Array.new
		@score = 0
		simulate_roll(options)
		calc_score()
	end

	def all_scoring_dices?()
		non_scoring_dices.empty?
	end

	def to_s()
		"Rolled #{no_of_dices} dices. \n" +
		"Outcome is #{outcome.join(',')}. \n" +
		"Roll score is #{score}. \n" +
		"You have #{non_scoring_dices.count} non-scoring dices. \n"
	end

	private

	def simulate_roll(options)
		unless options[:override_outcome]
			no_of_dices.times do
				@outcome << throw_dice()
			end
		else
			@outcome = options[:override_outcome].clone
		end

		@non_scoring_dices = @outcome.clone
	end

	def throw_dice
		1 + rand(6) 
	end

	def calc_score()
		# check for triplets of 1,2,3,4,5,6
		[1,6,5,4,3,2].each do |number|
			if arr_has_three_of_a_kind?(@outcome, number)
				temp_score = (number == 1) ? 1000 : (number*100)
				@score += temp_score
				3.times { @non_scoring_dices.delete_at(@non_scoring_dices.index(number))}
				break
			end
		end

		#check for 1s and 5s
		update_score_for(@non_scoring_dices, 1, 100)
		update_score_for(@non_scoring_dices, 5, 50)
	end

	def arr_has_three_of_a_kind?(arr, number)
		arr.find_all{|i| i == number}.count >= 3
	end

	def update_score_for(arr, number, points)
		number_count = arr.find_all{|i| i == number}.count

		if (number_count > 0)
			@score += (number_count * points)
			number_count.times { arr.delete_at(arr.index(number)) }
		end		
	end

end


class Turn
	attr_accessor :player, :score, :no_of_dices, :end_of_turn

	def initialize(player)
		@player = player
		@score = 0
		@no_of_dices = 5
	end

	def start()
		roll()
	end

	private

	def roll()
		roll = Roll.new(@no_of_dices)
		puts roll.to_s + "\n"
		
		if (roll.score() == 0)
			@score = 0
			end_turn()
		else
			@score += roll.score()
			@no_of_dices = roll.all_scoring_dices?() ? 5 : roll.non_scoring_dices().count
			prompt_user()
		end
	end

	def prompt_user
	 	puts "Player #{@player.id} : Type 'roll' to roll again (with #{@no_of_dices} dices) or 'end' to end your turn"
	 	user_input = gets().chomp()

	 	if user_input == "roll"
	 		roll()
	 	elsif user_input == "end"
	 		end_turn()
	 	else
	 		puts "Invalid input. Try again."
	 		prompt_user()
	 	end
	end

	def end_turn()
		@player.in_the_game = true if (!@player.in_the_game and @score >= 300)
		@player.score += @score if @player.in_the_game		
		@end_of_turn = true
	end

end


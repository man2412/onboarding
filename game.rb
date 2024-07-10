require_relative 'player'
require_relative 'roll'
require_relative 'turn'

class Game
	attr_accessor :players

	def initialize(no_of_players)
		@players = []
		@final_round = false

		no_of_players.times do |i|
			@players << Player.new(i)
		end
	end

	def start()

		puts "Starting game.\n\n"

		while(!@final_round)
			@players.each do |player|
				play_turn(player)

				if player.score >= 3000
					@final_round = true 
					break
				end
			end
		end

		#final round
		puts "Going into the final round\n\n"
		@players.each do |player|
			play_turn(player)
		end

		#final scores
		print_final_scores()
		puts "Game ended."
	end

	private

	def play_turn(player)
		puts "***********START TURN****************"
		puts "#{player.to_s}\n"

		turn = Turn.new(player)
		turn.start()

		puts "Turn score is #{turn.score}\n"
		puts "#{player.to_s}\n"
		puts "***********END TURN****************\n\n"

		puts "Press enter key to continue\n"
		gets()			
	end

	def print_final_scores
		@players.each do |player|
			puts "Player #{player.id} final score is #{player.score}"
		end
	end

end

puts "Enter number of players for the new game:"
no_of_players = gets().chomp().to_i
Game.new(no_of_players).start()


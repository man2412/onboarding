require_relative 'player'

class Game
  FINAL_SCORE = 3000

  def initialize(player_names)
    @players = player_names.map { |name| Player.new(name) }
    @final_round = false
    @final_round_players = []
  end

  def play
    until @final_round
      @players.each do |player|
        break if @final_round

        puts "#{player.name}'s turn"
        turn_score = player.take_turn

        if turn_score > 0
          player.score += turn_score
          puts "#{player.name} scored #{turn_score} points this turn. Total score: #{player.score}"
        else
          puts "#{player.name} scored 0 points and lost their turn."
        end

        if player.score >= FINAL_SCORE
          @final_round = true
          @final_round_players = @players.reject { |p| p == player }
          @final_round_players << player
          puts "#{player.name} has reached #{FINAL_SCORE} points! Final round begins!"
          break
        end
      end
    end

    final_turns
    declare_winner
  end

  def final_turns
    @final_round_players.each do |player|
      puts "#{player.name}'s final turn"
      turn_score = player.take_turn

      if turn_score > 0
        player.score += turn_score
        puts "#{player.name} scored #{turn_score} points this turn. Total score: #{player.score}"
      else
        puts "#{player.name} scored 0 points and lost their turn."
      end
    end
  end

  def declare_winner
    winner = @players.max_by(&:score)
    puts "The winner is #{winner.name} with #{winner.score} points!"
  end
end

if __FILE__ == $0
  puts "Welcome to the Greed game!"
  print "Enter player names separated by commas: "
  player_names = gets.chomp.split(',').map(&:strip)
  game = Game.new(player_names)
  game.play
end
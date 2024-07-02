require_relative 'dice_set'
require_relative 'greed_score'

class Player
  attr_accessor :score, :in_game
  attr_reader :name

  def initialize(name)
    @name = name
    @score = 0
    @in_game = false
  end

  def take_turn
    turn_score = 0
    dice_set = DiceSet.new
    dice_to_roll = 5

    loop do
      dice_set.roll(dice_to_roll)
      roll_score = GreedScore.score(dice_set.values)

      if roll_score == 0
        puts "#{name} rolled #{dice_set.values} and scored 0 points. Turn over."
        return 0
      else
        turn_score += roll_score

        if turn_score >= 300 || @in_game
          @in_game = true
        else
          return 0
        end

        scoring_dice, non_scoring_dice = calculate_scoring_non_scoring(dice_set.values)

        if non_scoring_dice.empty?
          dice_to_roll = 5
        else
          dice_to_roll = non_scoring_dice.size
        end

        puts "#{name}, you rolled: #{dice_set.values} and scored #{roll_score} points this roll."
        puts "Total points this turn: #{turn_score}."

      
        if @score + turn_score >= Game::FINAL_SCORE
          puts "#{name} has exceeded the final score threshold with a total score of #{@score + turn_score}."
          return turn_score
        end

        print "Do you want to roll again? (y/n): "
        answer = gets.chomp.downcase
        break if answer != 'y'
      end
    end

    turn_score
  end

  private

  def calculate_scoring_non_scoring(dice)
    counts = Hash.new(0)
    dice.each { |value| counts[value] += 1 }

    scoring_dice = []
    non_scoring_dice = []

    counts.each do |num, count|
      if count >= 3
        scoring_dice.concat([num] * 3)
        count -= 3
      end
      count.times do
        if num == 1 || num == 5
          scoring_dice << num
        else
          non_scoring_dice << num
        end
      end
    end

    [scoring_dice, non_scoring_dice]
  end
end
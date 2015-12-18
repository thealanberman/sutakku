#!/usr/bin/ruby

def new_game()
  $current_roll = []
  $player_list = []
  $dice_pool = 12
  $score = [0]
  $tower = []
end

def play_game()
  roll_again = 1
  game_over = 0
  next_player = 0
  current_player = 0
  bonus = 0

  until game_over == 1
    until next_player == 1
      until roll_again == "n"
        print "Your turn, #{$player_list[current_player]}\n"

        unless $tower.empty?
          print "Your tower is #{$tower}.\n"
        end
        print "dice_pool = #{$dice_pool}.\n"

        if $dice_pool >= 3
          $current_roll = roll(3)
        elsif $dice_pool < 3
          $current_roll = roll($dice_pool)
        else
          print "No dice left to roll!\n"
        end

        print "You rolled #{$current_roll}.\n"
        $current_roll = get_valid_dice($current_roll)
        print "valid dice = #{$current_roll}\n"

        if $current_roll.empty?
          print "Can't stack those!\n"
        else
          print "You can play #{$current_roll}.\n"
          $tower = $tower + $current_roll
          print "Your tower is #{$tower}.\n"
          $dice_pool = $dice_pool - $current_roll.length
        end

        print "Roll again? (Y/n) "
        roll_again = gets.strip.downcase
      end # roll_again
      next_player = 1
    end # next_player

    # tally base score
    puts "current_player = #{current_player}"
    $score[current_player] = $score[current_player] + ($tower.length * $tower.max)

    # tally bonus score
    if $tower.count(5) >= 2
      bonus = $tower.count(5) * 50
    end
    if $tower.count(6) >= 2
      bonus = bonus + ($tower.count(6) * 100)
    end
    $score[current_player] += bonus
    print "#{$player_list[current_player]}'s score is #{$score[current_player]}.\n"

    # reset values for next player
    next_player = 0
    roll_again = 1
    bonus = 0
    $tower = []
    if current_player == ($player_list.length - 1)
      current_player = 0
    else
      current_player += 1
    end

  end # game_over
end # play_game

def get_player_names()
  print "Player One's Name: "
  $player_list << gets.strip
  print "Player Two's Name: "
  $player_list << gets.strip
  return $player_list
end

def roll(dice)
  results = []
  for i in 1..dice do
    results << rand(6) + 1
  end
  return results.sort
end

def get_valid_dice(current_roll)
  if $tower.empty?
    return current_roll
  elsif current_roll[-1] < $tower[-1]
    return []
  elsif current_roll[0] >= $tower[-1]
    return current_roll
  elsif current_roll[1] >= $tower[-1]
    return current_roll[1..-1]
  else
    return []
  end
end

new_game()
get_player_names()
play_game()

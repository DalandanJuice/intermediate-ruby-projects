# frozen_string_literal:true

# Peg is the object that contains the color # frozen_string_literal:true
class Peg
  attr_accessor :color
  def initialize(color)
    @color = color
  end

  def to_s
    color.to_s
  end
end
# Corrector checks if player's moves if it's correct or not
module Corrector
  def self.Colors_in_pattern?(pattern)
    color = %w[blue green red yellow violet]
    color_in_pattern_count = 0
    pattern.each do |peg|
      color_in_pattern_count += 1 if color.include?(peg.color)
    end
    if color_in_pattern_count == 4
      return true
    else
      return false
    end
  end

  def self.turn_x_into_blank(feedback)
    new_feedback = []
    feedback.each_with_index do |peg, index|
      if peg.downcase == 'x'
        new_feedback[index] = ''
      else
        new_feedback[index] = peg
      end
    end
    new_feedback
  end

  def self.colors_include?(code_pegs)
    colors = %w[blue red yellow green violet]
    included_count = 0
    code_pegs.each do |peg|
      included_count += 1 if colors.include?(peg.color)
    end
    return true if included_count == 4
  end

  def self.feedback_correct?(pattern, feedback, computer)
    feedback_checker = Computer.new
    feedback_checker.pattern = pattern
    feedback_checker.give_feedback(computer)
    puts feedback_checker.feedback.to_s
    new_feedback = Corrector.turn_x_into_blank(feedback)
    puts 'Tada!' if feedback_checker.feedback == new_feedback
    return true if feedback_checker.feedback == new_feedback
  end
end
# Player class is the class that you will be controlling.
class Player
  attr_accessor :pattern, :feedback, :code_pegs

  def initialize
    @pattern = []
    @feedback = []
    @code_pegs = []
  end

  def guess_code(computer)
    guess = ''
    puts 'Choices: blue, red, yellow, green, violet'
    while guess.length != 4
      puts 'Please input 4 pegs and separate it with spaces'
      guess = gets.chomp.split(' ')
      code_pegs.clear
      computer.feedback.clear
    end
    push_colors(guess)
  end

  def make_pattern
    puts 'Input 4 colors and separate it with space.'
    puts 'This will be the pattern the computer will guess'
    colors = gets.chomp.split(' ')
    colors.each do |color|
      pattern.push(Peg.new(color))
    end
    pattern
  end

  def give_feedback(computer)
    puts 'Give your feedback and separate it with comma.'
    puts 'Put X if blank'
    puts 'Choices are B and W'
    puts 'Put it all in exact position'
    my_feedback = Corrector.turn_x_into_blank(gets.chomp.split(','))
    if Corrector.feedback_correct?(pattern, my_feedback, computer)
      @feedback = my_feedback
      return true
    else
      puts "Repeat"
      give_feedback(computer)
    end
  end

  private

  def push_colors(pegs)
    pegs.each do |color|
      code_pegs.push(Peg.new(color.downcase))
    end
  end
end
# Computer class is a computer that fights with the player
class Computer
  attr_accessor :pattern, :feedback, :code_pegs, :code_breaker_pegs

  def initialize
    @pattern = []
    @code_pegs = []
    @feedback = []
    @code_breaker_pegs = []
  end

  def make_random_pattern
    4.times do
      pattern.push(random_peg)
    end
  end

  def give_feedback(player)
    correct_position_feedback(player)
    wrong_position_feedback(player)
    not_present_feedback(player)
    code_breaker_pegs.clear
  end
  def reset_feedback
    feedback[0] = 'X'
    feedback[1] = 'X'
    feedback[2] = 'X'
    feedback[3] = 'X'
  end

  def guess_code(player)
    4.times do |index|
      peg = random_peg
      if code_pegs.length == 4
        if  player.feedback[index] == 'B' 
          puts "Correct Position in index: #{index}"
          next
        elsif player.feedback[index] == 'W'
          puts "Wrong Position  in index: #{index}"
          occupy_position(player, index)
        elsif player.feedback[index] == ""
          puts "Peg Doesnt exist in index: #{index}"
          code_pegs[index] = random_peg
          player.feedback[index] == nil
        end
      else
        code_pegs[index] = random_peg
      end

    end
  end

  def color_in_correct_position?(player,index)
    if code_pegs[index].color == player.pattern[index].color
      return true
    else
      return false
    end
    end

  def occupy_position(player, computer_index)
    index = 0
    code_pegs.each_with_index do |code_peg,index|
      if player.feedback[index] == 'W' && computer_index < index
        puts 'Switch!'
        switch_value = code_pegs[computer_index]
        code_pegs[computer_index] = code_pegs[index]
        code_pegs[index] = switch_value
        break
      elsif player.feedback[index] == ""
        puts "Blank!"
        switch_value = code_pegs[computer_index]
        code_pegs[computer_index] = random_peg
        code_pegs[index] = switch_value
        player.feedback[index] = nil
        player.feedback[computer_index] = ""
        puts "#{switch_value.color} is now in #{index}"
        break
      end
    end
  end
#adjust peg based on feedback
  def adjust_peg(player)

  end

  def correct_position_feedback(player)
    player_pegs = player.code_pegs
    player_pegs.each_with_index do |peg, index|
      next if correct_position?(index, peg) == false
      code_breaker_pegs.push(peg)
      feedback[index] = 'B'
    end
  end

  def wrong_position_feedback(player)
    player_pegs = player.code_pegs
    player_pegs.each_with_index do |peg, index|
      next unless correct_position?(index, peg) == false

      if wrong_position?(index, player_pegs)
        code_breaker_pegs.push(peg)
        feedback[index] = 'W'
      else
        feedback[index] = ''
      end
    end
  end
  def not_present_feedback(player)
    player_pegs = player.code_pegs
    player_pegs.each_with_index do |peg, index|
      if present?(peg) == false
        puts 'Not Present Blank!'
        code_breaker_pegs.push(peg)
        feedback[index] = ''
      end
    end
  end

  def colors(pegs)
    colors = []
    pegs.each do |peg|
      colors.push(peg.color)
    end
    colors
  end

  def correct_position?(index, code_peg)
    code_peg.color == pattern[index].color
  end

  def present?(peg)
    pattern_colors = colors(pattern)
    return true if pattern_colors.include?(peg.color)
  end

  def wrong_position?(index, pegs)
    code_colors = colors(pegs)
    pattern_color = colors(pattern)
    return unless pattern_color.include?(code_colors[index])
    return true if color_is_less_than?(pegs[index].color)
  end

  def color_is_less_than?(color)
    pattern_color_count = color_count(pattern, color)
    code_peg_color_count = color_count(code_breaker_pegs, color)
    code_peg_color_count < pattern_color_count
  end

  def color_count(pegs, color)
    color_count = 0
    pegs.each do |peg|
      color_count += 1 if peg.color == color
    end
    color_count
  end

  def random_peg
    colors = %w[red blue yellow green violet]
    index = Random.rand(5)
    Peg.new(colors[index])
  end
end
# Decoding Board class is the visual for the game
class DecodingBoard
  attr_accessor :code_maker, :code_breaker

  def initialize(code_maker, code_breaker)
    @code_maker = code_maker
    @code_breaker = code_breaker
  end

  def draw(attempt)
    puts "Attempt: #{attempt + 1}"
    draw_code
    draw_feedback
  end

  private

  def draw_code
    code_pegs = code_breaker.code_pegs
    code_pegs.each do |code|
      print("| #{code} ")
    end
    print(' |')
  end

  def draw_feedback
    feedback = code_maker.feedback
    print(feedback.to_s)
  end

  def remove_blanks(array)
    new_array = []
    array.each do |a|
      new_array.push(a) if a != ''
    end
    new_array
  end
end
# Text For the Game
class Mastermind
  attr_accessor :player, :computer, :decoding_board
  def initialize
    @player = Player.new
    @computer = Computer.new
    @decoding_board = ''
  end

  def start
    answer = ''
    while answer.downcase != 'codemaker' || answer.downcase != 'codebreaker'
      puts 'Do you want to be the code maker or the code_breaker?'
      puts 'codemaker or codebreaker?r'
      answer = gets.chomp
      if answer.downcase == 'codemaker'
        self.decoding_board = DecodingBoard.new(player, computer)
        play_as_code_maker
        break
      elsif answer.downcase == 'codebreaker'
        self.decoding_board = DecodingBoard.new(computer, player)
        play_as_code_breaker
        break
      end
    end
    puts 'Do you want to play a game again?(yes or no)'
    answer = gets.chomp
    start if answer.downcase == 'yes'
  end

  private

  def play_as_code_maker
    puts 'The game has started'
    show_code_maker_instructions
    player.make_pattern
    12.times do |attempt|
      computer_guess_answer
      decoding_board.draw(attempt)
      break if correct_pegs(player.feedback) == 4
    end
    clear_all(player,computer)
  end

  def play_as_code_breaker
    show_code_breaker_introduction
    computer.make_random_pattern
    12.times do |attempt|
      player_guess_answer
      decoding_board.draw(attempt)
      break if correct_pegs(computer.feedback) == 4
      return true if game_over?(attempt)
    end
    show_answer(computer)
  end

  def game_over?(attempt)
    return unless attempt == 11 && correct_pegs(computer.feedback) != 4

    answer = get_colors(computer.pattern).join(', ')
    puts ''
    puts 'Game over!'
    puts "The answer is #{answer}"
    true
  end

  def player_guess_answer
    player.guess_code(computer)
    return false if player.code_pegs[0].color.downcase == 'exit'

    computer.give_feedback(player)
  end

  def computer_guess_answer
    computer.guess_code(player)
    puts computer.code_pegs
    player.give_feedback(computer)
  end

  def show_code_maker_instructions
    puts 'You will play as the code maker and the computer as code breaker'

    puts 'If you\re giving feedback'
    puts 'Separate your Feedback with space.'
    puts 'Choices are B and W'
    puts 'B means Black, if the peg is the correct color and the same position'
    puts 'W maean White, if the peg is the correct color but wrong in position'
    puts 'X mean Blank,  if the peg does\'t exist in the pattern'
  end

  def show_code_breaker_introduction
    puts 'The game has started'
    puts 'You will play as the code breaker and the computer as code maker'
    puts 'Input 4 colors and separate it with spaces'
    puts 'type "exit" if you want to stop the game'
  end

  def correct_pegs(feedback)
    correct_count = 0
    feedback.each do |peg|
      correct_count += 1 if peg == 'B'
    end
    correct_count
  end

  def show_answer(user)
    puts 'You did it! You guessed the right pegs'
    answer = get_colors(user.pattern).join(', ')
    puts "The answer is #{answer}"
  end

  def get_colors(pegs)
    colors = []
    pegs.each do |peg|
      colors.push(peg.color)
    end
    colors
  end

  def clear_all(code_maker,code_breaker)
    puts "Cleared"
    code_maker.pattern.clear
    code_maker.feedback.clear
    code_breaker.code_pegs.clear
  end

end
mastermind = Mastermind.new
mastermind.start

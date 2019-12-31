class Peg
  attr_accessor :color
  def initialize(color)
    @color = color
  end

  def to_s
    color.to_s
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

  def guess_code
    puts 'Input your code and separate it with spaces'
    guess = gets.chomp.split(' ')
    guess.each do |color|
      code_pegs.push(Peg.new(color.downcase))
    end
  end

  def give_feedback(computer)
    puts 'Give your feedback and separate it with spaces.'
    puts 'Choices are B and W'
    self.feedback = gets.chomp.split(' ')
    return true if feedback_correct?

    give_feedback(computer)
  end

  private

  def feedback_correct?
    feedback_checker = Computer.new
    feedback_checker.give_feedback(computer.code_pegs)
    return true if feedback_Checker.feedback == feedback
  end
end
# Computer class is a computer that fights with the player
class Computer
  attr_accessor :pattern, :feedback, :code_pegs

  def initialize
    @pattern = []
    @feedback = []
    @code_pegs = []
  end

  def make_random_pattern
    4.times do
      pattern.push(random_peg)
    end
  end

  def give_feedback(code_pegs)
    code_pegs.each_with_index do |peg, index|
      if present?(code_pegs, index)
        push_feedback(index, peg)
      else
        feedback.push(' ')
      end
    end
  end

  def guess_code
    4.times do
      code_pegs.push(random_peg)
    end
  end

  private

  def push_feedback(index, peg)
    if correct_in_position?(index, peg)
      feedback.push('B')
    elsif wrong_position?(index)
      feedback.push('W')
    end
  end

  def present?(code_pegs, index)
    code_colors = colors(code_pegs)
    return true if code_colors.include?(pattern[index].color)
  end

  def colors(pegs)
    colors = []
    pegs.each do |peg|
      colors.push(peg.color)
    end
    colors
  end

  def correct_in_position?(index, code_peg)
    return true if code_peg.color == pattern[index].color
  end

  def wrong_position?(index)
    code_colors = colors(code_pegs)
    pattern_color = colors(pattern)
    return true if pattern_color[index] == code_colors[index]
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

  def draw
    draw_code
    draw_feedback
  end

  private

  def draw_code
    code_pegs = code_breaker.code_pegs
    code_pegs.each do |code|
      print("| #{code} |")
    end
  end

  def draw_feedback
    feedback = remove_blanks(code_maker.feedback)
    print(' (')
    feedback = feedback.join(',')
    print(feedback)
    print ')'
  end

  def remove_blanks(array)
    new_array = []
    array.each do |a|
      new_array.push(a) if a != ' '
    new_array
  end
  end
end
class Mastermind
  attr_accessor :player, :computer, :decoding_board
  def initialize
    @player = Player.new
    @computer = Computer.new
    @decoding_board = ''
  end
  def start
    answer = ''
    while answer.downcase != 'codemaker' or answer.downcase != 'codebreaker'
      puts 'Do you want to be the code maker or the code_breaker?'
      puts 'Input codemaker if you want to be the codemaker and input codebreaker if you want to be the code breaker'
      answer = gets.chomp
      if answer.downcase == 'codemaker'
        play_as_code_maker
        break
      elsif answer.downcase == 'codebreaker'
        play_as_code_breaker
        break
      end
    end
    puts 'Do you want to play a game again?(yes or no)'
    answer = gets.chomp
    if answer.downcase == 'yes'
      start()
    end
  end
  pnrivate
  def play_as_code_maker
    decoding_board = DecodingBoard.new(computer,player)
    puts 'The game has started'
    puts 'You will play as the code maker and the computer as code breaker'
    puts 'Input 4 colors and separate it with space. This will be the pattern that the computer will guess'
    pattern = gets.chomp
    player.pattern = pattern
    puts 'If you\re giving feedback'
    puts 'Separate your Feedback with space.'
    puts 'Choices are B and W'
    puts 'B means Black, if the peg is the correct color and the same position'
    puts 'W maean White, if the peg is the correct color but wrong in position'
    puts 'Don"t put a peg if the color doesn\'t exist in the pattern'

    12.times do |attempt|
      puts 'Choices: blue, red, yellow, green, violet'
      computer.guess_code
      puts computer.code_pegs
      player.give_feedback
      puts "Attempt: #{attempt + 1}"
      decoding_board.draw
      break if correct_pegs(computer.feedback) == 4
      player.code_pegs.clear
      computer.feedback.clear
    end

  end
  def play_as_code_breaker
    decoding_board = DecodingBoard.new(computer,player)
    puts 'The game has started'
    puts 'You will play as the code breaker and the computer as code maker'
    puts 'Input 4 colors and separate it with spaces'
    puts 'type "exit" if you want to stop the game'
    @computer.make_random_pattern
    puts "Answer: #{computer.pattern}"
    12.times do |attempt|
      puts 'Choices: blue, red, yellow, green, violet'
      player.guess_code
      if player.code_pegs[0].color == 'exit'
        puts 'Exiting'
        return false
      elsif player.code_pegs.length != 4
        puts 'Please input 4 pegs and separate it with spaces'
        player.code_pegs.clear
        computer.feedback.clear
        redo
      end
      computer.give_feedback(player.code_pegs)
      puts "Attempt: #{attempt + 1}"
      decoding_board.draw
      break if correct_pegs(computer.feedback) == 4

      player.code_pegs.clear
      computer.feedback.clear
    end
    puts ''
    puts 'You did it! You guessed the right pegs'
    answer = get_colors(computer.pattern).join(', ')
    puts "The answer is #{answer}"
  end

  def correct_pegs(feedback)
    correct_count = 0
    feedback.each do |peg|
      correct_count += 1 if peg == 'B'
    end
    correct_count
  end

  def get_colors(pegs)
    colors = []
    pegs.each do |peg|
      colors.push(peg.color)
    end
    colors
  end
end
mastermind = Mastermind.new
mastermind.start

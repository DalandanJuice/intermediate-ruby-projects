#Peg is the object that will be used for 
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

  def give_feedback(computer)
    feedback_checker = Computer.new
    feedback_checker.give_feedback(computer)
    puts "Feedback: #{feedback_checker.feedback}"
    puts 'Give your feedback and separate it with comma.'
    puts 'Put X if blank'
    puts 'Choices are B and W'
    puts 'Put it all in exact position'
    self.feedback = gets.chomp.split(',')
    return true if feedback_correct?(computer)

    give_feedback(computer)
  end

  private

  def push_colors(pegs)
    pegs.each do |color|
      code_pegs.push(Peg.new(color.downcase))
    end
  end

  def turn_x_into_blank(feedbacks)
    new_feedback = []
    feedbacks.each do |feedback|
      if feedback.downcase == 'x'
        new_feedback.push("")
      else
        new_feedback.push(feedback)
      end

    end
    new_feedback
  end

  def feedback_correct?(computer)
    feedback_checker = Computer.new
    feedback_checker.give_feedback(computer)
    new_feedback = turn_x_into_blank(feedback)
    puts 'Tada!' if feedback_checker.feedback == new_feedback
    return true if feedback_checker.feedback == new_feedback
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

  def give_feedback(player)
    code_pegs = player.code_pegs
    code_pegs.each_with_index do |peg, index|
      if present?(peg)
        push_feedback(index, code_pegs)
      else
        feedback.push('')
      end
    end
  end

  def guess_code
    4.times do
      code_pegs.push(random_peg)
    end
  end

  def push_feedback(index, code_pegs)
    if correct_position?(index, code_pegs[index])
      puts 'pushing Black!'
      feedback.push('B')
    elsif wrong_position?(index, code_pegs)
      puts 'pushing White!'
      feedback.push('W')
    end
  end

  def present?(peg)
    pattern_colors = colors(pattern)
    return true if pattern_colors.include?(peg.color)
  end

  def colors(pegs)
    colors = []
    pegs.each do |peg|
      colors.push(peg.color)
    end
    colors
  end

  def correct_position?(index, code_peg)
    return true if code_peg.color == pattern[index].color
  end

  def wrong_position?(index, code_pegss)
    code_colors = colors(code_pegss)
    pattern_color = colors(@pattern)
    return true if code_colors.include?(pattern_color[index])
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
    feedback = remove_blanks(code_maker.feedback)
    print(' (')
    feedback = feedback.join(',')
    print(feedback)
    print ')'
  end

  def remove_blanks(array)
    new_array = []
    array.each do |a|
      new_array.push(a) if a != ''
    end
    new_array
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
    while answer.downcase != 'codemaker' || answer.downcase != 'codebreaker'
      puts 'Do you want to be the code maker or the code_breaker?'
      puts 'codemaker or codebreaker?r'
      answer = gets.chomp
      if answer.downcase == 'codemaker'
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
    decoding_board = DecodingBoard.new(computer, player)
    puts 'The game has started'
    puts 'You will play as the code maker and the computer as code breaker'
    puts 'Input 4 colors and separate it with space.'
    puts 'This will be the pattern the computer will guess'
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
      player.give_feedback(computer)
      decoding_board.draw(attempt)
      break if correct_pegs(computer.feedback) == 4

      player.code_pegs.clear
      computer.feedback.clear
    end
  end

  def play_as_code_breaker
    show_code_breaker_introduction
    computer.make_random_pattern
    12.times do |attempt|
      guess_answer
      decoding_board.draw(attempt)
      break if correct_pegs(computer.feedback) == 4
      return true if game_over?(attempt)

      clear_all
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

  def guess_answer
    player.guess_code(computer)
    return false if player.code_pegs[0].color == 'exit'

    computer.give_feedback(player)
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

  def clear_all
    player.code_pegs.clear
    computer.feedback.clear
  end
end
mastermind = Mastermind.new
mastermind.start

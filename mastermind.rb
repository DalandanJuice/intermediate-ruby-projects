module CodeMaker

  def give_feedback(pattern,code_breaker)
    feedback = []
    code_pegs = code_brekaer.code_pegs
    code_pegs.each_with_index do |_code, index|
      if pattern.include?(code_pegs[index]) == false
      elsif is_correct?(pattern, index, code_breaker)
        feedback.push('B')
      elsif is_wrong_position?(pattern, index, code_breaker)
        feedback.push('W')
      end
    end

  end

  def make_pattern
    pattern = []
    5.times do
      random_peg = get_random_pegs
      pattern.push[random_peg]
    end
    pattern
  end

  def get_random_pegs
    colors = ['yellow','brown','violet','green','blue']
    index = Random.rand(4)
    return(colors[index])
  end
  private

  def is_correct?(pattern, index, code_breaker) #Correct in both color and position
    code_pegs = code_breaker.code_pegs
    if code_pegs[index].downcase == pattern[index]
      return true
    else
      return false
    end
  end

  def is_wrong_position?(pattern, index, code_breaker)
    code_pegs = code_breaker.code_pegs
    if is_correct?(pattern, index, code_breaker) == false
      if code_pegs.include?(pattern[index])
        return true
      else
        return false
      end
    end

  end
end

module CodeBreaker
  def guess_code(pegs, code_pegs)
    pegs = pegs.split(' ')
    pegs.each do |peg| 
      code_pegs.push(peg)
    end
  end
end
class Player
  include CodeBreaker
  include CodeMaker
  attr_accessor :pattern, :feedback, :code_pegs
  def initialize
    @pattern = []
    @feedback = []
    @code_pegs = []
  end

end
class Computer
  include CodeBreaker
  include CodeMaker
  attr_accessor :pattern, :feedback, :code_pegs
  def initialize
    @pattern = []
    @feedback = []
    @code_pegs = []
  end

end


class DecodingBoard
  attr_accessor :code_maker, :code_breaker

  def initialize(code_maker,code_breaker)
    @code_maker = code_maker
    @code_breaker = code_breaker
  end

  def draw
    draw_code
    draw_feedback
  end

  private

  def draw_code
    code_pegs = self.code_breaker.code_pegs
    code_pegs.each do |code|
      print("| #{code} ")
    end
  end

  def draw_feedback
    feedback = self.code_maker.feedback
    print(' (')
    feedback = feedback.join(',')
    print(feedback)
    print ')'
  end
end


class MasterMind
  attr_accessor :code_breaker, :code_maker, :decoding_board
  def initialize
    @code_breaker = CodeBreaker.new
    @code_maker = CodeMaker.new()
    @computer = Computer.new()
    @decoding_board = DecodingBoard.new(code_maker, code_breaker)
    self.code_maker.make_pattern
  end
  def start
    while true
      puts 'Type "cm" if you want to be a code breake else type "cb" if you want to be the code breaker'
      puts 'Type "exit" if you want to quit'
      answer = gets.chomp
      if answer == 'cm'
        play_as_code_maker
      elsif answer =='cb'
        play_as_code_breaker
        break
      elsif answer.downcase == 'exit'
        break
      end
    end


  end
  private
  def play_as_code_maker
    command = ''
    puts ' Make a pattern that consists of 4 pegs and separate it with space'
    puts 'Choices: blue green yellow brown violet'
    pattern = gets.chomp.split(' ')
    @code_maker.pattern = pattern
    12.times do |attempt|
      @decoding_board.draw
      command = computer.guess_code
      puts "attempt: #{attempt}"
      @decoding_board.draw
    end
  end
  def play_as_code_breaker
    command= ""
    12.times do |attempt|
      puts  @code_maker.pattern
      @decoding_board.draw
      command = code_breaker.guess_code
      @code_maker.give_feedback(@code_breaker)
      if is_correct?
        puts is_correct?
        break
      end
      if command.include?('exit')
        break
      elsif
        self.code_breaker.code_pegs.length != 4
        clear_all
        puts 'You can only input 4 pegs'
        redo
      end
      puts "Attempt: #{attempt + 1}/12"
      decoding_board.draw
      clear_all
   
    end
  end

  private

  def clear_all
    @code_maker.feedback.clear
    @code_breaker.code_pegs.clear
  end
  def is_correct?
    correct_count = 0
    self.code_maker.feedback.each do |x|
      if x == 'B'
        correct_count += 1
      end

    end
    return(correct_count == 4)
  end

end
mastermind = MasterMind.new
mastermind.start

class CodeMaker
  attr_accessor :pattern, :code_breaker, :feedback
  def initialize(code_breaker)
    @pattern = []
    @feedback = []
    @code_breaker = code_breaker
  end

  def give_feedback
    code_pegs = self.code_breaker.code_pegs
    code_pegs.each_with_index do |_code, index|
      if is_correct?(index)
          self.feedback.push('B')
      elsif is_wrong_position?(index)
          self.feedback.push('W')

      end
    end
   self.feedback = feedback.shuffle
  end
  def make_pattern
    4.times do
      random_peg = get_random_pegs()
      self.pattern.push(random_peg)
    end
    self.pattern
  end
  def get_random_pegs
    colors = ['blue', 'green', 'yellow', 'violet','brown']
    random_index = rand(5)
    return colors[random_index]
  end
  private

  def is_correct?(index) #Correct in both color and position
    if code_breaker.code_pegs[index].downcase == self.pattern[index]
      return true
    else
      return false
    end
  end

  def is_wrong_position?(index) #Correct in color but wrong in position
    pattern = self.pattern
    code_pegs = self.code_breaker.code_pegs
    if is_correct?(index) == false
      if pattern[index] == code_pegs[index]
        return true
      end
    end
    return false
  end

  def is_present?(index)
    code_pegs = self.code_breaker.code_pegs
    if pattern.include?(code_pegs[index].downcase)
      return true
    else
      return false
    end
  end

end

class CodeBreaker
  attr_accessor :code_pegs
  def initialize
    @code_pegs = []
  end

  def guess_code
    puts 'Give 4 color sand separate it with space.(Example: blue green yellow brown)'
    codes = gets.chomp.split(' ')
    codes.each do |color| 
      @code_pegs.push(color)
    end
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
      print("| #{code} |")
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
class Computer < code_breaker
  attr_accesso :code_maker
  def initialize(code_maker)
   @code_maker = code_maker
  end
  def give_random_pegs
    colors = ['yellow','brown','violet','green','blue']
    
  end
end
class MasterMind
  attr_accessor :code_breaker, :code_maker, :decoding_board
  def initialize
    @code_breaker = CodeBreaker.new
    @code_maker = CodeMaker.new(code_breaker)
    @computer = Computer.new(code_maker)
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
    puts ' Make a pattern that consists of 4 pegsand separate it with space'
    puts 'Choices: blue green yellow brown violet'
    pattern = gets.chomp.split(' ')
    @code_maker.pattern = pattern

    12.times do |attempt|
      @decoding_board.draw
      command = code_breaker.guess_code
    end
  end
  def play_as_code_breaker
    command= ""
    12.times do |attempt| 
      @decoding_board.draw
      command = code_breaker.guess_code
      code_maker.give_feedback
      if is_correct?
        puts is_correct?
        break
      end
      if command.include?('exit')
        break
      elsif
        self.code_breaker.code_pegs.length != 4
        self.code_maker.feedback.clear
        self.code_breaker.code_pegs.clear
        puts 'You can only input 4 pegs'
        redo
      end
      puts "Attempt: #{attempt + 1}/12"
      decoding_board.draw
      @code_maker.feedback.clear
      @code_breaker.code_pegs.clear
    end
  end
  private
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

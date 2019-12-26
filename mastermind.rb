class Peg
  attr_accessor :color
  def initialize(color)
    @color = color
  end
  def to_s
    return("#{color}")
  end

end

class Player
  attr_accessor :pattern, :feedback, :code_pegs

  def initialize
    @panttern = []
    @feedback = []
    @code_pegs = []
  end

  def guess_code()
    puts 'Input your code and separate it with spaces'
    guess = gets.chomp.split(' ')
    guess.each do |color|
      code_pegs.push(Peg.new(color))
    end
  end
end

class Computer
  attr_accessor :pattern, :feedback

  def initialize
      @pattern = []
      @feedback = []
  end

  def make_random_pattern
    5.times do
      pattern.push(random_pegs)
    end
  end
  def give_feedback(code_pegs)
    code_pegs.each_with_index do |peg, index|
      if present?(peg)
        if correct_in_position?(index, peg)
          feedback.push('B')
        else
          feedback.push('W')
        end
      end
    end
  end

  private

  def present?(code_peg)
    pattern.each do |peg|
      return true if code_peg.color == peg.color
    end
  end

  def correct_in_position?(index, code_peg)
    return true if code_peg.color == pattern[index].color
  end

  def random_pegs
    colors = ['Red, Blue, Yellow, Green, Violet']
    index = Random.rand(4)
    Peg.new(colors[index])
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
class Mastermind
  attr_accessor :player, :computer, :decoding_board
  def initialize
    @player = Player.new
    @computer = Computer.new
    @decoding_board = ''
  end
  def play_as_code_breaker
    decoding_board = DecodingBoard.new(computer,player)
    puts 'The game has started'
    puts 'You will play as the code breaker and the computer as code maker'
    puts 'Input 4 colors and separate it with spaces'
    computer.make_random_pattern
    puts computer.pattern
    12.times do
      puts 'Choices: blue, red, yellow, green, violet'
      player.guess_code
      if player.code_pegs.length != 4
        puts 'Please input 4 pegs and separate it with spaces'
        redo
      end
      computer.give_feedback(player.code_pegs)
      decoding_board.draw
      player.code_pegs.clear
      computer.feedback.clear
    end
  end

end
a = Mastermind.new
a.play_as_code_breaker

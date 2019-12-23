class Peg
  attr_accessor :color
  def initialize(color)
    @color = color
  end
  def to_string
    return("#{color}")
  end
  end
class Player
  attr_accessor :pattern, :feedback
  def initialize
    @panttern = []
    @feedback = []
  end
  def guess_code()
    puts 'Input your code and separate it with spaces'
    guess = gets.chomp.split(' ')
    pegs = []
    guess.each do |color|
      pegs.push(Peg.new(color))
    end
    return(pegs)
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
      pattern.push(get_random_pegs)
  end
  private
  def get_random_pegs
    colors = ['Red, Blue, Yellow, Green, Violet']
    index = Random.rand(4)
    return(Pegs.new(colors[index])
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
    @decoding_board;
  end

end

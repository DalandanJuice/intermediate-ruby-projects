class Peg
  attr_reader :color
  def initialize(color)
    @color = color
  end
  def to_s
    return("#{self.color}")
  end

end
class CodeMaker
  attr_accessor :pattern, :code_maker, :feedback
  def initialize(code_maker)
    @pattern = []
    @feedback = []
    @code_maker = code_maker
  end
  def give_feedback()
    code_pegs = self.code_maker.code
    code_pegs.each_with_index do |code,index|
      if is_present?
        if is_correct?(index)
          self.feedback.push('B')
        elsif is_wrong_position?(index)
          self.feedback.push('W')
        end
      else
      end
    end
    self.feedback = self.feedback.shuffle
  end
  def make_pattern()
    4.times do
      random_peg = get_random_pegs()
      self.pattern.push(random_peg)
    end
    self.code
  end
  def get_random_pegs()
    colors = ['Blue', 'Green', 'Yellow', 'Violet','Brown']
    random_index = rand(5)
    return Peg.new(colors[random_index])
  end
  private
  def is_correct?(index) #Correct in both color and position
    if self.pattern[index] == self.code_maker.code[index]
      return true
    else
      return false
    end
  end
  def is_wrong_position?(index) #Correct in color but wrong in position
    codes = self.code_maker.code
    if pattern.include?(codes[index])
      return true
    else
      return false
    end
  end
  def is_present?(index)
    codes = self.code_maker.code
    if pattern.include?(codes[index])
      return true
    else
      return false
    end
  end
end
class CodeBreaker
  attr_accessor :code
  def initialize()
   @code_pegs = []
  end

  def guess_code()
    puts 'Give 4 color sand separate it with space.(Example: Bl GR YL BR)'
    codes = gets.chomp.split(' ')
    codes.each do |color| 
      @code_pegs.push(Peg.new(color))
    end
  end
end
class DecodingBoard
  attr_accessor :code_maker, :code_breaker
  def initialize
    @code_maker = CodeMaker.new
    @code_breaker = CodeBreaker.new
  end
  def draw
    
  end
  private
  def draw_code
    code_pegs = self.code_maker.code
    code_pegs.each do |code|
      print('| #{code} |')
    end
  end
  def draw_feedback
    feedback = self.code_breaker.give_feedback
    print(' ')
    feedback.each do |x| 
      print( '')
    end
  end
end

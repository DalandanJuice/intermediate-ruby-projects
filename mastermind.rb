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
  attr_accessor :code
  def initialize()
    @code = []
  end
  def make_pattern()
    4.times do
      random_peg = get_random_pegs()
      self.code.push(random_peg)
    end
    self.code
  end
  def get_random_pegs()
    colors = ['Blue', 'Green', 'Yellow', 'Violet','Brown']
    random_index = rand(5)
    return Peg.new(colors[random_index])
  end
end
code_maker = CodeMaker.new()
a = code_maker.make_pattern
puts a

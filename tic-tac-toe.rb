class Player
  attr_reader :choice, :number
  attr_accessor :moves
  def initialize(choice,number)
    @choice = choice
    @moves = ''
    @number = number
  end
  def move(position,board)
    board[position - 1] = self.choice 
    return(board)
  end
end
class GameBoard
  attr_accessor :board
  def initialize()
    @board = [1,2,3,4,5,6,7,8,9]
  end
  def draw()
   self.board.each_with_index do |x,index|
      print "| #{x} | "
      if index == 2 or index == 5
        puts ' '
      end
    end
    return 'Player1: 1, Player2: 1'
  end
end


class ScoreBoard
  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end
end
class TicTacToe
  attr_accessor :player1, :player2, :game_board
  def initialize()
    @player1 = Player.new('x',1)
    @player2 = Player.new('o',2)
    @game_board = GameBoard.new
  end
  def start()
    puts ' '
    self.game_board.draw()
    while(true)
      occupied_cells = countOccupiedCells()
      if occupied_cells > 8  or is_3_in_a_row?('x') or is_3_in_a_row?('o')
        break
      end
      move(player1)
      move(player2)
    end
    declare_winner()
  end

  private

  def move(player)
    while true
      occupied_cells = countOccupiedCells()
      if occupied_cells > 8 
        puts ''
        puts 'Final result:'
        break
      elsif  is_3_in_a_row?('x') or is_3_in_a_row?('o')
        puts ' '
        puts 'Finish'
        puts ' '
        break
      end
      puts ''
      puts "Your turn Player #{player.number}"
      moves = gets.chomp
      if isOccupied?(moves) == false
        break
      end
      if isOccupied?(moves)
        puts 'That position is occupied'
        redo
      elsif moves.to_i > 9
        puts 'There are only 9 positions!'
        redo
      end
    end
    self.game_board.board = player.move(moves.to_i, self.game_board.board)
    self.game_board.draw()
  end

  def isOccupied?(position)
    board = self.game_board.board
    position = (position.to_i) - 1
    if board[position] == 'x' or board[position] == 'o'
      return true
    end
    return false
  end

  def countOccupiedCells()
    occupied_cells = 0
    9.times do |x|
      if isOccupied?(x)
        occupied_cells += 1
      end
    end
    occupied_cells
  end
  def declare_winner
    if is_3_in_a_row?('x')
      puts 'The winner is Player 1!'
    elsif is_3_in_a_row?('o')
      puts ' The winner is Player 2!'
    end
  end

  def is_3_in_a_row?(choice)
    if is_horizontal?(choice) or is_vertical?(choice) or is_diagonal?(choice)
      return true
    else
      return false
    end
  end
end

def is_horizontal?(choice)
  board = self.game_board.board 
  x = 0
  y = 1
  z = 2
  while x != 6
    if board[x] == choice and board[y] == choice and board[z] == choice
      return true
    else
      x += 3
      y += 3
      z += 3
    end
  end
end

def is_vertical?(choice)
  board = self.game_board.board 
  x = 0
  y = 3
  z = 6
  while x != 6
    if board[x] == choice and board[y] == choice and board[z] == choice
      return true
    else
      x += 1
      y += 1
      z += 1
    end
  end
  return false
end

def is_diagonal?(choice)
  board = self.game_board.board 
  if board[0] == choice and board[4] == choice and board[8] == choice
    return true
  elsif board[2] == choice and board[4] == choice and board[6] == choice
    return true
  else return false
  end
end


a = TicTacToe.new()
a.start()

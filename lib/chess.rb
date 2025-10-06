class Chess

  attr_accessor :gameboard, :turn

  def initialize
    @turn = 'White'
    @gameboard = Array.new(8) {Array.new(8, '  ')}
    @gameboard[0] = ['wR', 'wP', '  ', '  ', '  ', '  ', 'bP', 'bR']
    @gameboard[1] = ['wN', 'wP', '  ', '  ', '  ', '  ', 'bP', 'bN']
    @gameboard[2] = ['wB', 'wP', '  ', '  ', '  ', '  ', 'bP', 'bB']
    @gameboard[3] = ['wQ', 'wP', '  ', '  ', '  ', '  ', 'bP', 'bQ']
    @gameboard[4] = ['wK', 'wP', '  ', '  ', '  ', '  ', 'bP', 'bK']
    @gameboard[5] = ['wB', 'wP', '  ', '  ', '  ', '  ', 'bP', 'bB']
    @gameboard[6] = ['wN', 'wP', '  ', '  ', '  ', '  ', 'bP', 'bN']
    @gameboard[7] = ['wR', 'wP', '  ', '  ', '  ', '  ', 'bP', 'bR']
  end

  def display_gameboard
    #print "#{@gameboard[-1]}\n#{@gameboard[-2]}\n#{@gameboard[-3]}\n#{@gameboard[-4]}\n#{@gameboard[-5]}\n#{@gameboard[-6]}\n#{@gameboard[-7]}\n#{@gameboard[-8]}\n"
    i = 0
    j = 7
    until j == -1 do
      print " #{@gameboard[i][j]} "
      i += 1
      if i == 8
        print "\n"
        i = 0
        j -= 1
      end
    end
  end

  def make_move
    move = gets.chomp.downcase
    if move.length == 4 && move[0..1] != move [2..3] && ("a".."h").include?(move[0]) && ("1".."8").include?(move[1]) && ("a".."h").include?(move[2]) && ("1".."8").include?(move[3])
      move[0] = (move[0].ord - 97).to_s
      move[1] = (move[1].to_i - 1).to_s
      move[2] = (move[2].ord - 97).to_s
      move[3] = (move[3].to_i - 1).to_s
      move = move.to_i.digits.reverse
      validate_move(move[0..1], move[2..3])
    else
      make_move
    end
  end

  def validate_move(starting_square, destination_square)
    return false if @gameboard[starting_square[0]][starting_square[1]] == '  '
    return false if @gameboard[starting_square[0]][starting_square[1]].include?('b') && turn == 'White'
    return false if @gameboard[starting_square[0]][starting_square[1]].include?('w') && turn == 'Black'
    return false if @gameboard[destination_square[0]][destination_square[1]].include?('b') && turn == 'Black'
    return false if @gameboard[destination_square[0]][destination_square[1]].include?('w') && turn == 'White'
    validate_pawn_move(starting_square, destination_square) if @gameboard[starting_square[0]][starting_square[1]] == 'wP' || @gameboard[starting_square[0]][starting_square[1]] == 'bP'
    @gameboard[destination_square[0]][destination_square[1]] = @gameboard[starting_square[0]][starting_square[1]]
    @gameboard[starting_square[0]][starting_square[1]] = '  '
    display_gameboard
  end

  def validate_pawn_move(starting_square, destination_square)
    return false if destination_square[1] - starting_square[1] >= 2 && turn == 'White' || destination_square[1] - starting_square[1] <= 2 && turn == 'Black' # Pawn cannot move more then 2 squares forward in a move
    return false if (destination_square[1] - starting_square[1] == 2 && turn == 'White' && starting_square[1] != 1) || (destination_square[1] - starting_square[1] == -2 && turn == 'Black' && starting_square[1] != 6)
    
  end
end

test_game = Chess.new
test_game.display_gameboard
test_game.make_move
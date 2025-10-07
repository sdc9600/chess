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
    success = validate_pawn_move(starting_square, destination_square) if @gameboard[starting_square[0]][starting_square[1]].include?("P")
    success = validate_knight_move(starting_square, destination_square) if @gameboard[starting_square[0]][starting_square[1]].include?("N")
    success = validate_bishop_move(starting_square, destination_square) if @gameboard[starting_square[0]][starting_square[1]].include?("B")
    success = validate_rook_move(starting_square, destination_square) if @gameboard[starting_square[0]][starting_square[1]].include?("R")
    success = validate_queen_move(starting_square, destination_square) if @gameboard[starting_square[0]][starting_square[1]].include?("Q")
    success = validate_king_move(starting_square, destination_square) if @gameboard[starting_square[0]][starting_square[1]].include?("K")
    return false if success == false
    update_gamestate(starting_square, destination_square)
  end

  def validate_pawn_move(starting_square, destination_square)
    return false if destination_square[1] - starting_square[1] > 2 || destination_square[1] - starting_square[1] < -2 # Pawn cannot move more then 2 squares forward in a move
    return false if (destination_square[1] - starting_square[1] == 2 && turn == 'White' && starting_square[1] != 1) || (destination_square[1] - starting_square[1] == -2 && turn == 'Black' && starting_square[1] != 6)
    return false if (destination_square[0] - starting_square[0]).abs != 1 || (destination_square[0] - starting_square[0]) != 0
    return false if (destination_square[0] - starting_square[0]).abs == 1 && (destination_square[1] - starting_square[1]).abs != 1 #If the pawn moves horizontally 1 square it also moves vertically forward 1 square (capture)
    return false if (destination_square[0] - starting_square[0]).abs == 1 && (destination_square[1] - starting_square[1]).abs == 1 && @gameboard[destination_square[0]][destination_square[1]] == '  ' # Cannot move diagonally without capturing (except for e.p.)
  end

  def validate_knight_move(starting_square, destination_square)
    return false if (destination_square[0] - starting_square[0]).abs + (destination_square[1] - starting_square[1]).abs != 3
    return false if (destination_square[0] - starting_square[0]).abs == 3 || (destination_square[1] - starting_square[1]).abs == 3
  end

  def validate_bishop_move(starting_square, destination_square)
    return false if destination_square[0] - starting_square[0] != destination_square[1] - starting_square[1]
  end

  def validate_rook_move(starting_square, destination_square)
    return false if destination_square[0]  - starting_square[0] != 0 && destination_square[1] - starting_square[1] != 0
  end

  def validate_queen_move(starting_square, destination_square)
    return false if starting_square[0] != destination_square[0] && starting_square[1] != destination_square[1] && (destination_square[0] - starting_square[0]).abs != (destination_square[1] - destination_square[0]).abs
  end

  def validate_king_move(starting_square, destination_square)
    return false if (destination_square[0] - starting_square[0]).abs >= 2 || (destination_square[1] - starting_square[1]).abs >= 2
  end

  def update_gamestate(starting_square, destination_square)
    @gameboard[destination_square[0]][destination_square[1]] = @gameboard[starting_square[0]][starting_square[1]]
    @gameboard[starting_square[0]][starting_square[1]] = '  '
    @turn == "White" ? @turn = "Black" : @turn = "White"
  end

  def game_loop
    until 1 == 0 do #Infinite pending adding rules to check for checkmate / other end of game conditions
    display_gameboard
    make_move
    end
  end
end

test_game = Chess.new
test_game.game_loop
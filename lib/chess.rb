require 'pry-byebug'

class Chess

  attr_accessor :gameboard, :turn, :en_passant, :en_passant_coordinates

  def initialize
    @turn = 'White'
    @en_passant = 0
    @en_passant_coordinates = [0, 0]
    @white_castling = [1, 1]
    @black_castling = [1, 1]
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
      p move
      move = move.to_i.digits.reverse
      until move.length == 4 do
        move.unshift(0)
      end  #to_i will remove any leading zeroes if they exist, this adds them back to the array
      p move
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

  def line_of_sight(starting_square, destination_square)
    line_of_sight = []
    j = 1
    starting_square[0] <= destination_square[0] ? horizontal_vector = 1 : horizontal_vector = - 1
    starting_square[1] <= destination_square[1] ? vertical_vector = 1 : vertical_vector = - 1
    if starting_square[0] != destination_square[0] && starting_square[1] != destination_square[1]
      until starting_square[0] + (j * horizontal_vector) == destination_square[0] do
      line_of_sight.append(@gameboard[starting_square[0] + (j * horizontal_vector)][starting_square[1] + (j * vertical_vector)])
      j += 1
      end
    elsif starting_square[0] != destination_square[0]
      until starting_square[0] + (j * horizontal_vector) == destination_square[0] do
        line_of_sight.append(@gameboard[starting_square[0] + (j * horizontal_vector)][starting_square[1]])
        j += 1
      end
    else
      until starting_square[1] + (j * vertical_vector) == destination_square[1] do
        line_of_sight.append(@gameboard[starting_square[0]][starting_square[1]+ (j * vertical_vector)])
        j += 1
      end
    end
    p line_of_sight
    return false if line_of_sight.any? {|element| element != "  "}
  end

  def validate_pawn_move(starting_square, destination_square)
    return false if line_of_sight(starting_square, destination_square) == false
    return false if destination_square[1] - starting_square[1] > 2 || destination_square[1] - starting_square[1] < -2 # Pawn cannot move more then 2 squares forward in a move
    return false if (destination_square[1] - starting_square[1] == 2 && turn == 'White' && starting_square[1] != 1) || (destination_square[1] - starting_square[1] == -2 && turn == 'Black' && starting_square[1] != 6)
    return false if (destination_square[0] - starting_square[0]).abs != 1 && (destination_square[0] - starting_square[0]) != 0
    return false if (destination_square[0] - starting_square[0]).abs == 1 && (destination_square[1] - starting_square[1]).abs != 1 #If the pawn moves horizontally 1 square it also moves vertically forward 1 square (capture)
    return false if (destination_square[0] - starting_square[0]).abs == 1 && (destination_square[1] - starting_square[1]).abs == 1 && @gameboard[destination_square[0]][destination_square[1]] == '  ' && @en_passant_coordinates != [destination_square[0], destination_square[1]] # Cannot move diagonally without capturing (except for e.p.)
    return false if (destination_square[0] - starting_square[0]) == 0 && @gameboard[destination_square[0]][destination_square[1]] != '  ' #Pawn cannot capture vertically
    p @gameboard[destination_square[0]][destination_square[1]]
    en_passant(starting_square, destination_square) if @gameboard[destination_square[0]][destination_square[1]] == '  ' && starting_square[0] != destination_square[0]
    if (destination_square[1] - starting_square[1]).abs == 2
      @en_passant = 1
      @en_passant_coordinates = [destination_square[0], destination_square[1] - 1] if @turn == 'White'
      @en_passant_coordinates = [destination_square[0], destination_square[1] + 1] if @turn == 'Black'
    end
  end

  def en_passant(starting_square, destination_square)
    # binding.pry
    @gameboard[destination_square[0]][destination_square[1] - 1] = '  ' if @turn == "White"
    @gameboard[destination_square[0]][destination_square[1] + 1] = '  ' if @turn == "Black"
  end

  def validate_knight_move(starting_square, destination_square)
    return false if (destination_square[0] - starting_square[0]).abs + (destination_square[1] - starting_square[1]).abs != 3
    return false if (destination_square[0] - starting_square[0]).abs == 3 || (destination_square[1] - starting_square[1]).abs == 3
  end

  def validate_bishop_move(starting_square, destination_square)
    return false if (destination_square[0] - starting_square[0]).abs != (destination_square[1] - starting_square[1]).abs
    return false if line_of_sight(starting_square, destination_square) == false
  end

  def validate_rook_move(starting_square, destination_square)
    white_castling[0] = 0 if starting_square = [0, 0] && @turn == "White"
    white_castling[1] = 0 if starting_square = [7, 0] && @turn == "White"
    black_castling[0] = 0 if starting_square = [0, 7] && @turn == "Black"
    black_castling[1] = 0 if starting_square = [7, 7] && @turn == "Black"
    return false if destination_square[0]  - starting_square[0] != 0 && destination_square[1] - starting_square[1] != 0
    return false if line_of_sight(starting_square, destination_square) == false
  end

  def validate_queen_move(starting_square, destination_square)
    return false if starting_square[0] != destination_square[0] && starting_square[1] != destination_square[1] && (destination_square[0] - starting_square[0]).abs != (destination_square[1] - starting_square[1]).abs
    return false if line_of_sight(starting_square, destination_square) == false
  end

  def validate_king_move(starting_square, destination_square)
    validate_king_move_castling(starting_square, destination_square) if (destination_square[0] - starting_square[0]).abs == 2
    return false if (destination_square[0] - starting_square[0]).abs >= 2 || (destination_square[1] - starting_square[1]).abs >= 2
    white_castling = [0, 0] if @turn == "White"
    black_castling = [0, 0] if @turn == "Black"
  end

  def validate_king_move_castling(starting_square, destination_square)
    if starting_square == [4, 0] && destination_square == [6, 0] && white_castling[0] == 1 && @gameboard[5][0] == '  ' && @gameboard[6][0] == '  '
      @gameboard[5][0] = 'wR'
      @gameboard[7][0] = '  '
      return true
    elsif starting_square == [4, 0] && destination_square == [2, 0] && white_castling[1] == 1 && gameboard[3][0] == '  ' && gameboard[2][0] == '  ' && gameboard[1][0] == '  '
      @gameboard[3][0] = 'wR'
      @gameboard[0][0] = '  '
      return true
    elsif starting_square == [4, 7] && destination_square == [6, 7] && black_castling[0] == 1 && gameboard[5][7] == '  ' && gameboard[6][7] == '  '
      @gameboard[5][7] = 'bR'
      @gameboard[7][7] = '  '
      return true
    elsif starting_square == [4, 7] && destination_square == [2, 7] && black_castling[1] == 1 && gameboard[3][7] == '  ' && gameboard[2][7] == '  ' && gameboard[1][7] == '  '
      @gameboard[3][7] = 'bR'
      @gameboard[0][7] = '  '
      return true
    else
      false
    end
  end

  def is_in_check

  end

  def update_gamestate(starting_square, destination_square)
    @gameboard[destination_square[0]][destination_square[1]] = @gameboard[starting_square[0]][starting_square[1]]
    @gameboard[starting_square[0]][starting_square[1]] = '  '
    @turn == "White" ? @turn = "Black" : @turn = "White"
    if @en_passant == 1
      @en_passant -= 1
    else
      @en_passant_coordinates = nil
    end
  end

  def game_loop
    until 1 == 0 do #Infinite pending adding rules to check for checkmate / other end of game conditions
    display_gameboard
    make_move
    end
  end
end

test_game = Chess.new
test_game.line_of_sight([7, 7], [7, 0])
#test_game.game_loop

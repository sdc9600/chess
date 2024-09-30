require 'pry-byebug'

class Chess
  attr_reader :gameboard
  def initialize
    @gameboard = Array.new(8) {Array.new(8, "  ")}
    @turn = "White"
  end

  def starting_posiiton
    @gameboard[7] = ['bR', 'bN', 'bB', 'bQ', 'bK', 'bB', 'bN', 'bR']
    @gameboard[6] = ['bP','bP','bP','bP','bP','bP','bP','bP']
    @gameboard[1] = ['wP','wP','wP','wP','wP','wP','wP','wP']
    @gameboard[0] = ['wR', 'wN', 'wB', 'wQ', 'wK', 'wB', 'wN', 'wR']
  end

  def display_chessboard
    puts "#{@gameboard[7]}\n#{gameboard[6]}\n#{@gameboard[5]}\n#{gameboard[4]}\n#{@gameboard[3]}\n#{gameboard[2]}\n#{gameboard[1]}\n#{gameboard[0]}}"
  end

  def player_input_move
    puts "Enter the square where your piece is currently located and the square where you wish to move to as a 4-digit string e.g. 'e2e4'"
    input = gets.chomp
    validate_move(input)
  end

  def validate_move(move)
    x = 0
    move = move.chars
    move.each do |square|
     # binding.pry
      move[x] = (square.ord - 97) if square.to_i == 0
      move[x] = move[x].to_i - 1 if square.to_i != 0
      x+= 1
    end 
    starting_square = move[0..1]
    destination_square = move[2..3]
    piece_type = @gameboard[starting_square[1]][starting_square[0]]
    p piece_type
    p starting_square
    p destination_square
    legal_moves_check(starting_square, destination_square, piece_type)
  end

  def legal_moves_check(starting_square, destination_square, piece_type)
    inbetween_squares_array = []
    x = 1
    return false if starting_square == destination_square # The piece needs to actually move, passing is not valid
    return false if destination_square.any? {|element| element > 7 || element < 0} #Out of bounds check, a piece can't leave the gameboard
    if starting_square[0] < destination_square[0] && starting_square[1] == destination_square[1]
      until starting_square[0] + x == destination_square[0] do
        inbetween_squares_array.append([starting_square[0] + x, starting_square[1]])
        x += 1
      end
    elsif starting_square[0] > destination_square[0] && starting_square[1] == destination_square[1]
      until starting_square[0] + x == destination_square[0] do
        inbetween_squares_array.append([starting_square[0] - x, starting_square[1]])
        x += 1
      end
    end  # A check if there is any piece being passed over on the trip to the destination square (Ignored for knights and kings)
    if piece_type == "wP"
    end
    p inbetween_squares_array
  end
end

game = Chess.new
game.starting_posiiton
game.validate_move("e2a2")

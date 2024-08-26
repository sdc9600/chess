class Chess
  attr_reader :gameboard
  def initialize
    @gameboard = Array.new(8) {Array.new(8, "  ")}
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

  def make_move
    puts "Enter the square where you piece is currently located and the square where you wish to move to as a 4-digit string e.g. 'e2e4'"
    input = gets.chomp
    validate_move(input)
  end

  def validate_move(move)
    # Build a converter here that takes a user given string and converts it into numbers that can be directly plugged back 
    #into checking values in gameboard
    starting_square = move[0..1]
    destination_square = move[2..3]
  end
end

game = Chess.new
game.starting_posiiton
game.display_chessboard
game.validate_move("e2e4")
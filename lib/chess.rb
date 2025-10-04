class Chess

  def initialize
    @gameboard = Array.new(8) {Array.new(8, '  ')}
    @gameboard[0] = ['wR', 'wN', 'wB', 'wQ', 'wK', 'wB', 'wN', 'wR']
    @gameboard[1] = ['wP', 'wP', 'wP', 'wP', 'wP', 'wP', 'wP', 'wP']
    @gameboard[6] = ['bP', 'bP', 'bP', 'bP', 'bP', 'bP', 'bP', 'bP']
    @gameboard[7] = ['bR', 'bN', 'bB', 'bQ', 'bK', 'bB', 'bN', 'bR']
  end

  def display_gameboard
    print "#{@gameboard[-1]}\n#{@gameboard[-2]}\n#{@gameboard[-3]}\n#{@gameboard[-4]}\n#{@gameboard[-5]}\n#{@gameboard[-6]}\n#{@gameboard[-7]}\n#{@gameboard[-8]}\n"
  end

  def make_move
    move = gets.chomp
    if move.length == 4 && ("a".."h").include?(move[0]) && ("1".."8").include?(move[1]) && ("a".."h").include?(move[2]) && ("1".."8").include?(move[3])
      validate_move(move)
    else
      make_move
    end
  end

  def validate_move(move)
  end
end

test_game = Chess.new
test_game.display_gameboard
test_game.make_move
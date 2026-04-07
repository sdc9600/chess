class Chess

  attr_accessor :gameboard

  def initialize
    @gameboard = [['wR', 'wN', 'wB', 'wQ', 'wK', 'wB', 'wN', 'wR'],
    ['wP', 'wP', 'wP', 'wP', 'wP', 'wP', 'wP', 'wP'],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
    ['bP', 'bP', 'bP', 'bP', 'bP', 'bP', 'bP', 'bP'],
    ['bR', 'bN', 'bB', 'bQ', 'bK', 'bB', 'bN', 'bR']]
    @turn = "White"
    end

  def make_move
    move = gets.chomp
    if ("a".."h").include?(move[0]) && ("1..8").include?(move[1]) && ("a".."h").include?(move[2]) && ("1..8").include?(move[3]) && move.length == 4
      move[0] = (move[0].ord - 97).to_s
      move[1] = (move[1].ord - 49).to_s
      move[2] = (move[2].ord - 97).to_s
      move[3] = (move[3].ord - 49).to_s
      validate_move(move.reverse.to_i.digits) # Sent like this to make it easier to inspect later - a1h8 becomes [0, 0, 7, 7]
    else
      make_move
    end
  end

  def validate_move(move)
    return false if gameboard[move[0]][move[1]].include?("w") && @turn == "Black"
    return false if gameboard[move[0]][move[1]].include?("b") && @turn == "White"
    return false if gameboard[move[0]][move[1]] == " "

  end

end

test_game = Chess.new
p test_game.make_move
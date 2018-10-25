class Game
  attr_accessor :board, :player_1, :player_2

  WIN_COMBINATIONS = [
    [1,2,3],
    [4,5,6],
    [7,8,9],
    [1,4,7],
    [2,5,8],
    [3,6,9],
    [1,5,9],
    [3,5,7]
  ]

  def initialize(player_1 = Players::Human.new("X"),
                 player_2 = Players::Human.new("O"),
                 board = Board.new)
    @player_1 = player_1
    @player_2 = player_2
    @board = board
  end

  def current_player
    @board.turn_count.even? ? @player_1 : @player_2
  end

  def won?
    winning_line = WIN_COMBINATIONS.detect do |line|
      token = @board.position(line[0])
      token != " " && line[1..2].all? { |space| @board.position(space) == token }
    end
    winning_line ? winning_line : false
  end

  def draw?
    @board.full? && !won?
  end

  def over?
    draw? || won?
  end

  def winner
    winning_line = won?
    winning_line ? @board.position(winning_line[0]) : nil
  end

  def turn
    player = current_player
    move = nil
    until board.valid_move?(move)
      move = player.move(board)
    end
    @board.update(move, player)
  end

  def play
    until over?
      @board.display
      puts "Where would you like to move?"
      turn
    end
    puts winner ? "Congratulations #{winner}!" : "Cat's Game!"
  end
end

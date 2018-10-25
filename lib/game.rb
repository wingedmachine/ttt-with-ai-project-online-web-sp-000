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

  def self.start
    puts "It is the 90s, and it is time for tic tac toe."
    case determine_player_count
    when 0 then Game.new(Players::Computer.new("X"),
                         Players::Computer.new("O")
                        ).play
    when 1 then start_one_player_game
    when 2 then Game.new.play
    end
  end

  def self.determine_player_count
    input = nil
    loop do
      puts "How many players? 1, 2, or 0?"
      input = gets.strip
      break if input.match(/[012]/)
    end
    input.to_i
  end

  def self.start_one_player_game
    case determine_which_player_is_human
    when 1 then Game.new(Players::Human.new("X"),
                         Players::Computer.new("O")
                        ).play
    when 2 then Game.new(Players::Computer.new("X"),
                         Players::Human.new("O")
                        ).play
    end
  end

  def self.determine_which_player_is_human
    input = nil
    loop do
      puts "Would you like to be player 1 or 2?"
      input = gets.strip
      break if input.match(/[12]/)
    end
    input.to_i
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
      puts "\nWhere would you like to move?"
      turn
      @board.display
    end
    puts winner ? "Congratulations #{winner}!" : "Cat's Game!"
    offer_new_game
  end

  def offer_new_game
    input = nil
    loop do
      puts "Would you like to play again? (y/n)"
      input = gets.strip.downcase
      break if input.match(/[yn]/)
    end
    if input == "y"
      Game.start
    end
  end
end

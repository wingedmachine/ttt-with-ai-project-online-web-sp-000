class Board
  attr_accessor :cells

  def reset!
    @cells = Array.new(9, " ")
  end

  def initialize
    reset!
  end

  def display
    board = ""
    hori = "-----------"
    @cells.each_with_index do |cell, i|
      board << " #{cell} "
      case i % 3
      when 0, 1 then board << "|"
      when 2 then board << "\n#{hori}\n" unless i == 8
      end
    end
    puts board
  end

  def position(space)
    @cells[space.to_i - 1]
  end

  def full?
    @cells.all? { |cell| cell != " " }
  end

  def turn_count
    @cells.select { |cell| cell != " " }.size
  end

  def taken?(input)
    position(input) != " "
  end

  def valid_move?(input)
    input.to_i.between?(1, 9) && !taken?(input)
  end

  def update(space, player)
    @cells[space.to_i - 1] = player.token
  end
end

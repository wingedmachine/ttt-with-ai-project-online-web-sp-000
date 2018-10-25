module Players
  class Computer < Player
    def move(board)
      %w[1 2 3 4 5 6 7 8 9].detect { |space| board.valid_move?(space.to_s) }
    end
  end
end

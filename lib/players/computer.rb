module Players
  class Computer < Player
    # There are many places this class would benefit from refactoring,
    # but there are limited benefits to me spending more time on this
    # assignment when I could be completing future ones.

    CENTER = 5
    CORNERS = [1,3,7,9]
    EDGES = [2,4,6,8]
    POSSIBLE_LINES = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [1, 4, 7],
      [2, 5, 8],
      [3, 6, 9],
      [1, 5, 9],
      [3, 5, 7]
    ]

    def move(board)
      @board = board
      @token == "X" ? play_x : play_o
    end

    def play_x
      case @board.turn_count
      when 0 then CORNERS.sample
      when 2
        my_last_move = @board.cells.find_index("X") + 1
        their_move = @board.cells.find_index("O") + 1

        if their_move == CENTER
          find_opposite(my_last_move)
        elsif EDGES.include?(their_move)
          CENTER
        elsif their_move = find_opposite(my_last_move)
          CORNERS.dup.delete(their_move).delete(my_last_move).sample
        else
          find_opposite(their_move)
        end
      else
        near_lines = find_near_lines
        if near_lines[:mine].size > 0
          near_lines[:mine].sample.detect { |space| @board.position(space) \
            == " "}
        elsif near_lines[:theirs].size > 0
          near_lines[:theirs].sample.detect { |space| @board.position(space) \
            == " "}
        else
          trap_spots = find_trap_spots
          if trap_spots[:mine].size > 0
            trap_spots[:mine].sample
          elsif trap_spots[:theirs].size > 0
            trap_spots[:theirs].sample
          else
            Array(1..9).map { |space| @board.valid_move?(space) }.sample
          end
        end
      end
    end

    def play_o
      # Using the techniques exhibited in this class to create a functional AI
      # to play O is left as an excercise for the reader. I need to move on.
      %w[1 2 3 4 5 6 7 8 9].select { |space| @board.valid_move?(space.to_s) }.sample
    end

    def find_opposite(space)
      return nil if space == 5
      set = CORNERS.include?(space) ? CORNERS : EDGES
      set.reverse[set.find_index(space)]
    end

    def find_near_lines
      their_token = get_their_token
      near_lines = {
        mine: [],
        theirs: []
      }
      POSSIBLE_LINES.each do |line|
        if line.select { |space| @board.position(space) == @token} \
          .size == 2 && line.any? { |space| @board.position(space) == " " }
          near_lines[:mine] << line
        elsif line.select { |space| @board.position(space) == their_token} \
          .size == 2 && line.any? { |space| @board.position(space) == " " }
          near_lines[:theirs] << line
        end
      end
      near_lines
    end

    def find_trap_spots
      their_token = get_their_token
      near_empty_lines = { mine: [], theirs: [] }
      near_empty_lines[:all] = POSSIBLE_LINES.select do |line|
        line.select { |space| @board.position(space) == " " }.size == 2
      end
      near_empty_lines[:all].each do |line|
        if line.detect { |space| @board.position(space) == @token }
          near_empty_lines[:mine] << line
        else
          near_empty_lines[:theirs] << line
        end
      end
      trap_spots = {
        mine: compare_near_empty_lines(near_empty_lines[:mine]),
        theirs: compare_near_empty_lines(near_empty_lines[:theirs])
      }
    end

    def compare_near_empty_lines(lines)
      lines.map do |line|
        line.delete(line.detect { |space| @board.position(space) != " " })
      end
      matches = []
      i = 0
      while i > lines.size - 1
        matches << lines[i + 1..-1].select { |line| lines[i] & line }
      end
      matches.flatten
    end

    def get_their_token
      @token == "X" ? "O" : "X"
    end
  end
end

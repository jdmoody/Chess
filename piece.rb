require './board.rb'

class Piece
  COLORS = {

    :white => :bottom,
    :black => :top

  }
  attr_accessor :position

  HORIZ_VERT =   [[1, 0], [-1, 0], [0,  1], [0,  -1]]
  DIAGONALS = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
  end
end

class SlidingPiece < Piece

  def moves
    all_positions = []
    self.move_dirs.map do |pos_change|
      new_pos = @position.dup
      8.times do#until @board[@position].occupied?
        new_pos = new_pos.dup
        new_pos[0] += pos_change[0]
        new_pos[1] += pos_change[1]
        all_positions << new_pos
      end
    end
    all_positions.sort
  end
end

class Bishop < SlidingPiece
  def move_dirs
    DIAGONALS
  end
end

class Rook < SlidingPiece
  def move_dirs
    HORIZ_VERT
  end
end

class Queen < SlidingPiece
  def move_dirs
    DIAGONALS + HORIZ_VERT
  end
end

class SteppingPiece < Piece
  def moves
    self.move_dirs.map do |pos|
    [@position[0] + pos[0], @position[1] + pos[1]]
    end
  end
end

class King < SteppingPiece
  def move_dirs
    HORIZ_VERT + DIAGONALS
  end
end

class Knight < SteppingPiece
  def move_dirs
    [[-1, 2], [-1, -2], [1, -2], [1, 2], [2, -1], [-2, -1], [-2, 1], [2, 1]]
  end
end

class Pawn < SteppingPiece
  def move_dirs
    white? ? [0, 1] : [0, -1]
  end
end

# knight = Knight.new([0,0], nil)
# p knight.moves.inspect

queen = Bishop.new([0,0], nil)
p queen.moves.inspect


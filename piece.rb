require 'colorize'

class Piece
  attr_accessor :position, :color

  HORIZ_VERT =   [[1, 0], [-1, 0], [0,  1], [0,  -1]]
  DIAGONALS = [[1, 1], [-1, 1], [1, -1], [-1, -1]]

  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
  end

  def valid?(new_pos)
    return false unless in_bounds(new_pos)
    occupant = @board[new_pos]
    return true if occupant == nil
    occupant.color == self.color ? false : true
  end

  def in_bounds(new_pos)
    new_pos.all? do |row_or_col|
      row_or_col.between?(0, 7)
    end
  end

end

class SlidingPiece < Piece

  def moves
    all_positions = []
    self.move_dirs.map do |pos_change|
      new_pos = @position.dup
      loop do
        new_pos = new_pos.dup
        new_pos[0] += pos_change[0]
        new_pos[1] += pos_change[1]
        break unless self.valid?(new_pos)
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

  def to_s
    "B"
  end
end

class Rook < SlidingPiece
  def move_dirs
    HORIZ_VERT
  end

  def to_s
    "R"
  end
end

class Queen < SlidingPiece
  def move_dirs
    DIAGONALS + HORIZ_VERT
  end

  def to_s
    "Q"
  end
end

class SteppingPiece < Piece
  def moves
    self.move_dirs.map do |pos|
      [@position[0] + pos[0], @position[1] + pos[1]]
    end.select { |pos| self.valid?(pos) }
  end
end

class King < SteppingPiece
  def move_dirs
    HORIZ_VERT + DIAGONALS
  end

  def to_s
    "K"
  end
end

class Knight < SteppingPiece
  def move_dirs
    [[-1, 2], [-1, -2], [1, -2], [1, 2], [2, -1], [-2, -1], [-2, 1], [2, 1]]
  end

  def to_s
    "H"
  end
end

class Pawn < SteppingPiece
  attr_reader :starting_pos
  def initialize(position, board, color)
    super
    @starting_pos = position
  end

  def moves
    valid_moves = []
    forward = super.flatten
    diagonals = [[forward[0] + 1, forward[1]], [forward[0] - 1, forward[1]]]

    valid_moves << forward unless @board.occupied?(forward)
    diagonals.each do |diagonal|
      valid_moves << diagonal if @board.occupied?(diagonal)
    end

    starting_move_dir = move_dirs.flatten.map { |i| i * 2 }
    valid_moves << [@starting_pos[0], @starting_pos[1] + starting_move_dir[1]]

    valid_moves
  end

  def move_dirs
    self.color == :red ? [[0, 1]] : [[0, -1]]

  end

  def to_s
    "P"
  end
end

# knight = Knight.new([0,0], nil)
# p knight.moves.inspect

# queen = Bishop.new([0,0], nil, :black)
# p queen.to_s
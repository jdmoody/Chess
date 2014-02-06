require './stepping_piece.rb'

class Knight < SteppingPiece
  def move_dirs
    [[-1, 2], [-1, -2], [1, -2], [1, 2], [2, -1], [-2, -1], [-2, 1], [2, 1]]
  end

  def to_s
    "H"
  end
end
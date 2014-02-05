require './piece.rb'
class Queen < SlidingPiece
  def move_dirs
    DIAGONALS + HORIZ_VERT
  end

  def to_s
    "Q"
  end
end
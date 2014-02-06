require './sliding_piece.rb'

class Bishop < SlidingPiece
  def move_dirs
    DIAGONALS
  end

  def to_s
    "B"
  end
end
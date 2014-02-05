require './piece.rb'
class Rook < SlidingPiece
  def move_dirs
    HORIZ_VERT
  end

  def to_s
    "R"
  end
end
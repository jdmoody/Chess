# encoding: utf-8
require './piece.rb'
class King < SteppingPiece
  def move_dirs
    HORIZ_VERT + DIAGONALS
  end

  def to_s
    "♔"
  end
end
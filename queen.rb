# encoding: utf-8
require './sliding_piece.rb'

class Queen < SlidingPiece
  def move_dirs
    DIAGONALS + HORIZ_VERT
  end

  def to_s
    "♕"
  end
end
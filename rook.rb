# encoding: utf-8
require './sliding_piece.rb'

class Rook < SlidingPiece
  def move_dirs
    HORIZ_VERT
  end

  def to_s
    "♖"
  end
end
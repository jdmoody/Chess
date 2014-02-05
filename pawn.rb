require './piece.rb'
class Pawn < SteppingPiece
  attr_reader :starting_pos
  def initialize(position, board, color)
    super
    @starting_pos = position
  end

  def moves
    valid_moves = []
    all_moves = super
    p all_moves


    valid_moves
  end

  def move_dirs
    white_directions = [[-1,-1],[0,-1],[1,-1],[0,-2]]
    red_directions = [[-1, 1],[0, 1],[1, 1],[0, 2]]
    self.color == :red ? red_directions : white_directions
  end

  def to_s
    "P"
  end
end
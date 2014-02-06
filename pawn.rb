# encoding: utf-8
require './stepping_piece.rb'

class Pawn < SteppingPiece
  attr_reader :starting_pos
  def initialize(position, board, color)
    super
    @starting_pos = position
  end

  def moves
    valid_moves = []
    forward_one = vertically_sum(@position, move_dirs[1])
    forward_two = vertically_sum(@position, move_dirs[3])
    forward_left = vertically_sum(@position, move_dirs[0])
    forward_right = vertically_sum(@position, move_dirs[2])

    unless self.board.occupied?(forward_one)
      valid_moves << forward_one
      unless self.board.occupied?(forward_two)
        valid_moves << forward_two if @starting_pos == position
      end
    end

    valid_moves << forward_left if self.board.occupied?(forward_left)
    valid_moves << forward_right if self.board.occupied?(forward_right)

    valid_moves.select { |pos| self.valid?(pos) }
  end



  def move_dirs
    white_directions = [[-1,-1],[0,-1],[1,-1],[0,-2]]
    red_directions = [[-1, 1],[0, 1],[1, 1],[0, 2]]
    self.color == :red ? red_directions : white_directions
  end

  def to_s
    "♙"
  end
end
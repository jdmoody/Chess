require './piece.rb'
class Pawn < SteppingPiece
  attr_reader :starting_pos
  def initialize(position, board, color)
    super
    @starting_pos = position
  end

  def moves
    valid_moves = []
    forward_one = self.adjust_position_by(move_dirs[1])
    forward_two = self.adjust_position_by(move_dirs[3])
    forward_left = self.adjust_position_by(move_dirs[0])
    forward_right = self.adjust_position_by(move_dirs[2])

    unless self.board.occupied?(forward_one)
      valid_moves << forward_one
      valid_moves << forward_two unless self.board.occupied?(forward_two)
    end

    valid_moves << forward_left if self.board.occupied?(forward_left)
    valid_moves << forward_right if self.board.occupied?(forward_right)

    valid_moves.select { |pos| self.valid?(pos) }
  end

  def adjust_position_by(change)
    new_position = self.position.dup
    new_position.zip(change)
    .map { |pos, change| pos + change }
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
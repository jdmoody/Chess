# encoding: utf-8

require 'colorize'

class Piece
  attr_accessor :position, :color, :board

  HORIZ_VERT =   [[1, 0], [-1, 0], [0,  1], [0,  -1]]
  DIAGONALS = [[1, 1], [-1, 1], [1, -1], [-1, -1]]

  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
  end

  def valid?(new_pos)
    return false unless in_bounds(new_pos)
    occupant = @board[new_pos]
    return true if occupant == nil
    occupant.color == self.color ? false : true
  end

  def capture?(new_pos)
    occupant = @board[new_pos]
    return true if occupant && occupant.color != self.color
  end

  def in_bounds(new_pos)
    new_pos.all? do |row_or_col|
      row_or_col.between?(0, 7)
    end
  end

  def move_into_check?(pos)
    dup_board = self.board.dup
    dup_board.move!(self.position, pos, @color)
    dup_board.in_check?(self.color)
  end

  def valid_moves
    all_moves = self.moves
    all_moves.delete_if do |pos|
      self.move_into_check?(pos)
    end
    all_moves
  end

  def vertically_sum(position, change)
    new_position = position.dup
    new_position.zip(change)
    .map { |pos, change| pos + change }
  end
end




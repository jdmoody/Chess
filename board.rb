# encoding: utf-8

require './piece.rb'
require 'colorize'
require './chess_errors.rb'

class Board
  attr_accessor :grid, :pieces

  def initialize
    @grid = Array.new(8) { Array.new(8) { nil } }
    @pieces = {
      :red => self.create_pieces(:red),
      :white => self.create_pieces(:white)
    }
    @pieces.each do |color, _ |
      self.place_pieces(color)
    end
  end

  def self.dup
    board_copy = Board.new
    board_copy.grid = Array.new(8) { Array.new(8) { nil } }
    board_copy.pieces = {}
    board_copy
  end

  def create_pawns(color)
    [].tap do | pawns |
      (0...8).each do |row|
        col = (color == :white) ? 6 : 1
        pos = [row, col]
        pawns << Pawn.new(pos, self, color)
      end
    end
  end

  def create_pieces(color)
    col = (color == :white) ? 7 : 0
    [].tap do |all_pieces|
      all_pieces << Rook.new([0,col], self, color)
      all_pieces << Bishop.new([1,col], self, color)
      all_pieces << Knight.new([2,col], self, color)
      all_pieces << Queen.new([3,col], self, color)
      all_pieces << King.new([4,3], self, color) if color == :white
      all_pieces << Knight.new([5,col], self, color)
      all_pieces << Bishop.new([6,col], self, color)
      all_pieces << Rook.new([7,col], self, color)
      all_pieces.concat(self.create_pawns(color))
    end
  end

  def dup
    copy = Board.dup

    new_red_pieces = @pieces[:red].map do |piece|
      piece_copy = piece.dup
      piece_copy.board = copy
      piece_copy
    end

    new_white_pieces = @pieces[:white].map do |piece|
      piece_copy = piece.dup
      piece_copy.board = copy
      piece_copy
    end

    new_pieces = { :red => new_red_pieces, :white => new_white_pieces}
    copy.pieces = new_pieces
    new_pieces.each do |color, pieces|
      copy.place_pieces(color)
    end

    copy.pieces = new_pieces
    copy
  end


  def in_check?(color)
    king = @pieces[color].select do |piece|
      piece.is_a?(King)
    end.first
    @pieces[other_color(color)].any? do |piece|
      piece.moves.include?(king.position)
    end
  end

  def move(start, end_pos)
    occupant = self[start]
    move!(start, end_pos) if occupant.valid_moves.include?(end_pos)
  end

  def move!(start, end_pos)
    raise MoveStartError.new unless self.occupied?(start)
    raise MoveEndError.new unless self[start].moves.include?(end_pos)
#     rescue MoveStartError => e
#       puts "There is no piece at #{start}"
#       retry
#     rescue MoveEndError => e
#       puts "#{end_pos} is not a valid position for that piece"
#       retry
      occupant = self[start]
      self[end_pos] = nil
      self[end_pos] = occupant
      self[start] = nil
      puts to_s
  end

  def occupied?(pos)
    self[pos]
  end

  def other_color(color)
    color == :red ? :white : :red
  end

  def place_pieces(color)
    self.pieces[color].each do |piece|
      self[piece.position] = piece
    end
  end

  def to_s
    @grid.map do |row|
      row.map do |square|
        square == nil ? "_" : square.to_s.colorize(square.color)
      end.join(" ")
    end.join("\n")
  end

  def []=(pos, piece)
    row, col = pos
    @grid[col][row] = piece
    piece.position = pos unless piece == nil
  end

  def [](pos)
    row, col = pos
    @grid[col][row]
  end
end

board = Board.new
# rook = board[[0,7]]
# horse = board[[2,0]]
# pawn = board[[1,6]]
#
# puts board.to_s
#
# puts board.in_check?(:white)

puts board.to_s
"Moving king:"
king = board[[4,3]]
p king.valid_moves
p king.moves
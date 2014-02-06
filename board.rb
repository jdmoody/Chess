# encoding: utf-8

require './piece.rb'
require 'colorize'
require './chess_errors.rb'
require './pawn.rb'
require './king.rb'
require './knight.rb'
require './queen.rb'
require './rook.rb'
require './bishop.rb'

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

  def checkmate?(color)
    no_valid_moves = @pieces[color].all? do |piece|
      piece.valid_moves.empty?
    end

    in_check?(color) && no_valid_moves
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
      all_pieces << Knight.new([1,col], self, color)
      all_pieces << Bishop.new([2,col], self, color)
      all_pieces << Queen.new([3,col], self, color)
      all_pieces << King.new([4,col], self, color)
      all_pieces << Bishop.new([5,col], self, color)
      all_pieces << Knight.new([6,col], self, color)
      all_pieces << Rook.new([7,col], self, color)
      all_pieces.concat(self.create_pawns(color))
    end
  end

  def convert_pos_to_coords(pos)
    letter = (pos[0] + 97).chr
    number = 8 - Integer(pos[1])
    "#{letter}#{number}"
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

  def move(start, end_pos, color)
    start_coord = self.convert_pos_to_coords(start)
    end_coord = self.convert_pos_to_coords(end_pos)
    raise MoveStartError.new(start_coord) unless self.occupied?(start)
    occupant = self[start]

    raise WrongPlayerError.new unless color == occupant.color
    raise MoveEndError.new(end_coord) unless self[start].moves.include?(end_pos)
    if occupant.valid_moves.include?(end_pos)
      move!(start, end_pos, color)
    else raise MoveIntoCheckError.new
    end
    self
  end

  def move!(start, end_pos, color)
    occupant = self[start]
    former_occupant = self[end_pos]
    self.pieces[other_color(color)].delete_if { |piece| piece == former_occupant }

    self[end_pos] = nil
    self[end_pos] = occupant
    self[start] = nil
    self
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
    end.join("\n") + "\n\n"
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
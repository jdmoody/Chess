# encoding: utf-8

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
    y = (color == :white) ? 7 : 0
    [].tap do |all_pieces|
      piece_classes = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
      piece_classes.map.with_index do |piece, x|
        all_pieces << piece.new([x, y], self, color)
      end
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

    occupant = self[start]
    raise MoveStartError.new(start_coord) unless self.occupied?(start)
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
    self.pieces[other_color(color)].delete_if do |piece|
      piece == former_occupant
    end

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
    row_number = 8
    grid_string = @grid.map.with_index do |row, x_idx|
      row_string = row.map.with_index do |square, y_idx|
        color = ((x_idx + y_idx) % 2 == 0 ? :black : :green)
        if square == nil
          "   ".colorize( :background => color)
        else
          " #{square.to_s} ".colorize(:color => square.color, :background => color)
        end
      end.join("")
      row_string = "#{row_number} " + row_string + " #{row_number}"
      row_number -= 1
      row_string
    end.join("\n") + "\n"
    "\n   a  b  c  d  e  f  g  h\n" + grid_string + "   a  b  c  d  e  f  g  h\n\n"
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
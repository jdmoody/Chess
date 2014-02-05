require './piece.rb'
require 'colorize'

class Board

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

  def display
    @grid.map do |row|
      row.map do |square|
        square == nil ? "_" : square.to_s.colorize(square.color)
      end.join(" ")
    end.join("\n")
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
      all_pieces << King.new([4,2], self, color)
      all_pieces << Knight.new([5,col], self, color)
      all_pieces << Bishop.new([6,col], self, color)
      all_pieces << Rook.new([7,col], self, color)
      all_pieces.concat(self.create_pawns(color))
    end
  end

  def place_pieces(color)
    @pieces[color].each do |piece|
      self[piece.position] = piece
    end
  end

  def []=(pos, piece)
    row, col = pos
    @grid[col][row] = piece
    piece.position = pos
  end

  def [](pos)
    row, col = pos
    @grid[col][row]
  end

  def in_check?(color)
    king = @pieces[color].select do |piece|
      piece.is_a?(King)
    end.first


    @pieces[other_color(color)].any? do |piece|
      piece.moves.include?(king.position)
    end
  end

  def occupied?(pos)
    self[pos]
  end

  def other_color(color)
    color == :red ? :white : :red
  end
end

board = Board.new
puts board.display
rook = board[[0,7]]
horse = board[[2,0]]
pawn = board[[1,6]]

p pawn.moves


require './piece.rb'
require 'colorize'

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) { nil } }
    [:red, :white].each do |color|
      self.place_pawns(color)
      self.place_other_pieces(color)
    end
  end

  def display
    @grid.map do |row|
      row.map do |square|
        square == nil ? "_" : square.to_s.colorize(square.color)
      end.join(" ")
    end.join("\n")
  end

  def place_other_pieces(color)
    #pass in y instead?
    col = (color == :white) ? 7 : 0
    self[[0,col]] = Rook.new([0,col], self, color)
    self[[1,col]] = Bishop.new([1,col], self, color)
    self[[2,col]] = Knight.new([2,col], self, color)
    self[[3,col]] = Queen.new([3,col], self, color)
    self[[4,col]] = King.new([4,col], self, color)
    self[[5,col]] = Knight.new([5,col], self, color)
    self[[6,col]] = Bishop.new([6,col], self, color)
    self[[7,col]] = Rook.new([7,col], self, color)
  end

  def place_pawns(color)
    (0...8).each do |row|
      col = (color == :white) ? 6 : 1
      pos = [row, col]
      pawn = Pawn.new(pos, self, color)
      self[pos] = pawn
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
end

board = Board.new
puts board.display
rook = board[[0,7]]
horse = board[[2,0]]
p horse.moves



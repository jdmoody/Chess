require './piece.rb'

class Board

  def initialize
    @grid = Array.new(8) { Array.new(8) { nil } }
    [:white, :black].each do |color|
      self.place_pawns(color)
      self.place_other_pieces(color)
    end
  end

  def place_other_pieces(color)
    #pass in y instead?
    y = (color == :white) ? 0 : 7
    Rook.new([0,y], self, color)
    Bishop.new([1,y], self, color)
    Horse.new([2,y], self, color)
    Queen.new([3,y], self, color)
    King.new([4,y], self, color)
    Horse.new([5,y], self, color)
    Bishop.new([6,y], self, color)
    Rook.new([7,y], self, color)
  end

  def place_pawns(color)
    (0...8).each do |x|
      y = (color == :white) ? 1 : 6
      pawn = Piece.new([x, y], self, color)
      @grid[[x, y]]
    end
  end

  def []=(pos, piece)
    x, y = pos
    @grid[x][y] = piece
    piece.position = pos
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end
end
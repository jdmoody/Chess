require './piece.rb'

class SteppingPiece < Piece
  def moves
    self.move_dirs.map do |dpos|
      vertically_sum(@position, dpos)
    end.select { |pos| self.valid?(pos) }
  end
end

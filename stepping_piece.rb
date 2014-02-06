require './piece.rb'

class SteppingPiece < Piece
  def moves
    self.move_dirs.map do |dpos|
      [@position[0] + dpos[0], @position[1] + dpos[1]]
    end.select { |pos| self.valid?(pos) }
  end
end

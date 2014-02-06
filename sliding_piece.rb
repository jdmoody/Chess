require './piece.rb'

class SlidingPiece < Piece

  def moves
    all_positions = []
    self.move_dirs.map do |pos_change|
      new_pos = @position.dup
      loop do
        new_pos = vertically_sum(new_pos, pos_change)
        break unless self.valid?(new_pos)
        all_positions << new_pos
        break if self.capture?(new_pos)
      end
    end
    all_positions

  end
end
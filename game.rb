require './board.rb'

class Game

  def initialize
    @board = Board.new
    @player_1, @player_2 = Player.new(:white), Player.new(:red)
    @current_player = @player_1
  end

  def play
    until game_over?
      puts @board.to_s
      begin
        puts "#{@current_player.color}'s turn!"
        start_coord, end_coord = @current_player.play_turn
        start_pos = convert_coords_to_pos(start_coord)
        end_pos = convert_coords_to_pos(end_coord)

        @board.move(start_pos, end_pos, @current_player.color)
      rescue MoveStartError => e
        pos = e.message.split(",")
        puts "There is no piece at #{e.message}"
        retry
      rescue MoveEndError => e
        puts "#{e.message} is not a valid position for that piece."
        retry
      rescue WrongPlayerError => e
        puts "You cannot move the other player's pieces."
        retry
      end
       self.switch_player
    end
    self.switch_player
    puts @board.to_s
    p "Game over! The winner is #{@current_player.color}"


  end

  def game_over?
    @board.checkmate?(@current_player.color)
  end


  def switch_player
    @current_player = (@current_player == @player_1 ? @player_2 : @player_1)
  end

  def convert_coords_to_pos(coords)
    x_pos = coords.first.ord - 97
    y_pos = 8 - Integer(coords.last)
    [x_pos, y_pos]
  end




end

class Player
  attr_reader :color
  def initialize(color)
    @color = color
  end

  def play_turn
    puts "Enter the positions you would like to move from and to (e.g. 'a2, a3'):"
    begin
      start, end_pos = gets.chomp.split(",")

      *pos = start.strip.split(""), end_pos.strip.split("")

    rescue NoMethodError => e
      puts "Please enter valid coordinates"
      retry
    end
  end
end

game = Game.new
game.play

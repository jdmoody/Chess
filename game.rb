require './board.rb'
require 'yaml'
require 'debugger'
class Game
  attr_accessor :board
  def initialize
    @board = Board.new
    @player_1, @player_2 = Player.new(:white), Player.new(:red)
    @current_player = @player_1
  end

  def play

    puts "Would you like to start a [n]ew game of [l]oad a previous game?"
    response = gets.chomp
    if response.downcase == 'l'
      puts "What is the name of your file?"
      filename = gets.chomp
      loaded_game_board = self.load_game(filename)
      self.board = loaded_game_board
    end


    until game_over?
      puts @board.to_s
      begin
        puts "#{@current_player.color.to_s.capitalize}'s turn!"
        if @board.in_check?(@current_player.color)
          puts "Careful, you're in check!"
        end
        player_response = @current_player.play_turn
        if player_response == 's'
          puts "and Im getting here "
          self.save_game
        else
          start_coord, end_coord = player_response
          start_pos = convert_coords_to_pos(start_coord)
          end_pos = convert_coords_to_pos(end_coord)

          @board.move(start_pos, end_pos, @current_player.color)
        end
      rescue MoveStartError => e
        pos = e.message.split(",")
        puts "There is no piece at #{e.message}"
        retry
      rescue MoveEndError => e
        puts "#{e.message} is not a valid position for that piece."
        retry
      rescue WrongPlayerError
        puts "You cannot move the other player's pieces."
        retry
      rescue MoveIntoCheckError
        puts "That move would put you into check. Try Again."
        retry
      end
       self.switch_player
    end
    self.switch_player
    puts @board.to_s
    p "Game over! The winner is #{@current_player.color}"

  end

  def load_game(filename)
    YAML.load_file("#{filename}.yml")
  end

  def save_game
    puts "Enter filename: "
    filename = "#{gets.chomp}.yml"

    File.open(filename, "w") do | f |
      f.puts(self.board.to_yaml)
    end
    exit

  end

  def game_over?
    @board.checkmate?(@current_player.color)
  end

  def save

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
    puts "Enter a move (a2, a3) or type 's' to save a game:"
    begin
      response = gets.chomp
      puts "the response was #{response}"
      return 's' if response.downcase == 's'
      puts "but i didn't retrun...."
      start, end_pos = response.split(",")

      *pos = start.strip.split(""), end_pos.strip.split("")

    rescue NoMethodError => e
      puts "Please enter valid coordinates"
      retry
    end
  end
end

game = Game.new
game.play

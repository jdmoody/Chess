require 'set'
module Hangman

  class Game
    attr_accessor :word_so_far
    def initialize(player_1, player_2)
      @guessing_player = player_1
      @checking_player = player_2
    end

    def next_turn
        next_guess = @guessing_player.guess(self.word_so_far)
        correct_idxs = @checking_player.check_guess(next_guess)
      #  p "correct idxs are #{correct_idxs}"

        self.word_so_far = @checking_player.handle_guess_response(correct_idxs, next_guess, self.word_so_far)
    end

    def play
      @word_so_far = @checking_player.pick_secret_word
      secret_word_length = self.word_so_far.length

      @guessing_player.receive_secret_length(secret_word_length)
      @incorrect_letters = []

      while self.word_so_far.include?("_")
        next_turn
      end
    end
  end


  class HumanPlayer
    def initialize(name)
      @name = name
    end

    # Methods for checker
    def pick_secret_word
      begin
        puts "Think of a secret word. How many letters does it contain?"
        num_letters = Integer(gets.chomp)
        raise ArgumentError.new unless num_letters.is_a? Integer
      rescue ArgumentError => e
        puts "Must enter a number"
        retry
      end
      @secret_word = "_" * num_letters
    end

    def check_guess(guess)
      correct_idxs = []

      begin
        puts "Does your word contain the letter #{guess}? (y/n)"
        response = gets.chomp.downcase
        raise ArgumentError.new unless response == 'y' || response == 'n'
      rescue
        puts "Please enter 'y' or 'n'"
        retry
      end
      if response == 'y'
        begin
          puts "Please enter the indexes of the letter (e.g. '1,3,5')"
          correct_idxs = gets.chomp.split(",").map {|string_num| Integer(string_num) }
          unless correct_idxs.all? { |num| num.is_a?(Integer) && num <= @secret_word.length }
            raise ArgumentError.new
          end
        rescue ArgumentError
          puts "Please enter a valid list of indexes"
          retry
        end
      else
        "Ok, guess that letter was incorrect"
        # come back and add a way to add incorrext guesses
      end
      correct_idxs
    end

    def handle_guess_response(correct_idxs, guess, word_so_far)
      p "the word so far is #{word_so_far}, and the correct idxs are #{correct_idxs}"
      correct_idxs.each do |i|
        word_so_far[i] = guess
      end
      puts "The word is now #{word_so_far}"
      word_so_far
    end

    # Methods for guesser

    def guess(word_so_far)
      puts "What letter would you like to guess?"
      guess = gets.chomp
    end

    def receive_secret_length(word_length)
    end
  end

  class ComputerPlayer
    attr_accessor :my_secret_word, :dictionary, :dictionary_subset, :hist

    def initialize()
      @name = "SuperBot"
      @dictionary = Set.new(File.readlines("dictionary.txt").map(&:chomp))
    end

    # Methods for checker
    def pick_secret_word
      @my_secret_word = @dictionary.sample
      puts "Here's a hint: the word is #{@my_secret_word}"
      "_" * @my_secret_word.length
    end


    def check_guess(guess)
      [].tap do |correct_idxs|
        @my_secret_word.each_char.with_index do |letter, i|
          correct_idxs << i if letter == guess
        end
      end
    end

    def handle_guess_response(correct_idxs, guess, word_so_far)
      correct_idxs.each do |i|
        word_so_far[i] = guess
      end
      if correct_idxs.length == 0
        puts "I'm sorry, that letter was not included"
      end
      puts "The word is now #{word_so_far}"
      word_so_far
    end

    # Methods for guesser

    def guess(word_so_far)
      self.hist || generate_histogram
      letter = self.hist.pop[0]
    end

    def receive_secret_length(word_length)
      @dictionary_subset = self.dictionary.select {|candidate| candidate.length == word_length }
    end

    def generate_histogram
      @hist = Hash.new {|h, k| h[k] = 0 }
      self.dictionary_subset.each do |word|
        word.each_char do |letter|
          @hist[letter] += 1
        end
      end
      @hist = @hist.sort_by {|k,v| v }
      p "Current histogram is #{@histogram}"
    end

    def update_histogram(word_so_far)

    end

  end
end

bot = Hangman::ComputerPlayer.new
person = Hangman::HumanPlayer.new("Chrissie")

# Initialize with Game.new(guesser, checker)
#game = Hangman::Game.new(person,bot)
game = Hangman::Game.new(bot,person)
game.play
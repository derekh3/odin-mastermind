require 'pry-byebug'

module Helpers
  def process_string(string)
    arr_of_str = string.split(",")
    arr_of_int = arr_of_str.map { |x| x.strip.to_i }
  end

  def random_code(num_colors, num_slots)
    code = Array.new(num_slots)
    code.each_with_index { |x, idx| code[idx] = rand(num_colors) }
    code
  end
end

class Codemaker
  include Helpers
  attr_reader :code
  
  def self.num_colors
    @@num_colors
  end

  def self.num_slots
    @@num_slots
  end

  def initialize(player_or_computer)
    @player_or_computer = player_or_computer
  end

  def create_code(num_colors, num_slots)
    if @player_or_computer == "computer"
      code = random_code(num_colors, num_slots)
      puts "The computer has generated a code."
      
    end
    if @player_or_computer == "player"
      puts "Player, please enter a code:"
      input_string = gets.chomp
      code = process_string(input_string)
    end
    @@num_colors = num_colors
    @@num_slots = num_slots
    @code = code
    
  end

  def display_code
    p @code
  end

  def give_feedback(guess)
    colored_pegs = 0
    white_pegs = 0
    code_duplicate = code.clone
    guess_duplicate = guess.clone

    code_duplicate.each_with_index do |x, idx|
      if guess[idx] == @code[idx]
        guess_duplicate[idx] = nil
        code_duplicate[idx] = nil
        colored_pegs += 1
      end
    end
    
    guess_duplicate.each_with_index do |g, idx1|
      code_duplicate.each_with_index do |c, idx2| 
        if g == c && g != nil && c != nil
          white_pegs += 1
          code_duplicate[idx2] = nil
          break
        end
      end
    end
    return [colored_pegs, white_pegs]
  end
end

class Codebreaker
  include Helpers
  def initialize(player_or_computer)
    @player_or_computer = player_or_computer
    @codes_tried = []
    @codes_scores = []
    @random_guesses = 4
  end

  def create_guess(string = "")
    if @codes_tried.length < @random_guesses
      strategy = "random"
    else
      strategy = "pointwise"
    end
    if @player_or_computer == "player"
      process_string(string)
    elsif strategy == "random" 
      puts "Making random guess"
      guess = random_code(Codemaker.num_colors, Codemaker.num_slots)
      p guess
      guess
    elsif strategy == "pointwise"
      puts "Making pointwise guess"
      maximum = @codes_scores.max
      index_of_max = @codes_scores.index(maximum)
      guess = @codes_tried[index_of_max].clone
      while @codes_tried.include?(guess)
        index = rand(Codemaker.num_slots)
        random_num = rand(Codemaker.num_colors)
        guess[rand(Codemaker.num_slots)] = rand(Codemaker.num_colors)
      end
      p guess
      guess
    end 
  end

  def add_tried_code(guess, feedback)
    @codes_tried << guess
    @codes_scores << feedback[0] + 0.25 * feedback[1]
  end

end

who_is_codemaker = "player"
num_colors = 4
num_slots = 4

codemaker = Codemaker.new(who_is_codemaker)
if who_is_codemaker == "computer"
  codebreaker = Codebreaker.new("player")
else
  codebreaker = Codebreaker.new("computer")
end

codemaker.create_code(num_colors, num_slots)
p codemaker.code

input = ""
guess = []
score = 0
turns = 12
while input != "exit" && input != "quit" && guess != codemaker.code
  if who_is_codemaker == "player"
    puts "Press enter for computer to make guess"
  end
  input = gets.chomp
  guess = codebreaker.create_guess(input)
  feedback = codemaker.give_feedback(guess)
  codebreaker.add_tried_code(guess, feedback)

  if input != "exit" && input != "quit" 
    puts "#{feedback[0]} colored pegs and #{feedback[1]} white peg" 
    score += 1
  end

  if guess == codemaker.code
    puts "You win! It took #{score} guesses so codemaker wins #{score} points."
  end
end

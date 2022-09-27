class Codemaker
  attr_accessor :code

  def initialize(player_or_computer)
    @player_or_computer = player_or_computer
  end

  def create_code(num_colors, num_slots)
    if @player_or_computer == "computer"
      code = Array.new(num_slots)
      code.each_with_index { |x, idx| code[idx] = rand(num_colors) }
    end
    @code = code
  end

  def display_code
    p @code
  end

  def give_feedback(guess)
    
  end
end

class Codebreaker
  def initialize(player_or_computer)
    @player_or_computer = player_or_computer
  end

  def create_guess
    if player_or_computer == "player"
      gets.chomp
    end 
  end
end

who_is_codemaker = "computer"
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

guess = codebreaker.create_guess

feedback = codemaker.give_feedback(guess)
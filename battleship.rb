require_relative 'board'
require_relative 'player'
require_relative 'ship'

class BattleshipGame
  attr_reader :human, :computer
  def initialize
    @human = HumanPlayer.new  
    @computer = ComputerPlayer.new 
  end 
  
  def play 
    set_boards 
    display 
    while !game_over?
      human_attacks 
      computer_attacks 
      display 
    end 
    handle_end 
  end 
  
  def handle_end
    if @human.alive?
      puts "You win! Congradulations"
    else 
      puts "You lose! Good luck next time"
    end 
  end 
  
  def set_boards 
    @human.build_ships 
    @computer.build_ships
  end 
  
  def display 
    @human.display 
    @computer.display 
  end 
  
  def human_attacks
    @computer.take_hit(@human.get_play(@computer))
  end 
  
  def computer_attacks 
    @human.take_hit(@computer.get_play(@human))
  end 
  
  def game_over?
    @human.board.won? || @computer.board.won? 
  end 
  
  def play_turn 
    pos = player.get_play 
    attack(pos)
  end 
end


if __FILE__ == $PROGRAM_NAME
  game = BattleshipGame.new
  game.play 
end

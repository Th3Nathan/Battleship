require_relative 'board'
require_relative 'player'
require_relative 'ship'

class HumanPlayer
  
  attr_accessor :board, :ships
  
  def initialize
    @board = Board.new
    @ships = []
  end 
  
  def alive?
    @ships.any? {|ship| ship.afloat?}
  end 
  
  def take_hit(position)
    @board.take_hit(position)
  end 
  
  def remaining_ships
    @ships.count {|ship| ship.afloat?}
  end 
  
  def ships_with_streak
    @ships.select {|ship| ship.two_or_more_hits?}
  end 
  
  def weakened_ships
    @ships.select {|ship| ship.weakened?}
  end 
  
  def display 
    puts "Your board:"
    @board.display("S") 
    puts "You have #{remaining_ships}/5 ships left"    
  end 
  
  def build_ship(ship_type_index)
    while true 
      @board.display("S")
      ship = Ship.make_ship(@board, ship_type_index)
      if ship.valid_placement? 
        ship.draw_ship 
        @ships << ship 
        puts "Ship successfully drawn."
        break
      else 
        puts "Invalid placement, try again!"
        next 
      end 
    end 
  end 
  
  def build_ships
    puts "Set up your board"
    (1..5).each {|ship_index| build_ship(ship_index)}
    puts "All your ships are built."
  end   
  
  def get_play(computer_player)
    while true 
      puts "What row would you like to attack"
      row = gets.chomp
      puts "What column would you like to attack"
      col = gets.chomp
      move = [row.to_i, col.to_i]
      return move if computer_player.board.valid_move?(move)
    end 
  end 
end


class ComputerPlayer
  
  attr_accessor :board, :ships 
  
  def initialize 
    @board = Board.new 
    @ships = []
  end 
  
  def get_play(human_player)
    streak_move = continue_streak_move(human_player)
      return streak_move unless streak_move == nil 
    probe_move = adjacent_probe_move(human_player)
      return probe_move unless probe_move == nil 
    random_move 
  end 
  
  def random_move
    while true 
      row = rand(0..9)
      col = rand(0..9)
      move = [row, col]
      return move if (row.even? && col.odd?) || (row.odd? && col.even?)
    end 
  end 
  
  def continue_streak_move(human_player)
    ships = human_player.ships_with_streak
    ships.each do |ship|
      hit_squares = ship.ship_squares.select {|square| human_player.board[square] == :x}
      if ship.orientation == "horizontal"
        potential_right_column = hit_squares[-1][-1] + 1 
        potential_left_column = hit_squares[0][-1] - 1
        if human_player.board.valid_move?([ship.row, potential_right_column])
          return [ship.row, potential_right_column]
        elsif human_player.board.valid_move?([ship.row, potential_left_column])
          return [ship.row, potential_left_column]
        end 
      else 
        potential_upper_row = hit_squares[0][0] - 1
        potential_lower_row = hit_squares[-1][0] + 1 
        if human_player.board.valid_move?([potential_upper_row, ship.column])
          return [potential_upper_row, ship.column]
        elsif human_player.board.valid_move?([potential_lower_row, ship.column])
          return [potential_lower_row, ship.column]
        end         
      end 
    end 
    nil
  end   
  
  def adjacent_probe_move(human_player) 
    ship = human_player.weakened_ships[0] 
    return nil if ship == nil 
    hit_square = ship.ship_squares.select {|square| human_player.board[square] == :x}
    row = hit_square[0][0]
    col = hit_square[0][1]
    up = [row - 1, col]
    right = [row, col + 1]
    down = [row + 1, col]
    left = [row, col - 1]
    [up, right, down, left].each do |potential_move|
      if human_player.board.valid_move?(potential_move)
        return potential_move 
      end 
    end 
    nil 
  end 
    
  def take_hit(position)
    position_value = @board[position]
    @board.take_hit(position)
    if position_value.is_a? Integer
      hit_ship = @ships.select {|ship| ship.type == position_value}[0]
      puts "You hit a #{hit_ship.name}"
      if !hit_ship.afloat?
        puts "You sunk the #{hit_ship.name}"
      end 
    end 
  end   
  
  def remaining_ships
    @ships.count {|ship| ship.afloat?}
  end   
  
  def display 
    puts "Here is the computer's board"
    @board.display(" ")
    puts "The computer has #{remaining_ships}/5 ships left"    
  end 
  
  def build_ships
    (1..5).each {|squares| build_ship(squares)}
    @board.display("S") 
  end 
  
  def build_ship(length)
    while true 
      row = rand(0..10)
      col = rand(0..10)
      orientation = rand.round == 0 ? "horizontal" : "vertical"
      ship = Ship.new(row, col, orientation, length, @board )
      if ship.valid_placement?
        ship.draw_ship
        @ships << ship 
        break
      else 
        next
      end 
    end 
  end
end 


class Ship
  
  attr_accessor :name, :row, :column, :orientation, :type
  
  SHIPS = {1 => {length: 2, name: "Destroyer" },
           2 => {length: 3, name: "Submarine" },
           3 => {length: 3, name: "Cruiser" },
           4 => {length: 4, name: "Battleship" },
           5 => {length: 5, name: "Carrier" },
          }
          
  def initialize(row, column, orientation, type, own_board)
    @row = row 
    @column = column 
    @orientation = orientation 
    @squares = SHIPS[type][:length]
    @own_board = own_board 
    @name = SHIPS[type][:name]
    @type = type
  end 
   
  def self.make_ship(board, type)
      puts "Make a #{SHIPS[type][:name]}, which takes #{SHIPS[type][:length]} spaces"
      puts "Enter top row of the #{SHIPS[type][:name]}"
    row = gets.chomp.to_i
      puts "Enter leftmost column the #{SHIPS[type][:name]}"
    column = gets.chomp.to_i
      puts "Enter horizontal or vertical for orientation"
    orient = gets.chomp 
    
    Ship.new(row, column, orient, type, board)
  end 

  def self.name_from_index(index)
    SHIPS[index][:name]
  end 
  
  def afloat?
    ship_squares.any? {|square| @own_board[square].is_a? Integer}
  end 
  
  def weakened?
    afloat? && been_hit?
  end 
  
  def two_or_more_hits? 
    weakened? && ship_squares.count {|square| @own_board[square] == :x} > 1 
  end 
 
  def been_hit?
    ship_squares.any? {|square| @own_board[square] == :x}
  end 
 
  def ship_squares
    positions = []
    if @orientation == "horizontal"
      (@column...@column + @squares).each do |col|
        positions << [@row, col]
      end 
    else 
      (@row...@row + @squares).each do |row|
        positions << [row, @column]
      end 
    end 
    positions 
  end 
  
  def draw_ship
    ship_squares.each do |position|
      @own_board[position] = @type
    end 
  end 
  
  def o_to_nine?(int)
    (0..9).include?(int)
  end 
  
  def valid_placement?
    return false if !o_to_nine?(@row) || !o_to_nine?(@column)
    if @orientation == "horizontal"
      max_bound = @column + @squares - 1
      return false if !o_to_nine?(max_bound)
    else 
      max_bound = @row + @squares - 1
      return false if !o_to_nine?(max_bound)
    end 
    ship_squares.each do |square|
      return false if @own_board[square] == @type 
    end 
    true
  end 
end 

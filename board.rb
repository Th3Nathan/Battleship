
class Board
  DISPLAY = {nil => " ", :s => "P", :x => "X", :~ => "~" }
  attr_accessor :grid 
  def initialize(grid = Board.default_grid)
    @grid = grid 
  end 
  
  def self.default_grid
    Array.new(10) {Array.new(10)}
  end 
  
  def valid_move?(position)
    return false if position.length != 2 
    return false if position.any? {|el| !el.is_a? Integer}
    row = position[0]
    col = position[1]
    return false if !(0..9).include?(row) || !(0..9).include?(col)   
    return false if self[position] == :x 
    return false if self[position] == :~
    true 
  end 
  
  def take_hit(position)
    self[position] == nil ? self[position] = :~ : self[position] = :x
  end 
  
  def [](pos)
    row, col = pos 
    @grid[row][col]
  end 
  
  def []=(pos, val)
    row, col = pos 
    @grid[row][col] = val
  end 
  
  def rows
    grid.length 
  end 
  
  def columns 
    grid[0].length 
  end 
 
  def won? 
    grid.flatten.none? {|square| square.is_a? Integer}
  end 
  
  def put_cols 
    puts " " + (0...columns).map{|x| x}.join(" ")
  end 
  
  def display(ship_representation_string)
    put_cols
    grid.each.with_index do |row, i|
      print i 
      row = row.map do |sym| 
        if sym.is_a? Integer 
          ship_representation_string
        else 
          DISPLAY[sym]
        end
      end
      puts row.join(" ")
    end 
  end   
end 

class Rover
  @@id = 0
  attr_reader :x, :y, :direction, :id, :name2
  def initialize(x = 0, y = 0, direction = 'center', name2 = @rover_name)
    @x = x
    @y = y
    @direction = direction
    @id = @@id
    @name2 = name2
    @@id += 1
  end
  def read_instruction
    puts 'If you wanna go forward press \'w\', to move to the right \'d\', to move to the left \'a\', and backwards \'s\'.'
    @move = gets.strip.downcase
    puts 'Also which way do you wanna look? \'r\' for right, \'l\' for left.'
    @gotten = gets.strip.downcase
  end
  def move
    if @move == "w"
      @y += 1
    elsif @move == 'd'
      @x += 1
    elsif (@move == 'a' && (@x > 0))
      @x -= 1
    elsif (@move == 's' && (@y > 0))
      @y -= 1
    else
      puts 'Sorry that isn\'t a valid key at the moment'
    end
  end
  def direction
    if @gotten == 'r'
      @direction = 'right'
    elsif @gotten == 'l'
      @direction = 'left'
    else
      puts 'Not a real direction'
    end
  end
end

class MissionControl < Rover
  attr_reader :name
  def initialize(name = 'Houston')
    @name = name
  end
  def create_rover
    puts 'What do you want your rover to be called?'
    @rover_name = gets.chomp
    @rover_name = Rover.new
  end
end

class Plateau < MissionControl
  attr_reader :name
  def initialize(name1 = 'Plateau')
    @name1 = name1
  end
  def area
    rovers = []
    rovers << @rover_name
    rovers.each do |x|
      puts "The rover is at #{rovers[x].x} x, and #{rovers[x].y} y"
    end
  end
end

houston = MissionControl.new

plateau = Plateau.new

houston.create_rover

houston.read_instruction

plateau.area

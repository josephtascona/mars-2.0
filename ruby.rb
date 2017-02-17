class Rover
  attr_reader :name, :x, :y, :direction, :coordinates
  attr_accessor :instructions #MissionControl will write instructions to the Rover
  #Initialize these states
  def initialize(name, x=0, y=0, direction="N", plateau) #input plateau into initialize!
    @name = name
    @x = x
    @y = y
    @direction = direction
    @plateau = plateau
  end

  def coordinates
    @coordinates = [@x, @y]
  end

  def perform_instructions(occupied_coordinates)
    pre_instruction = [x = @x, y = @y]
    post_instruction = []
    @instructions.each { |letter|
      if letter == "L" || letter == "R"
        turn(letter)
      elsif letter == "M"
        move
      end
      post_instruction = [@x, @y]
    }
    if occupied_coordinates.include?(post_instruction)
      puts "ERROR: Space is occupied by another rover."
      @x = pre_instruction[0]
      @y = pre_instruction[1]
    else
      puts "Move Successful."
      @x = post_instruction[0]
      @y = post_instruction[1]
    end
  end

  def move
    case @direction
    when "N"
      @y += 1 unless @y >= @plateau.plateau_y
    when "E"
      @x += 1 unless @x >= @plateau.plateau_x
    when "S"
      @y -= 1 unless @y <= 0
    when "W"
      @x -= 1 unless @x <= 0
    end
  end

  def turn(spin)
    if spin == "L"
      case @direction
      when "N"
        @direction = "W"
      when "W"
        @direction = "S"
      when "S"
        @direction = "E"
      when "E"
        @direction = "N"
      end
    elsif spin == "R"
      case @direction
      when "N"
        @direction = "E"
      when "E"
        @direction = "S"
      when "S"
        @direction = "W"
      when "W"
        @direction = "N"
      end
    end
  end
end

class MissionControl
  def initialize(plateau, active_rovers) # <= MC needs to know where it is, so initialize with plateau object!
    @plateau = plateau
    @active_rovers = active_rovers
  end

  def get_occupied_coordinates
    set = []
    @active_rovers.each { |rover|
      set.push(rover.coordinates)
    }
    set
  end

  # Mission Control sends instructions to target rover.
  def instruct(data, target_rover)
    puts "Sending instructions #{data} to #{target_rover.name}..."
    data = data.chars
    target_rover.instructions = data
    target_rover.perform_instructions(get_occupied_coordinates) # MC sends occupied coordinates to Rover via return value of the get_occupied_coordinates method.
    puts "Coordinates for #{target_rover.name} are now #{target_rover.coordinates}"
  end

  # Mission Control reports on status of all rovers or individual rovers.
  def report(data)
    if data.is_a?(Array)
      puts "There are currently #{data.length} rover(s) on the plateau."
      data.each { |rover|
        puts "Reporting on #{rover.name}: #{rover.x} #{rover.y} #{rover.direction}"
      }
    elsif data.is_a?(Object)
      puts "Reporting on #{data.name}: #{data.x} #{data.y} #{data.direction}"
    end
  end
end

class Plateau
  attr_reader :plateau_x, :plateau_y

  def initialize
    puts "Please input plateau size (ex: 5 5): "
    input = gets.chomp
    inputs = input.split(' ').map! { |i|
      i.to_i
    }
    @plateau_x = inputs[0]
    @plateau_y = inputs[1]
  end
end

# Practice Inputs:
# Initializing Rovers and Mission Control

plateau = Plateau.new

rover1 = Rover.new("Rover 1", 1, 2, "N", plateau)
rover2 = Rover.new("Rover 2", 3, 3, "E", plateau)
rover3 = Rover.new("Rover 3", 3, 4, "S", plateau)
team = [rover1, rover2, rover3]
mc = MissionControl.new(plateau, team)

# MissionControl Commands
mc.instruct("LMLMLMLMM", rover1)
mc.instruct("MMRMMRMRRM", rover2)
mc.instruct("MLMRMM", rover3)
mc.report(team) # All Rovers

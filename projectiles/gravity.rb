
# Denna klassen representerar gravitationen som påverkar spelaren.
class NewtonGravity
  attr_accessor :mass, :x, :y
  def initialize(x:, y:)
    @y = y
    @x = x
    @mass = 10**7
    @g = 9.81
    @inner_circle = Circle.new(
      x: @x,
      y: @y,
      radius: 8,
      sectors: 32,
      color: 'black',
      z: 30
    )
  end
  def get_x
    return @x
  end

  def get_y
    return @y
  end

  # Denna funktion räknar ut kraften som påverkar spelaren.
  def affect(playerX, playerY, playerMass)
    distance_between_closest_gravity = Math.sqrt((@x-playerX)**2+(@y-playerY)**2)

    force_total = calculate_force(@mass, playerMass, distance_between_closest_gravity).abs()

    angle_between = Math.atan2(@y-playerY, @x-playerX)

    force_x = Math.cos(angle_between)*force_total
    force_y = Math.sin(angle_between)*force_total

    return [force_x*10, force_y*10]
  end
end


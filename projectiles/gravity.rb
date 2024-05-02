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
end


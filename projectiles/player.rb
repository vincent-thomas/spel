
class Player
  attr_accessor :x, :y, :mass
  def initialize(x:, y:, friction:)
    @color = 'red'
    @mass = 10000
    @y = y
    @x = x
    @delta_x = 0
    @delta_y = 0
    @friction = friction
    @inner_circle = Circle.new(
      x: @x,
      y: @y,
      radius: 8,
      sectors: 32,
      color: @color,
      z: 30
    )
  end

  def move(delta_x, delta_y)
    @delta_x = delta_x
    @delta_y = delta_y
  end
  def affect(delta_x, delta_y)
    @delta_x += delta_x
    @delta_y += delta_y
  end


  def render_inner_circle
    @inner_circle.x = @x + @delta_x
    @inner_circle.y = @y + @delta_y
    @inner_circle.color = @color
  end

  def update_delta_for_each_render()
    @delta_x = @delta_x * @friction
    @delta_y = @delta_y * @friction
  end

  def set_color(color)
    @color = color
  end

  def render()
    @x += @delta_x
    @y += @delta_y

    self.update_delta_for_each_render()
    self.render_inner_circle()
  end

  def derender
    @inner_circle.remove()
  end
end


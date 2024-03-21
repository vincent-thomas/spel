require "ruby2d"

set background: "green"



you = Circle.new(
  x: 100,
  y: 100,
  radius: 40,
  sectors: 32,
  color: "white",
  z: 30
)

line = Line.new(
  x1: 125, y1: 100,
  x2: 350, y2: 400,
  width: 25,
  color: 'red',
  z: 20
)

line.remove


draggable_x_value = 0
draggable_y_value = 0

pressed_down_this_render = false

on :mouse do |event|
  if event.type == :down
    pressed_down_this_render = true
  elsif event.type == :up
    pressed_down_this_render = false
    line.remove
  end

  if pressed_down_this_render
    if event.x < you.x
      draggable_x_value = line.x1 - you.x
      line.x1 = event.x
    end

    line.x2 = you.x

    line.y1 = event.y
    line.y2 = you.y
    line.add

    draggable_y_value = line.y1 - you.y

    p "X: " + draggable_x_value.to_s
    p "Y: " + draggable_y_value.to_s
  end
end

show

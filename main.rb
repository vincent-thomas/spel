require "ruby2d"
require_relative "./projectiles/player"
require_relative "./projectiles/gravity"

set background: "green"

def change_index(index, arr_len)
  index += 1
  if index > arr_len
    index = 0
  end
  return index
end


def calculate_force(m1, m2, r)
  r2 = r**2
  stora_G = 6.67*10**-11
  return stora_G*((m1*m2)/r2)
end

line = Line.new(
  x1: 125, y1: 100,
  x2: 350, y2: 400,
  width: 25,
  color: 'red',
  z: 20
)

line.remove

gravity = NewtonGravity.new(x: 200, y: 200)

players = []

players.push(Player.new(x: 150, y: 150, friction: 0.95))

index = 0

text = Text.new(
  "#{index+1} Player turn",
  x: 50, y: 50,
  style: 'bold',
  size: 20,
  color: 'black',
  rotate: 0,
  z: 10
)

update do
  players.each do |player|
    distance_between_closest_gravity = Math.sqrt((player.x-gravity.x)**2+(player.y-gravity.y)**2)
    if distance_between_closest_gravity < 80
      force_total = calculate_force(gravity.mass, player.mass, distance_between_closest_gravity).abs()

      angle_between = Math.atan2(player.x-gravity.x, player.y-gravity.y)-1.5708

      force_x = Math.cos(angle_between)*force_total
      force_y = Math.sin(angle_between)*force_total
      player.affect(force_x* 10,force_y*10)
    end

    player.render()
  end
end


predict_drag = Circle.new(
      x: 0,
      y: 0,
      radius: 4,
      sectors: 32,
      color: "white",
      z: 30
    )

predict_drag.remove()

base_drag_x = nil
base_drag_y = nil

on :mouse do |event|
  if event.type == :down && !(base_drag_x && base_drag_y)
    base_drag_x = event.x
    base_drag_y = event.y
  end

  if event.type == :move && base_drag_x && base_drag_y

    minus_draggable_point_x = players[index].x - event.x
    minus_draggable_point_y = players[index].y - event.y

    predict_drag.add

    predict_drag.x = minus_draggable_point_x + base_drag_x
    predict_drag.y = minus_draggable_point_y + base_drag_y
  end

  if event.type == :up

    predict_drag.remove()

    dragged_x = base_drag_x - event.x
    dragged_y = base_drag_y - event.y

    if dragged_x != 0 && dragged_y != 0
      players[index].move(dragged_x / 10, dragged_y / 10)

      players[index].set_color('red')

      index = change_index(index, players.length - 1)
      players[index].set_color('blue')

      text.text = "#{index+1} Player turn"

      base_drag_x = nil
      base_drag_y = nil
    end
  end
end

show

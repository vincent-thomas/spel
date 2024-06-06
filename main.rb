require "ruby2d"
# require_relative "./projectiles/player"
require_relative "./projectiles/gravity"
require_relative "./scenarios/playable"
require_relative "./scenarios/has_won"

set background: "green"


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

line.remove()
gravity = NewtonGravity.new(x: 200, y: 200)

scenario = PlayableScenario.new(number_players: 4)

has_won = false
has_won_rendered = false

update do
  if !has_won
    scenario.render(gravity)
  elsif !has_won_rendered
    scenario.derender()
    HasWon.new()
  end
#  players.each do |player|
#    distance_between_closest_gravity = Math.sqrt((gravity.x-player.x)**2+(gravity.y-player.y)**2)

    # Bara om distans är tillräckligt nära
#    if distance_between_closest_gravity < 80 && distance_between_closest_gravity > 10
#      x, y = gravity.affect(player.x, player.y, player.mass)
#      player.affect(x, y)
#    end

    # Denna körs alltid
#    player.render()
#  end
end

on :mouse do |event|
  if !has_won
    scenario.on_input(event)
  end
end

show

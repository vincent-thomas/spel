require "ruby2d"
require_relative "./projectiles/gravity"
require_relative "./scenarios/playable"
require_relative "./scenarios/has_won"

# Sätter bakgrunden till spelet
set background: "green"

# Function för att beräkna gravitationskraften mellan 2 object.
# Parametrar:
#   int m1: massa 1
#   int m2: massa 2
#   r: distans mellan m1 och m2s radier.
# Returnar
#   int kraften (Newton)
def calculate_force(m1, m2, r)
  r2 = r**2
  stora_G = 6.67*10**-11
  return stora_G*((m1*m2)/r2)
end

# Linje för att förhandsvisa vart man har dragit
line = Line.new(
  x1: 125, y1: 100,
  x2: 350, y2: 400,
  width: 25,
  color: 'red',
  z: 20
)

# Vill inte att den ska synas som default.
line.remove()

# Gravitationsobject vid dessa kordinater.
gravity = NewtonGravity.new(x: 200, y: 200)

# Ett "scenario". De ska vara ett speciellt 'state' i programmet
scenario = PlayableScenario.new(number_players: 4)

# Bestämmer vilket state.
has_won = false

# Ser till så att statet inte byts varje render efter man har vunnit
has_won_rendered = false

# Game loop
update do
  # Om inte man har vunnit, fortsätt rendera spel scenariot, om man har vunnit derendera spelscenariot och börja rendera har vunnit scenariot
  if !has_won
    scenario.render(gravity)
  elsif !has_won_rendered
    scenario.derender()
    HasWon.new()
  end
end

# Mouse event
on :mouse do |event|
  # Registrerar event listener för relevant scenario
  if !has_won
    scenario.on_input(event)
  end
end

show

require_relative "../projectiles/player.rb"

# Hjälp funktion som returnar en ny spelare.
def create_player()
  return Player.new(x: rand(50..200), y: rand(50..200), friction: 0.95)

end


# Hjälp funktion som beräknar rätt index för spelarens tur.
def change_index(index, arr_len)
  index += 1
  if index > arr_len
    index = 0
  end
  return index
end

# Klass som representerar ett spelbart spel. Detta är en typ av wrapper som bestämmer hur spelet går till
class PlayableScenario
  def initialize(number_players:)
    @active_player = 0
    @text = Text.new(
      "#{@active_player+1} player turn",
      x: 50, y: 50,
      style: 'bold',
      size: 20,
      color: 'black',
      rotate: 0,
      z: 10
    )
    @players = []
    @base_drag_x = nil
    @base_drag_y = nil
    @predict_drag = Circle.new(
      x: 0,
      y: 0,
      radius: 4,
      sectors: 32,
      color: "white",
      z: 30
    )

    @predict_drag.remove()


    # Skapa spelare i spelet och pusha det till en array som man sedan kan loopa igenom och rendera.
    number_players.times do |i|
      player = create_player()

      @players.push(player)
    end
  end

  def render(maybe_closest_gravity)

    gravity = maybe_closest_gravity

    @players.each do |player|
      # Rendera varje spelare
      @players[@active_player].render()
      if gravity == nil
        return
      end
      distance_between_closest_gravity = Math.sqrt((gravity.get_x()-player.x)**2+(gravity.get_y()-player.y)**2)
      
      # Om man är tillräckligt nära ett gravitationsfält påverka spelaren med korrekt kraft.
      if distance_between_closest_gravity < 80 && distance_between_closest_gravity > 10

        force_total = calculate_force(gravity.mass, player.mass, distance_between_closest_gravity).abs()

        angle_between = Math.atan2(gravity.y-player.y, gravity.x-player.x)

        force_x = Math.cos(angle_between)*force_total
        force_y = Math.sin(angle_between)*force_total

        player.affect(force_x*10,force_y*10)
      end
    end
  end

  # Derendera alla spelare.
  def derender()
    @players.each do |player|
      player.derender()
    end
  end

  # Hantera input från användaren. Kan senare registreras.
  def on_input(event)
    if event.type == :down && !(@base_drag_x && @base_drag_y)
      @base_drag_x = event.x
      @base_drag_y = event.y
    end

    # Updatera förhandsvisningen av hur man drar.
    if event.type == :move && @base_drag_x && @base_drag_y

      minus_draggable_point_x = @players[@active_player].x - event.x
      minus_draggable_point_y = @players[@active_player].y - event.y

      @predict_drag.add

      @predict_drag.x = minus_draggable_point_x + @base_drag_x
      @predict_drag.y = minus_draggable_point_y + @base_drag_y
    end

    if event.type == :up

      # Dölj den förutsägande cirkeln.
      @predict_drag.remove()

      dragged_x = @base_drag_x - event.x
      dragged_y = @base_drag_y - event.y

      if dragged_x != 0 && dragged_y != 0

        # Updatera spelarens färg som nu har gjort sin tur.
        @players[@active_player].set_color('red')

        @players[@active_player].move(dragged_x / 10, dragged_y / 10)

        @active_player = change_index(@active_player, @players.length - 1)
        # Sätt aktiv färg på nästa spelare som det nu är dens tur.
        @players[@active_player].set_color('blue')

        # Updatera texten för att visa vems tur det är.
        @text.text = "#{@active_player+1} player turn"

        @base_drag_x = nil
        @base_drag_y = nil
      end
    end
  end
end

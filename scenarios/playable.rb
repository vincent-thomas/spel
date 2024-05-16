require_relative "../projectiles/player.rb"


def create_player()
  return Player.new(x: rand(50..200), y: rand(50..200), friction: 0.95)

end

def change_index(index, arr_len)
  index += 1
  if index > arr_len
    index = 0
  end
  return index
end


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



    number_players.times do |i|
      player = create_player()

      @players.push(player)
    end
  end

  def render(maybe_closest_gravity)

    gravity = maybe_closest_gravity

    @players.each do |player|
      @players[@active_player].render()

      if gravity == nil
        return
      end
      distance_between_closest_gravity = Math.sqrt((gravity.get_x()-player.x)**2+(gravity.get_y()-player.y)**2)

      if distance_between_closest_gravity < 80 && distance_between_closest_gravity > 10

        force_total = calculate_force(gravity.mass, player.mass, distance_between_closest_gravity).abs()

        angle_between = Math.atan2(gravity.y-player.y, gravity.x-player.x)

        force_x = Math.cos(angle_between)*force_total
        force_y = Math.sin(angle_between)*force_total

        player.affect(force_x*10,force_y*10)
      end
    end
  end

  def derender()
    @players.each do |player|
      player.derender()
    end
  end

  def on_input(event)
    if event.type == :down && !(@base_drag_x && @base_drag_y)
      @base_drag_x = event.x
      @base_drag_y = event.y
    end

    if event.type == :move && @base_drag_x && @base_drag_y

      minus_draggable_point_x = @players[@active_player].x - event.x
      minus_draggable_point_y = @players[@active_player].y - event.y

      @predict_drag.add

      @predict_drag.x = minus_draggable_point_x + @base_drag_x
      @predict_drag.y = minus_draggable_point_y + @base_drag_y
    end

    if event.type == :up

      @predict_drag.remove()

      dragged_x = @base_drag_x - event.x
      dragged_y = @base_drag_y - event.y

      if dragged_x != 0 && dragged_y != 0

        puts @active_player

        @players[@active_player].set_color('red')

        puts "before #{@active_player}"

        @players[@active_player].move(dragged_x / 10, dragged_y / 10)

        @active_player = change_index(@active_player, @players.length - 1)
        puts "after #{@active_player}\n---"
        @players[@active_player].set_color('blue')

        @text.text = "#{@active_player+1} player turn"

        @base_drag_x = nil
        @base_drag_y = nil
      end
    end
  end
end

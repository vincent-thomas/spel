require "ruby2d"

# HasWon klassen är en klass som representerar en scen där spelaren har vunnit.
class HasWon

  def initialize
    set background: 'black'
    @title_text = Text.new(x: 50, y: 50, text: "You have won")
  end
end

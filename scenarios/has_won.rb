require "ruby2d"


class HasWon

  def initialize
    set background: 'black'
    @title_text = Text.new(x: 50, y: 50, text: "You have won")
  end
end

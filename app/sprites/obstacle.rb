class Obstacle < Joybox::Core::Sprite

  def initialize(opts={})
    super file_name: 'Images/dirt.png', position: opts[:position], alive: true
  end

  def move(x, y)
    self.run_action Move.to position: [x, y], duration: 10
  end

end

class AsteroidSprite < Joybox::Core::Sprite

  attr_accessor :end_position

  MaximumSize = 96.0

  def initialize
    @random = Random.new

    kind = @random.rand(1..4)
    file_name = "asteroid_#{kind}.png"

    screen_side = @random.rand(1..4)
    start_position = initial_position(screen_side)
    @end_position = final_position(screen_side)

    super file_name: file_name, position: start_position
  end

  def initial_position(screen_side)
    case screen_side
    when 1
      [-MaximumSize, @random.rand(1..Screen.height)]
    when 2
      [@random.rand(1..Screen.width), Screen.height + MaximumSize]
    when 3
      [Screen.width + MaximumSize, @random.rand(1..Screen.height)]
    else
      [@random.rand(1..Screen.width), -MaximumSize]
    end
  end

  def final_position(screen_side)
    case screen_side
    when 1
      [Screen.width + MaximumSize, @random.rand(1..Screen.height)]
    when 2
      [@random.rand(1..Screen.width), -MaximumSize]
    when 3
      [-MaximumSize, @random.rand(1..Screen.height)]
    else
      [@random.rand(1..Screen.width), Screen.height + MaximumSize]
    end
  end

end
class Obstacle < Joybox::Core::Sprite

  attr_accessor :end_position

  MaximumSize = 96.0

  def initialize(opts={})
    @random = Random.new
    @random_height = @random.rand(1..Screen.height)
    start_position = initial_position
    @end_position = final_position

    super file_name: 'Images/dirt.png', position: start_position, alive: true
  end

  def move(x, y)
    self.run_action Move.to position: [x, y], duration: 10
  end

  def initial_position
    [Screen.width + MaximumSize, @random_height]
  end

  def final_position
    [-MaximumSize, @random_height]
  end

end

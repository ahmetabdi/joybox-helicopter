class Orb < Joybox::Core::Sprite

  def initialize(opts={})
    super file_name: 'Images/orb.png', position: [Screen.half_width / 2, 25], alive: true
  end

end

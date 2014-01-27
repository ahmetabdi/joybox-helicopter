class Background < Joybox::Core::Sprite

  def initialize(opts={})
    super file_name: 'Images/background.png', position: Screen.center
  end

end

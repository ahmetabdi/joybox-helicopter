class GameLayer < Joybox::Core::Layer
  scene

  def on_enter
    init_shared

    schedule_update do |dt|
      @timer += 1
      check_within_bounds(@orb)
      controls
      puts "#{@timer}"
      countdown
    end
  end

  def init_shared
    background = Sprite.new file_name: 'background.jpg', position: Screen.center
    self << background
    @orb = Sprite.new file_name: 'orb.png', position: [Screen.half_width, 25], alive: true
    self << @orb
    @timer = 0
    @held_down = false
    handle_touches
    load_tiles
  end

  def countdown
    case @timer
    when 50
      @three = Sprite.new file_name: '3.png', position: Screen.center
      self << @three
    when 100
      self.removeChild(@three)
      @two = Sprite.new file_name: '2.png', position: Screen.center
      self << @two
    when 150
      self.removeChild(@two)
      @one = Sprite.new file_name: '1.png', position: Screen.center
      self << @one
    when 200
      self.removeChild(@one)
      @lets_do_this = Sprite.new file_name: 'lets_do_this.png', position: Screen.center
      self << @lets_do_this
    when 250
      self.removeChild(@lets_do_this)
    end
    #2
    #1
    #lets do this
  end

  def load_tiles
    @tiles = 2.times.map do |row|
      25.times.map do |column|
        Sprite.new file_name: 'dirt.png', position: [
          column * 32 + 16,
          row * (Screen.height - 48) + 16
        ]
      end
    end.flatten

    @tiles.each { |t| self << t }
  end

  def controls
    if @held_down
      @orb.position = [@orb.position.x, @orb.position.y + 5]
    else
      @orb.position = [@orb.position.x, @orb.position.y - 5]
    end
  end

  def check_within_bounds(object)
    if object.position.y > Screen.height - 50
      object.position = [object.position.x, Screen.height - 50]
    elsif object.position.y < 25
      object.position = [object.position.x, 25]
    end
  end

  def handle_touches

    on_touches_began do |touches, event|
      puts "Going Up"
      @held_down = true
    end

    on_touches_ended do |touches, event|
      puts "Going Down"
      @held_down = false
    end

  end

end
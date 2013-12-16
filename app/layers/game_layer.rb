class GameLayer < Joybox::Core::Layer
  MaximumObjects = 10

  scene

  def on_enter
    init_shared
    init_menu
    init_score

    schedule_update do |dt|
      @timer += 1
      check_within_bounds(@orb)
      controls
      puts "#{@timer}"
      @score.setString "#{@timer}"
    end
  end

  def init_shared
    background = Sprite.new file_name: 'Images/background.jpg', position: Screen.center
    self << background
    @orb = Sprite.new file_name: 'Images/orb.png', position: [Screen.half_width, 25], alive: true
    self << @orb
    @timer = 0
    @held_down = false
    handle_touches
    load_tiles
  end

  def init_score
    @score = CCLabelBMFont.labelWithString "0", fntFile: "Fonts/bitmapFont.fnt"
    self << @score
    @score.position = [ Screen.half_width, Screen.height - 32]
  end

  def init_menu
    MenuLabel.default_font_size = 18

    reset_menu_item = MenuLabel.new text: 'Reset' do |menu_item|
      director.replace_scene(GameLayer.scene)
    end

    menu = Menu.new items: [reset_menu_item], position: [Screen.width / 2, 15]
    menu.align_items_vertically

    self.add_child(menu, z: 1)
  end

  def launch_obstacles
    @obstacles ||= Array.new

    if @obstacles.size <= MaximumObjects
      missing_asteroids = MaximumObjects - @obstacles.size

      missing_asteroids.times do
        asteroid = AsteroidSprite.new

        move_action = Move.to position: asteroid.end_position, duration: 4.0
        callback_action = Callback.with { |asteroid| @obstacles.delete asteroid }
        asteroid.run_action Sequence.with actions: [move_action, callback_action]

        self << asteroid
        @obstacles << asteroid
      end
    end
  end

  def check_for_collisions
    @obstacles.each do |asteroid|
      if CGRectIntersectsRect(asteroid.bounding_box, @rocket.bounding_box)
        @obstacles.each(&:stop_all_actions)

        @rocket[:alive] = false
        @rocket.run_action Blink.with times: 20, duration: 3.0
        break
      end
    end
  end

  def load_tiles
    @tiles = 2.times.map do |row|
      100.times.map do |column|
        Sprite.new file_name: 'Images/dirt.png', position: [
          column * 16 + 16,
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
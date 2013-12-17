class GameLayer < Joybox::Core::Layer
  MaximumObstacles = 10

  scene

  def on_enter
    init_shared
    init_menu
    init_score

    schedule_update do |dt|
      @timer += 1

      controls
      #puts "#{@timer}"
      @score.setString "#{@timer}" unless @orb[:alive] == false
      if (@timer % [100, 68, 86, 95].sample == 0)
        launch_obstacles
      end
      check_for_collisions if @orb[:alive]
      check_within_bounds(@orb)
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
    launch_obstacles
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

  def launch_obstacles #Hard Mode
    @obstacles ||= Array.new

    if @obstacles.size <= MaximumObstacles
      missing_obstacles = MaximumObstacles - @obstacles.size

      missing_obstacles.times do
        obstacle = Obstacle.new

        move_action = Move.to position: obstacle.end_position, duration: 4.0
        callback_action = Callback.with { |obstacle| @obstacles.delete obstacle }
        obstacle.run_action Sequence.with actions: [move_action, callback_action]

        self << obstacle
        @obstacles << obstacle
      end
    end
  end

  def check_for_collisions
    @obstacles.each do |obstacle|
      check_out_of_screen(obstacle)
      if CGRectIntersectsRect(obstacle.bounding_box, @orb.bounding_box)
        @obstacles.each(&:stop_all_actions)

        @orb[:alive] = false
        @orb.stop_all_actions
        @orb.run_action Blink.with times: 20, duration: 3.0
        break
      end
    end
  end

  # def load_tiles
  #   @tiles = 2.times.map do |row|
  #     100.times.map do |column|
  #       Sprite.new file_name: 'Images/dirt.png', position: [
  #         column * 16 + 16,
  #         row * (Screen.height - 48) + 16
  #       ]
  #     end
  #   end.flatten

  #   @tiles.each { |t| self << t }
  # end

  def controls
    if @orb[:alive]
      if @held_down
        @orb.position = [@orb.position.x, @orb.position.y + 3]
      else
        @orb.position = [@orb.position.x, @orb.position.y - 3]
      end
    end
  end

  def check_within_bounds(object)
    if object.position.y > Screen.height - 50
      object.position = [object.position.x, Screen.height - 50]
    elsif object.position.y < 25
      object.position = [object.position.x, 25]
    end
  end

  def check_out_of_screen(object)
    if object.position.x < 0
      @obstacles.delete(object)
      self.removeChild(object)
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
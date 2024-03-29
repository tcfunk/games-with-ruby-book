require 'ruby-prof' if ENV['ENABLE_PROFILING']

class PlayState < GameState
    attr_accessor :update_interval
    
    def initialize
        @map = Map.new
        @camera = Camera.new
        @object_pool = ObjectPool.new(@map)
        @tank = Tank.new(@object_pool, PlayerInput.new(@camera))
        @camera.target = @tank

        #50.times do
            #Tank.new(@object_pool, AiInput.new)
        #end
    end
    
    def enter
        RubyProf.start if ENV['ENABLE_PROFILING']
    end

    def leave
        if ENV['ENABLE_PROFILING']
            result = RubyProf.stop
            printer = RubyProf::FlatPrinter.new(result)
            printer.print(STDOUT)
        end
    end

    def update
        @object_pool.objects.map(&:update)
        @object_pool.objects.reject!(&:removable?)
        @camera.update
        update_caption
    end

    def draw
        cam_x, cam_y = @camera.coords
        off_x = $window.width / 2 - cam_x
        off_y = $window.height / 2 - cam_y
        viewport = @camera.viewport
        zoom = @camera.zoom
        $window.translate(off_x, off_y) do
            $window.scale(zoom, zoom, cam_x, cam_y) do
                @map.draw(viewport)
                @object_pool.objects.map { |o| o.draw(viewport) }
            end
        end
        @camera.draw_crosshair
    end

    def button_down(id)
        if id == Gosu::KbQ
            leave
            $window.close
        end
        if id == Gosu::KbEscape
            GameState.switch(MenuState.instance)
        end
    end
    
    private

    def update_caption
        now = Gosu.milliseconds
        if now - (@caption_updated_at || 0) > 1000
            $window.caption = 'Tanks Prototype. ' <<
                "[FPS: #{Gosu.fps}. Tank @ #{@tank.x.round}:#{@tank.y.round}]"
            @caption_updated_at = now
        end
    end
end

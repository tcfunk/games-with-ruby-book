

class GameWindow < Gosu::Window
    attr_accessor :state

    def initialize
        super(800, 600, false)
    end

    def update
        Utils.track_update_interval
        @state.update
    end

    def draw
        @state.draw
    end

    def needs_redraw?
        @state.needs_redraw?
    end

    def needs_cursor?
        Utils.update_interval > 200
    end

    def button_down(id)
        @state.button_down(id)
    end
end

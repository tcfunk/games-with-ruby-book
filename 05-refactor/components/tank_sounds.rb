class TankSounds < Component
    
    def update
        if object.physics.moving?
            if @driving && @driving.paused?
                @driving.resume
            elsif @driving.nil?
                @driving = driving_sound.play(1, 1, true)
            end
        else
            @driving.pause if @driving && @driving.playing?
        end
    end

    def collide
        crash_sound.play(1, 0.25, false)
    end

    private

    def driving_sound
        @@driving_sound ||= Gosu::Sample.new(
            $window, Utils.media_path('tank_driving.mp3'))
    end

    def crash_sound
        @@driving_sound ||= Gosu::Sample.new(
            $window, Utils.media_path('crash.ogg'))
    end

end

--[[
    PlayState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The PlayState class is the bulk of the game, where the player actually controls the bird and
    avoids pipes. When the player collides with a pipe, we should go to the GameOver state, where
    we then go back to the main menu.
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0
    self.spacer = 0

    -- initialize our last recorded Y value for a gap placement to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)

    if scrolling then
        -- update timer for pipe spawning
        self.timer = self.timer + dt

        self.spacer = math.random() + 1.5

        -- spawn a new pipe pair every second and a half
        if self.timer > self.spacer then
            -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
            -- no higher than 10 pixels below the top edge of the screen,
            -- and no lower than a gap length (90 pixels) from the bottom
            local y = math.max(-PIPE_HEIGHT + 10, 
                math.min(self.lastY + math.random(-25, 25), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT - 20))
            self.lastY = y

            -- add a new pipe pair at the end of the screen at our new Y
            table.insert(self.pipePairs, PipePair(y))

            -- reset timer
            self.timer = 0
        end

        -- for every pair of pipes..
        for k, pair in pairs(self.pipePairs) do
            -- score a point if the pipe has gone past the bird to the left all the way
            -- be sure to ignore it if it's already been scored
            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.bird.x then
                    self.score = self.score + 1
                    pair.scored = true
                    gSounds['score']:play()
                end
            end

            -- update position of pair
            pair:update(dt)
        end

        -- we need this second loop, rather than deleting in the previous loop, because
        -- modifying the table in-place without explicit keys will result in skipping the
        -- next pipe, since all implicit keys (numerical indices) are automatically shifted
        -- down after a table removal
        for k, pair in pairs(self.pipePairs) do
            if pair.remove then
                table.remove(self.pipePairs, k)
            end
        end

        -- simple collision between bird and all pipes in pairs
        for k, pair in pairs(self.pipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    gSounds['explosion']:play()
                    gSounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end

        -- update bird based on gravity and input
        self.bird:update(dt)

        -- reset if we get to the ground
        if self.bird.y > VIRTUAL_HEIGHT - 15 then
            gSounds['explosion']:play()
            gSounds['hurt']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end
    end

    -- pause the game if the user presses 'P' then go into pause state
    if love.keyboard.wasPressed('p') and scrolling then
        gSounds['music']:pause()
        gSounds['pause']:play()
        
        scrolling = false
    elseif love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') and not scrolling then
        gSounds['pause']:play()
        gSounds['music']:play()

        scrolling = true
    end
    
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(gFonts['flappyFont'])
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()

    if not scrolling then
        love.graphics.setFont(gFonts['hugeFont'])
        love.graphics.printf('PAUSED', 0, 100, VIRTUAL_WIDTH, 'center')
    
        love.graphics.setFont(gFonts['smallFont'])
        love.graphics.printf('Press Enter to Resume', 0, 160, VIRTUAL_WIDTH, 'center')
    end
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end
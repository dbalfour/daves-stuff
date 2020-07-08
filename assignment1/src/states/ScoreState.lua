--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    if self.score >= 20 and self.score < 40 then
        love.graphics.draw(gImages['silver'], 124, 103)
        love.graphics.setFont(gFonts['flappyFont'])
        love.graphics.printf('Score: ' .. tostring(self.score), 200, 120, VIRTUAL_WIDTH,'left')
        love.graphics.setFont(gFonts['mediumFont'])
        love.graphics.printf('Press Enter to Play Again!', 0, 174, VIRTUAL_WIDTH, 'center')
    elseif self.score >= 40 then
        love.graphics.draw(gImages['gold'], 124, 103)
        love.graphics.setFont(gFonts['flappyFont'])
        love.graphics.printf('Score: ' .. tostring(self.score), 200, 120, VIRTUAL_WIDTH,'left')
        love.graphics.setFont(gFonts['mediumFont'])
        love.graphics.printf('Press Enter to Play Again!', 0, 174, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.draw(gImages['bronze'], 124, 103)
        love.graphics.setFont(gFonts['flappyFont'])
        love.graphics.printf('Score: ' .. tostring(self.score), 200, 120, VIRTUAL_WIDTH,'left')
        love.graphics.setFont(gFonts['mediumFont'])
        love.graphics.printf('Press Enter to Play Again!', 0, 174, VIRTUAL_WIDTH, 'center')
    end
end
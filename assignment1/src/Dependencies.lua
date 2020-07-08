-- 
-- libraries
--

Class = require 'lib/class'
push = require 'lib/push'

require 'src/constants'

require 'src/StateMachine'

require 'src/entity/Bird'
require 'src/entity/Pipe'
require 'src/entity/PipePair'

require 'src/states/BaseState'
require 'src/states/CountdownState'
require 'src/states/PlayState'
require 'src/states/ScoreState'
require 'src/states/TitleScreenState'

gSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

    -- https://freesound.org/people/xsgianni/sounds/388079/
    ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
}

gFonts = {
    ['smallFont'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['mediumFont'] = love.graphics.newFont('fonts/flappy.ttf', 14),
    ['flappyFont'] = love.graphics.newFont('fonts/flappy.ttf', 28),
    ['hugeFont'] = love.graphics.newFont('fonts/flappy.ttf', 56)
}

gImages = {
    ['bronze'] = love.graphics.newImage('images/bronze_medal.png'),
    ['silver'] = love.graphics.newImage('images/silver_medal.png'),
    ['gold'] = love.graphics.newImage('images/gold_medal.png')
}

-- initialize state machine with all state-returning functions
gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['countdown'] = function() return CountdownState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end
}
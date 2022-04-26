-- Alt L to run the application

BUTTON_HEIGHT = 64

local function newButton(text, fn, sound)
    return {
        now = false,
        last = false,

        text = text,
        fn = fn,
        soundplayed = false,
        overfn = function()
            sound:play()
        end,

    }
end

local buttons = {}

local font = nil

function love.load()
    sounds = {}
    sounds.segmentation_fault = love.audio.newSource("sounds/Segmentation Fault.mp3", "stream")
    sounds.segmentation_fault:setLooping(true)
    sounds.snd_squeak = love.audio.newSource("sounds/snd_squeak.wav", "static")
    sounds.segmentation_fault:play()
    sounds.segmentation_fault:setVolume(0.2)
    love.window.setTitle("Simple Menu UI")
    font = love.graphics.newFont(32)

    table.insert(buttons, newButton(
        "Start Game", 
        function()
            print("Starting game")
        end,
        sounds.snd_squeak
    ))

    table.insert(buttons, newButton(
        "Load Game", 
        function()
            print("Loading game")
            sounds.segmentation_fault:play()
        end,
        sounds.snd_squeak
    ))

    table.insert(buttons, newButton(
        "Settings", 
        function()
            print("going to Settings menu")
            sounds.segmentation_fault:pause()
        end,
        sounds.snd_squeak
    ))

    table.insert(buttons, newButton(
        "Exit", 
        function()
            love.event.quit(0)
        end,
        sounds.snd_squeak
    ))


end

function love.update(dt)

end

function love.draw()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    local button_width = ww * (1/3)

    local margin = 16
    local total_height = (BUTTON_HEIGHT + margin) * #buttons
    local cursor_y = 0

    for i, button in ipairs(buttons) do
        button.last = button.now

        local bx = (ww * 0.5) - button_width * 0.5
        local by = (wh * 0.5) - (total_height * 0.5) + cursor_y

        local color = {0.4, 0.4, 0.5, 1.0}
        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + button_width and
                    my > by and my < by + BUTTON_HEIGHT
        local button_expand = 0
        if hot then 
            color = {0.8, 0.8, 0.9, 1.0}
            button_expand = 8
            bx = bx - button_expand * 0.5
            by = by - button_expand * 0.5
            if not button.soundplayed then
                button.overfn()
                button.soundplayed = true
            end 
        else
            button.soundplayed = false
        end

        button.now = love.mouse.isDown(1)
        
        if button.now and not button.last and hot then
            button.fn()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill",
            bx,
            by,
            button_width + button_expand,
            BUTTON_HEIGHT + button_expand)    

        -- Some Debugging help for myself, printing useful information on how button clicks work
        love.graphics.setColor(1, 1, 1, 1)
        if button.now then
            love.graphics.print("button.now = true", love.graphics.newFont(12), 0, 0)
        else 
            love.graphics.print("button.now = false", love.graphics.newFont(12), 0, 0)
        end

        if button.last then
            love.graphics.print("button.last = true", love.graphics.newFont(12), 0, 20)
        else 
            love.graphics.print("button.last = false", love.graphics.newFont(12), 0, 20)
        end



        love.graphics.setColor(0, 0, 0, 1.0)

        local textW = font:getWidth(button.text)
        local textH = (wh * 0.5) - (total_height * 0.5) + cursor_y + font:getHeight(button.text) * 0.5
        
        

        love.graphics.print(
            button.text,
            font,
            (ww * 0.5) - textW * 0.5,
            textH)

        -- Increment cursor value
        cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
    end
end
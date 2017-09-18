For LÖVE 0.11.0 (nightly build)

This is a library for selecting colors.

```lua
function love.load()
    if love.filesystem.getInfo('colors.lua') then
        colors = require('colors')
    else
        colors = {
            background = {.2, .2, .2},
            player = {0, 1, 0},
            box = {1, 0, 0},
        }
    end

    require('colorchanger')(colors, 'colors.lua')
end

function love.draw()
    love.graphics.setColor(color.background)
    drawBackground()

    love.graphics.setColor(color.player)
    drawPlayer()

    love.graphics.setColor(color.box)
    drawBox()
end
```

Call the function returned by `require('colorchanger')` with (in any order):

* the color table to use (\_G by default)
* the file name to automatically save colors to (no file by default)
* the key to toggle the panel ('tab' by default)

Left click and horizontally drag a color value to change it, or right click to set it to a random value.

Press the 'l' key while hovering over a color value to lock or unlock the color.

Changes to the gray boxes at the top affect all unlocked colors.

The left color square is the "original" color and the right color square is the "changed" color. Left click on either to set the current color to the clicked color. Double-click on either to set the other one to the double-clicked color.

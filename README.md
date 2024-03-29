This is a LÖVE 11 library for selecting colors for your LÖVE game.

![](https://santoslove.github.io/colorchanger/colorchangerscreenshot.png)

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
    love.graphics.setBackgroundColor(colors.background)

    love.graphics.setColor(colors.player)
    love.graphics.circle('fill', 100, 100, 50)

    love.graphics.setColor(colors.box)
    love.graphics.rectangle('fill', 300, 300, 100, 100)
end
```

It opens a panel next to the window, so the game needs to be running in windowed mode with enough horizontal space for the panel.

Call the function returned by `require('colorchanger')` with (in any order):

* the color table to use (\_G by default)
* the file name to automatically save colors to (no file by default)
* the key to toggle the panel ('tab' by default)

Change color values by scrolling or left clicking and horizontally dragging.

Set a random value by right clicking.

Lock or unlock a color by pressing the 'L' key.

Changes to the gray boxes at the top affect all unlocked colors.

The left color square is the "original" color and the right color square is the "changed" color. Left click on either to set the current color to the clicked color. Double-click on either to set the other one to the double-clicked color.

This code is [public domain](https://creativecommons.org/publicdomain/zero/1.0/), please do whatever you want with it.

local serialize = (--[[--https://github.com/pkulchenko/serpent Serpent source is released under the MIT License Copyright (c) 2011-2013 Paul Kulchenko (paul@kulchenko.com) Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.--]]function()local b={[tostring(1/0)]='1/0 --[[math.huge]]',[tostring(-1/0)]='-1/0 --[[-math.huge]]',[tostring(0/0)]='0/0'}local c={thread=true,userdata=true,cdata=true}local d=debug and debug.getmetatable or getmetatable local e,f,g={},{},(_G or _ENV)for j,k in ipairs({'and','break','do','else','elseif','end','false','for','function','goto','if','in','local','nil','not','or','repeat','return','then','true','until','while'})do e[k]=true end for j,k in pairs(g)do f[k]=j end for j,k in ipairs({'coroutine','debug','io','math','string','table','os'})do for l,m in pairs(type(g[k])=='table'and g[k]or{})do f[m]=k..'.'..l end end local function h(j,k)local l,m,n,o=k.name,k.indent,k.fatal,k.maxnum local p,q,r=k.sparse,k.custom,not k.nohuge local s,t=(k.compact and''or' '),(k.maxlevel or math.huge)local u=tonumber(k.maxlength)local v,w='_'..(l or''),k.comment and(tonumber(k.comment)or math.huge)local x=k.numformat or"%.17g"local y,z,A,B={},{'local '..v..'={}'},{},0 local function C(N)return'_'..(tostring(tostring(N)):gsub("[^%w]",""):gsub("(%d%w+)",function(O)if not A[O]then B=B+1 A[O]=B end return tostring(A[O])end))end local function D(N)return type(N)=="number"and tostring(r and b[tostring(N)]or x:format(N))or type(N)~="string"and tostring(N)or("%q"):format(N):gsub("\010","n"):gsub("\026","\\026")end local function E(N,O)return w and(O or 0)<w and' --[['..select(2,pcall(tostring,N))..']]'or''end local function F(N,O)return f[N]and f[N]..E(N,O)or not n and D(select(2,pcall(tostring,N)))or error("Can't serialize "..tostring(N))end local function G(N,O)local P=O==nil and''or O local Q=type(P)=="string"and P:match("^[%l%u_][%w_]*$")and not e[P]local R=Q and P or'['..D(P)..']'return(N or'')..(Q and N and'.'or'')..R,R end local H=type(k.sortkeys)=='function'and k.sortkeys or function(N,O,P)local Q,R=tonumber(P)or 12,{number='a',string='b'}local function S(T)return("%0"..tostring(Q).."d"):format(tonumber(T))end table.sort(N,function(T,U)return(N[T]~=nil and 0 or R[type(T)]or'z')..(tostring(T):gsub("%d+",S))<(N[U]~=nil and 0 or R[type(U)]or'z')..(tostring(U):gsub("%d+",S))end)end local function I(N,O,P,Q,R,S,T)local U,V,W=type(N),(T or 0),d(N)local X,Y=G(R,O)local Z=S and((type(O)=="number")and''or O..s..'='..s)or(O~=nil and Y..s..'='..s or'')if y[N]then z[#z+1]=X..s..'='..s..y[N]return Z..'nil'..E('ref',V)end if type(W)=='table'then local ab,bb=pcall(function()return W.__tostring(N)end)local cb,db=pcall(function()return W.__serialize(N)end)if(ab or cb)then y[N]=Q or X if cb then N=db else N=tostring(N)end U=type(N)end end if U=="table"then if V>=t then return Z..'{}'..E('maxlvl',V)end y[N]=Q or X if next(N)==nil then return Z..'{}'..E(N,V)end if u and u<0 then return Z..'{}'..E('maxlen',V)end local ab,bb,cb=math.min(#N,o or#N),{},{}for ib=1,ab do bb[ib]=ib end if not o or#bb<o then local ib=#bb for jb in pairs(N)do if bb[jb]~=jb then ib=ib+1 bb[ib]=jb end end end if o and#bb>o then bb[o+1]=nil end if k.sortkeys and#bb>ab then H(bb,N,k.sortkeys)end local db=p and#bb>ab for ib,jb in ipairs(bb)do local kb,lb,mb=N[jb],type(jb),ib<=ab and not db if k.valignore and k.valignore[kb]or k.keyallow and not k.keyallow[jb]or k.keyignore and k.keyignore[jb]or k.valtypeignore and k.valtypeignore[type(kb)]or db and kb==nil then elseif lb=='table'or lb=='function'or c[lb]then if not y[jb]and not f[jb]then z[#z+1]='placeholder'local ob=G(v,C(jb))z[#z]=I(jb,ob,P,ob,v,true)end z[#z+1]='placeholder'local nb=y[N]..'['..tostring(y[jb]or f[jb]or C(jb))..']'z[#z]=nb..s..'='..s..tostring(y[kb]or I(kb,nil,P,nb))else cb[#cb+1]=I(kb,jb,P,Q,y[N],mb,V+1)if u then u=u-#cb[#cb]if u<0 then break end end end end local eb=string.rep(P or'',V)local fb=P and'{\n'..eb..P or'{'local gb=table.concat(cb,','..(P and'\n'..eb..P or s))local hb=P and"\n"..eb..'}'or'}'return(q and q(Z,fb,gb,hb)or Z..fb..gb..hb)..E(N,V)elseif c[U]then y[N]=Q or X return Z..F(N,V)elseif U=='function'then y[N]=Q or X if k.nocode then return Z.."function() --[[..skipped..]] end"..E(N,V)end local ab,bb=pcall(string.dump,N)local cb=ab and"((loadstring or load)("..D(bb)..",'@serialized'))"..E(N,V)return Z..(cb or F(N,V))else return Z..D(N)end end local J=m and"\n"or";"..s local K=I(j,l,m)local L=#z>1 and table.concat(z,J)..J or''local M=k.comment and#z>1 and s.."--[[incomplete output with shared/self-references skipped]]"or''return not l and K..M or"do local "..K..J..L.."return "..l..J.."end"end local function i(j,k)if k then for l,m in pairs(k)do j[l]=m end end return j end return function(j,k)return'return '..h(j,i({indent='    ',sortkeys=true},k))end end)()

local colorchanger = {}

local l = {}

l.items = {}
l.selected = {}

l.lastChanged = 0
l.isSaved = false

local sizewe = love.mouse.getSystemCursor('sizewe')
local font = love.graphics.newFont(12)

local position = {
    height = 15,
    left = 15,
    top = 15,
    y = 20,
    itemOffsetY = 30,
    globalOffsetY = 15,
}

position.x = {}
position.x[1] = 0
position.x[2] = 17
position.x[3] = 17 + 29
position.x[4] = 17 + 29 + 33
position.x[5] = 17 + 29 + 33 * 2
position.x[6] = 17 + 29 + 33 * 3
position.x[7] = 17 + 29 + 33 * 4 + 9
position.x[8] = 17 + 29 + 33 * 5 + 9
position.x[9] = 17 + 29 + 33 * 6 + 9
position.width = {}
position.width[1] = 15
position.width[2] = 15
position.width[3] = 30
position.width[4] = 30
position.width[5] = 30
position.width[6] = 30
position.width[7] = 30
position.width[8] = 30
position.width[9] = 30

local changedCallbacks = {
    'update',
    'draw',
    'mousepressed',
    'mousereleased',
    'mousemoved',
    'wheelmoved',
}

local unchangedCallbacks = {
    'keyreleased',
    'textedited',
    'textinput',
    'mousefocus',
    'touchmoved',
    'touchpressed',
    'touchreleased',
    'joystickpressed',
    'joystickreleased',
    'joystickaxis',
    'joystickhat',
    'joystickadded',
    'joystickremoved',
    'gamepadpressed',
    'gamepadreleased',
    'gamepadaxis',
}

local changedFunctions = {
    {'window', 'getMode'},
    {'graphics', 'getDimensions'},
    {'graphics', 'getWidth'},
    {'graphics', 'getHeight'},
}

local function hsvToRgb(h, s, v)
    h = h / 360
    s = s / 100
    v = v / 100
    local i = math.floor(h*6)
    local f = h*6 - i
    local p = v * (1 - s)
    local q = v * (1 - f*s)
    local t = v * (1 - (1 - f) * s)

    local r, g, b
    if i == 0 then
        r, g, b = v, t, p
    elseif i == 1 then
        r, g, b = q, v, p
    elseif i == 2 then
        r, g, b = p, v, t
    elseif i == 3 then
        r, g, b = p, q, v
    elseif i == 4 then
        r, g, b = t, p, v
    elseif i == 5 then
        r, g, b = v, p, q
    end

    return r, g, b
end

local function rgbToHsv(r, g, b)
    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min

    local s
    if max == 0 then
        s = 0
    else
        s = delta / max
    end

    if s == 0 then
        h = 0
    else
        if r == max then
            h = (g - b) / delta
        elseif g == max then
            h = 2 + (b - r) / delta
        elseif b == max then
            h = 4 + (r - g) / delta
        end

        h = h * 60
        if h < 0 then
            h = h + 360
        end
    end

    return math.floor(h), math.floor(s * 100), math.floor(max * 100)
end

local function setItemColor(item, r, g, b, a)
    item.color[1] = r
    item.color[2] = g
    item.color[3] = b
    if a then
        item.color[4] = a
    end

    l.lastChanged = love.timer.getTime()
    l.isSaved = false
end

local function changeColor(index, new)
    local item = l.items[index]
    if item.locked then return end
    local r, g, b, a = unpack(new)
    setItemColor(item, r/255, g/255, b/255, a/255)
    item.changed = {math.floor(r), math.floor(g), math.floor(b), math.floor(a)}
    item.hsv = {rgbToHsv(r/255, g/255, b/255, a/255)}
end

local function changeHsv(index, hsv)
    local item = l.items[index]
    if item.locked then return end
    local r, g, b = hsvToRgb(unpack(hsv))
    setItemColor(item, r, g, b)
    item.changed = {
        math.floor(r*255),
        math.floor(g*255),
        math.floor(b*255),
        item.changed[4]
    }
    item.hsv = hsv
end

local function randomComponent(index, component)
    local item = l.items[index]
    local color = {unpack(item.color)}
    color[1] = color[1]*255
    color[2] = color[2]*255
    color[3] = color[3]*255
    color[4] = color[4]*255
    color[component] = l.rng:random(0, 255)
    changeColor(index, color)
end

local function randomColor(index)
    local item = l.items[index]
    changeColor(index, {
        l.rng:random(0, 255),
        l.rng:random(0, 255),
        l.rng:random(0, 255),
        item.color[4] * 255
    })
end

local function randomOriginal(index)
    local item = l.items[index]
    if item.locked then return end
    setItemColor(item, l.rng:random(), l.rng:random(), l.rng:random())
    item.original = {
        item.color[1]*255,
        item.color[2]*255,
        item.color[3]*255,
        item.color[4]*255
    }
    item.hsv = {rgbToHsv(
        item.color[1],
        item.color[2],
        item.color[3],
        item.color[4]
    )}
end

local function randomHsv(index, component)
    local item = l.items[index]
    local hsv = {unpack(item.hsv)}
    if component == 1 then
        hsv[component] = l.rng:random(0, 359)
    else
        hsv[component] = l.rng:random(0, 100)
    end
    changeHsv(index, hsv)
end

local function changeHsvComponent(index, component, change)
    local item = l.items[index]
    local hsv = {unpack(item.hsv)}
    if component == 1 then
        hsv[component] = hsv[component] + change
        if hsv[component] > 359 then
            hsv[component] = 0
        elseif hsv[component] < 0 then
            hsv[component] = 359
        end
    else
        hsv[component] = math.max(math.min(hsv[component] + change, 100), 0)
    end
    changeHsv(index, hsv)
end

local function increaseHsv(index, component)
    changeHsvComponent(index, component, 1)
end

local function decreaseHsv(index, component)
    changeHsvComponent(index, component, -1)
end

local function changeComponent(index, component, change)
    local item = l.items[index]
    local color = {unpack(item.color)}
    color[1] = color[1]*255
    color[2] = color[2]*255
    color[3] = color[3]*255
    color[4] = color[4]*255
    color[component] = math.max(math.min(color[component] + change, 255), 0)
    changeColor(index, color)
end

local function increaseComponent(index, component)
    changeComponent(index, component, 1)
end

local function decreaseComponent(index, component)
    changeComponent(index, component, -1)
end

local function toColor(item, c)
    setItemColor(item, c[1]/255, c[2]/255, c[3]/255, c[4]/255)
    item.hsv = {rgbToHsv(c[1]/255, c[2]/255, c[3]/255, c[4]/255)}
end

local function originalToColor(index)
    local item = l.items[index]
    toColor(item, item.original)
end

local function changedToColor(index)
    local item = l.items[index]
    toColor(item, item.changed)
end

local function changedToOriginal(index)
    local item = l.items[index]
    local r, g, b, a = unpack(item.changed)
    changedToColor(index)
    item.original = {r, g, b, a}
    item.hsv = {rgbToHsv(r/255, g/255, b/255, a/255)}
end

local function originalToChanged(index)
    local item = l.items[index]
    local r, g, b, a = unpack(item.original)
    originalToColor(index)
    item.changed = {math.floor(r), math.floor(g), math.floor(b), math.floor(a)}
    item.hsv = {rgbToHsv(r/255, g/255, b/255, a/255)}
end

local function doToAll(f, component)
    for itemIndex, item in ipairs(l.items) do
        f(itemIndex, component)
    end
end

local function increaseAllComponents(component) doToAll(increaseComponent, component) end
local function decreaseAllComponents(component) doToAll(decreaseComponent, component) end
local function increaseAllHsv(component) doToAll(increaseHsv, component) end
local function decreaseAllHsv(component) doToAll(decreaseHsv, component) end
local function randomAllComponents(component) doToAll(randomComponent, component) end
local function randomAllHsv(component) doToAll(randomHsv, component) end
local function randomAllColors() doToAll(randomColor) end
local function randomOriginalAllColors() doToAll(randomOriginal) end
local function originalAllToColor() doToAll(originalToColor) end
local function changedAllToColor() doToAll(changedToColor) end
local function originalAllToChanged() doToAll(originalToChanged) end
local function changedAllToOriginal() doToAll(changedToOriginal) end

local function isPositionColor(position)
    return position <= 2
end

local function isPositionComponent(position)
    return position >= 3 and position < 7
end

local function isPositionHsv(position)
    return position >= 7
end

local function componentFromPosition(position)
    return position - 2
end

local function hsvFromPosition(position)
    return position - 6
end

local function increase(selected)
    if l.selected.item then
        if isPositionComponent(l.selected.position) then
            increaseComponent(l.selected.item, componentFromPosition(l.selected.position))
        elseif isPositionHsv(l.selected.position) then
            increaseHsv(l.selected.item, hsvFromPosition(l.selected.position))
        end
    else
        if isPositionComponent(l.selected.position) then
            increaseAllComponents(componentFromPosition(l.selected.position))
        elseif isPositionHsv(l.selected.position) then
            increaseAllHsv(hsvFromPosition(l.selected.position))
        end
    end
end

local function decrease(selected)
    if l.selected.item then
        if isPositionComponent(l.selected.position) then
            decreaseComponent(l.selected.item, componentFromPosition(l.selected.position))
        elseif isPositionHsv(l.selected.position) then
            decreaseHsv(l.selected.item, hsvFromPosition(l.selected.position))
        end
    else
        if isPositionComponent(l.selected.position) then
            decreaseAllComponents(componentFromPosition(l.selected.position))
        elseif isPositionHsv(l.selected.position) then
            decreaseAllHsv(hsvFromPosition(l.selected.position))
        end
    end
end

local function random(selected)
    if l.selected.item then
        if isPositionColor(l.selected.position) then
            randomColor(l.selected.item)
        elseif isPositionComponent(l.selected.position) then
            randomComponent(l.selected.item, componentFromPosition(l.selected.position))
        else
            randomHsv(l.selected.item, hsvFromPosition(l.selected.position))
        end
    else
        if l.selected.position == 1 then
            randomOriginalAllColors(componentFromPosition(l.selected.position))
        elseif l.selected.position == 2 then
            randomAllColors(componentFromPosition(l.selected.position))
        elseif isPositionComponent(l.selected.position) then
            randomAllComponents(componentFromPosition(l.selected.position))
        else
            randomAllHsv(hsvFromPosition(l.selected.position))
        end
    end
end

local function toggleLockIndex(index)
    local item = l.items[index]
    item.locked = not item.locked
end

local function toggleLock(selected)
    if l.selected.item then
        toggleLockIndex(l.selected.item)
    end
end

local function sortItems()
    table.sort(l.items, function(a, b)
        local a1, b1, c1 = a.name:match('^(.-)(%d+)(.-)$')
        local a2, b2, c2 = b.name:match('^(.-)(%d+)(.-)$')
        local bn1 = tonumber(b1)
        local bn2 = tonumber(b2)
        if a1 == a2 and c1 == c2 and bn1 and bn2 then
            return bn1 < bn2
        else
            return a.name < b.name
        end
    end)
end

local function save()
    if not l.file then
        return
    end

    local s = ''

    if l.globalTable then
        local created = {}

        table.sort(l.items, function(a, b)
            if #a.name == #b.name then
                return a.name < b.name
            else
                return #a.name < #b.name
            end
        end)

        for itemIndex, item in ipairs(l.items) do
            local t = item.name:match('(.+)%[.+%]')
            if not created[t] then
                s = s..t..' = '..t..' or {}\n'
                created[t] = true
            end
            s = s..item.name..' = '..'{'..
            item.color[1]..', '..
            item.color[2]..', '..
            item.color[3]
            if item.color[4] ~= 1 then
                s = s..', '..item.color[4]
            end
            s = s..'}'..'\n'
        end

        sortItems()
    else
        s = serialize(l.externalTable)
    end

    love.filesystem.write(l.file, s)
end

local searched = {}
local function findColors(t, n, brackets)
    if not searched[t] then
        searched[t] = true

        for k, v in pairs(t) do
            if type(v) == 'table' then
                local isColor = false
                if #v == 3 or #v == 4 then
                    isColor = true
                    for componentIndex, component in ipairs(v) do
                        if type(component) ~= 'number' or component < 0 or component > 1 then
                            isColor = false
                            break
                        end
                    end
                end
                if isColor then
                    local item = {}

                    if brackets then
                        if type(k) == 'string' and k == k:match('%a*') then
                            item.name = n .. '[\''.. k .. '\']'
                        elseif type(k) == 'string' then
                            item.name = n .. '[\''.. k .. '\']'
                        elseif type(k) == 'number' or type(k) == 'boolean' then
                            item.name = n .. '['.. k .. ']'
                        else
                            item.name = n
                        end
                    else
                        if type(k) == 'string' and k == k:match('%a*') then
                            if n == '' then
                                item.name = k
                            else
                                item.name = n .. '.'.. k
                            end
                        elseif type(k) == 'string' then
                            item.name = n .. '[\''.. k .. '\']'
                        elseif type(k) == 'number' or type(k) == 'boolean' or type(k) == 'string' then
                            item.name = n .. '['.. k .. ']'
                        else
                            item.name = n
                        end
                    end

                    if not v[4] then
                        v[4] = 1
                    end

                    local c = {}
                    for componentIndex, component in ipairs(v) do
                        table.insert(c, math.floor((component * 255) + .5))
                    end

                    item.color = v
                    item.hsv = {rgbToHsv(unpack(v))}
                    for componentIndex, component in ipairs(item.hsv) do
                        item.hsv[componentIndex] = math.floor(component)
                    end
                    item.original = {unpack(c)}
                    item.changed = {unpack(c)}
                    item.locked = false

                    table.insert(l.items, item)
                else
                    if brackets then
                        if type(k) == 'string' then
                            findColors(v, n .. '[\''..k .. '\']', true)
                        elseif type(k) == 'number' or type(k) == 'boolean' then
                            findColors(v, n .. '['..k .. ']', true)
                        else
                            findColors(v, '', true)
                        end
                    else
                        if type(k) == 'string' then
                            if n == '' then
                                findColors(v, k)
                            else
                                findColors(v, n .. '.' .. k)
                            end
                        elseif type(k) == 'number' or type(k) == 'boolean' then
                            findColors(v, n .. '['..k .. ']', true)
                        else
                            findColors(v, '')
                        end
                    end
                end
            end
        end
    end
end

function colorchanger.change(a, b, c)
    if colorchanger.loaded then return end

    local function f(a)
        if type(a) == 'table' then
            findColors(a, '')
            l.externalTable = a
            return true
        end
    end
    if not f(a) and not f(b) and not f(c) then
        findColors(_G, '')
        l.globalTable = true
    end

    local function f(a)
        if type(a) == 'string' then
            if pcall(love.keyboard.getScancodeFromKey, a) then
                l.key = a
                return true
            end
        end
    end
    if not f(a) and not f(b) and not f(c) then
        l.key = 'tab'
    end

    local function f(a)
        if type(a) == 'string' then
            if not pcall(love.keyboard.getScancodeFromKey, a) then
                l.file = a
            end
        end
    end
    f(a)
    f(b)
    f(c)

    sortItems()

    if not l.keypressed then
        l.keypressed = love.keypressed
    end

    if not l.quit then
        l.quit = love.quit
    end

    function love.keypressed(key, scancode, isRepeat)
        if key == l.key then
            if l.on then
                colorchanger.off()
            else
                colorchanger.on()
            end
        elseif not l.on then
            if l.keypressed then
                l.keypressed(key, scancode, isRepeat)
            end
        else
            if l.selected.position then
                if not isRepeat then
                    if key == 'r' then
                        random(l.selected)
                    elseif key == 'l' then
                        toggleLock(l.selected)
                    end
                end
                if key == 'right' or key == 'up' then
                    increase(l.selected)
                elseif key == 'left' or key == 'down' then
                    decrease(l.selected)
                end
            end
        end
    end

    function love.quit()
        save()
        if not l.on and l.quit then
            l.quit()
        end
    end

    colorchanger.loaded = true
end

function colorchanger.on()
    l.on = true
    l.mode = love.window.getMode()
    l.width, l.height = love.graphics.getDimensions()

    l.cursor = love.mouse.getCursor()
    love.mouse.setCursor()

    l.relativeMode = love.mouse.getRelativeMode()
    love.mouse.setRelativeMode(false)

    l.keyRepeat = love.keyboard.hasKeyRepeat()
    love.keyboard.setKeyRepeat(true)

    l.rng = love.math.newRandomGenerator(os.time())

    for callbackIndex, callback in ipairs(unchangedCallbacks) do
        l[callback] = _G['love'][callback]
    end

    for callbackIndex, callback in ipairs(changedCallbacks) do
        l[callback] = _G['love'][callback]
    end

    for functionIndex, function_ in ipairs(changedFunctions) do
        l[function_[2]] = _G['love'][function_[1]][function_[2]]
    end

    for callbackIndex, callback in ipairs(unchangedCallbacks) do
        _G['love'][callback] = function() end
    end

    function love.window.getMode()
        return l.mode
    end

    function love.graphics.getDimensions()
        return l.width, l.height
    end

    function love.graphics.getWidth()
        return l.width
    end

    function love.graphics.getHeight()
        return l.height
    end

    function love.mousepressed(x, y, button, isTouch, clickCount)
        if l.selected.position then
            if button == 1 then
                if l.selected.position > 2 then
                    l.mouseX, l.mouseY = love.mouse.getPosition()
                    love.mouse.setRelativeMode(true)
                    l.selected.buffer = 0
                    l.selected.bufferSize = 8
                elseif l.selected.item and clickCount == 2 then
                    if l.selected.position == 1 then
                        originalToChanged(l.selected.item)
                    elseif l.selected.position == 2 then
                        changedToOriginal(l.selected.item)
                    end
                elseif l.selected.item then
                    if l.selected.position == 1 then
                        originalToColor(l.selected.item)
                    elseif l.selected.position == 2 then
                        changedToColor(l.selected.item)
                    end
                elseif clickCount == 2 then
                    if l.selected.position == 1 then
                        originalAllToChanged()
                    elseif l.selected.position == 2 then
                        changedAllToOriginal()
                    end
                else
                    if l.selected.position == 1 then
                        originalAllToColor()
                    elseif l.selected.position == 2 then
                        changedAllToColor()
                    end
                end
            elseif button == 2 then
                random(l.selected)
            end
        elseif l.selected.scroll then
            l.scroll.mouseOffset = y - l.scroll.y
        end
    end

    function love.mousereleased(x, y, button, isTouch, clickCount)
        if love.mouse.getRelativeMode() then
            love.mouse.setRelativeMode(false)
            love.mouse.setPosition(l.mouseX, l.mouseY)
        end
        if l.selected.scroll then
            l.selected = {}
        end
    end

    function love.mousemoved(x, y, dx, dy)
        if l.selected.position then
            if love.mouse.getRelativeMode() then
                l.selected.buffer = l.selected.buffer + dx
                while l.selected.buffer > l.selected.bufferSize do
                    increase(l.selected)
                    l.selected.buffer = l.selected.buffer - l.selected.bufferSize
                end
                while l.selected.buffer < -l.selected.bufferSize do
                    decrease(l.selected)
                    l.selected.buffer = l.selected.buffer + l.selected.bufferSize
                end
            end
        end
    end

    local function setScrollOffset(offset)
        l.scroll.offset = math.max(math.min(offset, l.scroll.maxOffset), 0)
        l.scroll.y = l.scroll.offset / l.scroll.maxOffset * l.scroll.height
    end

    function love.wheelmoved(x, y)
        if l.selected.position then
            if y > 0 then
                increase(l.selected)
            elseif y < 0 then
                decrease(l.selected)
            end
        elseif l.scroll then
            setScrollOffset(l.scroll.offset + y * 10)
        end
    end

    local maxNameWidth = 0
    for i, v in ipairs(l.items) do
        maxNameWidth = math.max(love.graphics.getFont():getWidth(v.name), maxNameWidth)
    end

    l.panelWidth = 320 + maxNameWidth

    local totalHeight = #l.items * position.y + position.top + position.y + position.globalOffsetY

    if totalHeight > l.height then
        l.scroll = {}
        l.scroll.height = l.height / 2
        l.scroll.maxOffset = totalHeight - l.height
        l.scroll.width = 15
        setScrollOffset(0)
        l.panelWidth = l.panelWidth + l.scroll.width
    end

    function love.update()
        local function isMouseIn(x, y, width, height)
            return love.mouse.getX() >= x
            and love.mouse.getX() < x + width
            and love.mouse.getY() >= y
            and love.mouse.getY() < y + height
        end

        if not love.mouse.getRelativeMode() then
            if not (l.selected and l.selected.scroll and love.mouse.isDown(1)) then
                l.selected = {}
            end

            if l.selected.scroll and l.scroll and love.mouse.isDown(1) then
                setScrollOffset((love.mouse.getY() - l.scroll.mouseOffset) * (l.scroll.maxOffset / l.scroll.height))
            else
                for positionIndex, x in ipairs(position.x) do
                    if isMouseIn(l.width + x + position.left, position.globalOffsetY, position.width[positionIndex], position.height) then
                        l.selected = {global = true, position = positionIndex}
                    end
                end

                if not isMouseIn(l.width, 0, l.panelWidth, position.globalOffsetY + position.itemOffsetY) then
                    local scrollY = 0
                    if l.scroll then
                        scrollY = l.scroll.offset
                    end

                    for itemIndex, item in ipairs(l.items) do
                        for positionIndex, x in ipairs(position.x) do
                            if isMouseIn(
                                l.width + x + position.left, position.globalOffsetY + position.itemOffsetY + (itemIndex - 1) * position.y - scrollY, position.width[positionIndex], position.height
                                ) then
                                l.selected = {position = positionIndex, item = itemIndex}
                            end
                        end
                    end
                end

                if l.scroll and isMouseIn(l.width + l.panelWidth - l.scroll.width, l.scroll.y, l.scroll.width, l.scroll.height) then
                    l.selected = {scroll = true}
                end
            end

            if not love.window.hasMouseFocus() then
                l.selected = {}
            end

            if l.selected.position and l.selected.position > 2 and (not l.selected.item or not l.items[l.selected.item].locked) then
                love.mouse.setCursor(sizewe)
            else
                love.mouse.setCursor()
            end
        end

        if not l.isSaved and love.timer.getTime() - l.lastChanged > 1 then
            save()
            l.isSaved = true
        end
    end

    function love.draw()
        l.draw()

        love.graphics.push('all')

        love.graphics.reset()

        love.graphics.setFont(font)

        love.graphics.translate(l.width, 0)

        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, l.panelWidth, l.height)

        local color = {.2, .2, .2}
        local hoverColor = {.4, .4, .4}

        local function drawBox(locked, hover, x, y, width, text)
            if locked then
                love.graphics.setColor(.1, .1, .1)
            elseif hover then
                love.graphics.setColor(hoverColor)
            else
                love.graphics.setColor(color)
            end
            love.graphics.rectangle('fill', x, y, width, position.height)
            if text then
                if locked then
                    love.graphics.setColor(.3, .3, .3)
                else
                    love.graphics.setColor(.6, .6, .6)
                end
                love.graphics.print(text, x + 3, y + 1)
            end
        end

        for itemIndex, item in ipairs(l.items) do
            local function drawY(index)
                local y = position.globalOffsetY + position.itemOffsetY + (index - 1) * position.y
                if l.scroll then
                    y = y - l.scroll.offset
                end
                return y
            end

            for positionIndex, x in ipairs(position.x) do
                local t = {
                    '',
                    '',
                    item.changed[1],
                    item.changed[2],
                    item.changed[3],
                    item.changed[4],
                    item.hsv[1],
                    item.hsv[2],
                    item.hsv[3],
                }
                local function drawSquare(x)
                    love.graphics.rectangle(
                        'fill',
                        x + position.left,
                        drawY(itemIndex),
                        position.width[positionIndex],
                        position.height
                    )
                end
                if positionIndex == 1 then
                    love.graphics.setColor(item.original[1]/255, item.original[2]/255, item.original[3]/255)
                    drawSquare(x)
                elseif positionIndex == 2 then
                    love.graphics.setColor(item.changed[1]/255, item.changed[2]/255, item.changed[3]/255)
                    drawSquare(x)
                else
                    drawBox(
                        item.locked,
                        l.selected and l.selected.position == positionIndex and l.selected.item == itemIndex,
                        x + position.left,
                        drawY(itemIndex),
                        position.width[positionIndex],
                        t[positionIndex]
                    )
                end
            end
            love.graphics.print(
                item.name,
                position.x[#position.x] + position.width[#position.width] + 24, 
                drawY(itemIndex)
            )
        end

        love.graphics.setColor(0, 0, 0, .8)
        love.graphics.rectangle('fill', 0, 0, l.panelWidth, position.globalOffsetY + position.itemOffsetY)

        for positionIndex, x in ipairs(position.x) do
            local t = {
                '',
                '',
                'R',
                'G',
                'B',
                'A',
                'H',
                'S',
                'V',
            }
            drawBox(
                false,
                l.selected and l.selected.global and l.selected.position == positionIndex,
                x + position.left,
                position.globalOffsetY,
                position.width[positionIndex]
            )
            love.graphics.setColor(.6, .6, .6)
            love.graphics.printf(t[positionIndex], x + position.left, position.globalOffsetY + 1, position.width[positionIndex], 'center')
        end

        if l.scroll then
            love.graphics.setColor(.1, .1, .1)
            love.graphics.rectangle('fill', l.panelWidth - l.scroll.width, 0, l.scroll.width, l.height)
            if l.selected.scroll then
                love.graphics.setColor(hoverColor)
            else
                love.graphics.setColor(color)
            end
            love.graphics.rectangle('fill', l.panelWidth - l.scroll.width, l.scroll.y, l.scroll.width, l.scroll.height, l.scroll.width/2)
        end

        love.graphics.pop()
    end

    love.window.updateMode(l.width + l.panelWidth, l.height)
end

function colorchanger.off()
    save()

    l.on = false

    for callbackIndex, callback in ipairs(changedCallbacks) do
        _G['love'][callback] = l[callback]
    end

    for functionIndex, function_ in ipairs(changedFunctions) do
        _G['love'][function_[1]][function_[2]] = l[function_[2]]
    end

    love.mouse.setCursor(l.cursor)
    love.mouse.setRelativeMode(l.relativeMode)
    love.keyboard.setKeyRepeat(l.keyRepeat)

    love.window.updateMode(l.width, l.height)
end

return colorchanger.change

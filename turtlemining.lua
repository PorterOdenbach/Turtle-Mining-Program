-- Usage: <program name> <direction> <scanner range>
-- Direction: (0 = north, 1 = east, 2 = south, 3 = west)

local scanner = peripheral.find('geoScanner')
local posx, posy, posz = 0, 0, 0
local ores = {'minecraft:iron_ore'}

local tArgs = { ... }
if #tArgs ~= 2 then
    print('Usage: <program name> <scanner range>')
    return
end

local dir = tonumber(tArgs[1])
local range = tonumber(tArgs[2])


local function scanBlocks(range1)
    local scan, error = scanner.scan(range1)
    if scan then
        return scan
    end
    return error
end

local function inList(value, list)
    for _,i in pairs(list) do
        if i == value then
            return true
        end
    end
    return false
end

local function findClosestOre(scannedBlocks)
    local nx, ny, nz = 100, 100, 100
    local count = 0
    if type(scannedBlocks) ~= 'table' then
        return nil, nil, nil, 'scannedBlocks'
    else
        for _,i in pairs(scannedBlocks) do
            if inList(i.name, ores) then
                count = 1
                print(i.x .. i.y .. i.z)
                local distanceOld = math.sqrt(nx*nx+ny*ny+nz*nz)
                local distanceNew = math.sqrt(i.x*i.x+i.y*i.y+i.z*i.z)
                if (distanceOld > distanceNew) and not(i.x == 0 and i.y == 0 and i.z == 0) then
                    nx, ny, nz = i.x, i.y, i.z
                end
            end
        end
        if count == 0 then
            return nil, nil, nil, 1
        end
        return nx, ny, nz, nil
    end
end

local function turnNorth(direc)
    if direc == 1 then
        turtle.turnLeft()
    elseif direc == 2 then
        turtle.turnLeft()
        turtle.turnLeft()
    else
        turtle.turnRight()
    end
    dir = 0
end

local function checkFuel()
    while turtle.getFuelLevel() < (turtle.getFuelLimit() / 2) do
        turtle.refuel()
    end
end


local function fullInv()
    if turtle.getItemCount(16) > 0 then
        return true
    end
    return false
end


local function moveTo(lx, ly, lz)
    turnNorth(dir)
    checkFuel()
    if lz < 0 then
        turtle.turnLeft()
        turtle.turnLeft()
        dir = 2
        for i = 1, math.abs(lz) do
            turtle.dig()
            turtle.forward()
            checkFuel()
            fullInv()
            posz = posz + 1
        end
    elseif lz > 0 then
        for i = 1, math.abs(lz) do
            turtle.dig()
            turtle.forward()
            checkFuel()
            fullInv()
            posz = posz - 1
        end
    end

    if lx < 0 then
        turtle.turnRight()
        dir = 1
        for i = 1, math.abs(lx) do
            turtle.dig()
            turtle.forward()
            checkFuel()
            fullInv()
            posx = posx + 1
        end
    elseif lx > 0 then
        turtle.turnLeft()
        dir = 3
        for i = 1, math.abs(lx) do
            turtle.dig()
            turtle.forward()
            checkFuel()
            fullInv()
            posx = posx - 1
        end
    end

    if ly < 0 then
        for i = 1, math.abs(ly) do
            turtle.digUp()
            turtle.up()
            checkFuel()
            fullInv()
            posy = posy + 1
        end
    elseif ly > 0 then
        for i = 1, math.abs(ly) do
            turtle.digDown()
            turtle.down()
            checkFuel()
            fullInv()
            posy = posy - 1
        end
    end
end

--[[while true do
    local scans = scanBlocks(range)
    local cx, cy, cz, error = findClosestOre(scans)
    if error then 
        print('Error:')
        print(scans)
        return
    end
end]]

local scans = scanBlocks(range)
local cx, cy, cz, error = findClosestOre(scans)
if error then 
    print('Error:')
    print(error)
    print(scans)
    return
end
moveTo(cx, cy, cz)
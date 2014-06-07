AddCSLuaFile()

-- Map settings
local mapSettings = {
    tileSize = 64,
    xTiles = 16 * 4,
    yTiles = 16 * 4
}

-- Contains info on where traps are currently
local map = {}
for xx=1, mapSettings.xTiles do
    map[xx] = {}
    for yy=1, mapSettings.yTiles do
        map[xx][yy] = {
            taken = false
        }
    end
end

function GetTileSize()
    return mapSettings.tileSize
end

function GetxTiles()
    return mapSettings.xTiles
end

function GetyTiles()
    return mapSettings.yTiles
end

function ValidRot(rot)
    -- Check all valid rotations
    if rot == 0 then return true end
    if rot == 90 then return true end
    if rot == 180 then return true end
    if rot == 270 then return true end

    -- Not valid
    return false
end

function ValidCell(x, y)
    -- Ensure the space exists
    if not map[x] or not map[x][y] then
        return false
    end

    -- Yay, a valid cell
    return true
end

-- Puts a trap into a given cell
function SetMapCell(x, y, rot, trapId)
    -- Validate inputs
    if not ValidRot(rot) then return false end
    if not ValidCell(x, y) then return false end

    -- Put the trap into the cell
    map[x][y] = {
        taken = true,
        trapId = trapId,
        rot = rot
    }

    -- Store parented cells
end

-- Returns info on a given cell
function GetMapCell(x, y)
    -- Ensure it's a valid cell
    if not ValidCell(x, y) then return nil end

    -- Check if there is something in it
    if not map[x][y].taken then
        return nil
    end

    -- Check if this cell has been parented to another
    if map[x][y].parent then
        -- Build a new parent block
        return {
            parent = {
                x = map[x][y].parent.x,
                y = map[x][y].parent.y
            }
        }
    end

    -- Space contains a trap
    return {
        trapId = map[x][y].trapId,
        rot = map[x][y].rot
    }
end

-- Contains all of our trap info
local traps = {}

-- Registers a new trap
function RegisterTrap(args)
    -- Check if we already have a trap by that name
    for k,v in pairs(traps) do
        if v.name == args.name then
            -- Replace old trap
            traps[k] = args

            -- Tell the user
            print("WARNING: Trap '"..args.name.."' already exists!")

            -- Don't add it again
            return
        end
    end

    -- Simply store the trap
    return table.insert(traps, args)
end

-- Gets a given trap
function GetTrap(trapId)
    -- WANRING: This exposes traps[trapID] to the outside world!
    return traps[trapId]
end

-- Creates a vertex
function Vertex(pos, u, v, normal)
    -- Only need position on the server
    if SERVER then
        return {pos = pos}
    else
        return {pos = pos, u = u, v = v, normal = normal}
    end
end

-- Creates a plane
function Plane(top_left, top_right, bottom_right, bottom_left, normal)
    -- Fix tex coords

    return {
        Vertex(bottom_right[1], bottom_right[2], bottom_right[3], normal),
        Vertex(top_right[1], top_right[2], top_right[3], normal),
        Vertex(bottom_left[1], bottom_left[2], bottom_left[3], normal),

        Vertex(top_right[1], top_right[2], top_right[3], normal),
        Vertex(top_left[1], top_left[2], top_left[3], normal),
        Vertex(bottom_left[1], bottom_left[2], bottom_left[3], normal)
    }
end

-- Easy values
local ts = mapSettings.tileSize

-- Start Point
local test = RegisterTrap({
    name = "Start",
    xSize = 4,
    ySize = 4,
    conUp = true,
    mesh = {
        floor = {
            -- Floor
            Plane({Vector(ts*4, ts*4, 0), 4, 4}, {Vector(0, ts*4, 0), 0, 4}, {Vector(0, 0, 0), 0, 0}, {Vector(ts*4, 0, 0), 4, 0}, Vector(0, 0, 1))
        },
        roof = {
            -- Roof
            Plane({Vector(0, 0, ts*4), 0, 0}, {Vector(0, ts*4, ts*4), 0, 4}, {Vector(ts*4, ts*4, ts*4), 4, 4}, {Vector(ts*4, 0, ts*4), 4, 0}, Vector(0, 0, -1))
        },
        wall = {
            -- Left
            Plane({Vector(0, ts*4, 0), 4, 0}, {Vector(0, ts*4, ts*4), 4, 4}, {Vector(0, 0, ts*4), 0, 4}, {Vector(0, 0, 0), 0, 0}, Vector(1, 0, 0)),

            -- Right
            Plane({Vector(ts*4, ts*4, 0), 4, 0}, {Vector(ts*4, 0, 0), 0, 0}, {Vector(ts*4, 0, ts*4), 0, 4}, {Vector(ts*4, ts*4, ts*4), 4, 4}, Vector(-1, 0, 0)),

            -- Back
            Plane({Vector(0, 0, 0), 0, 0}, {Vector(0, 0, ts*4), 0, 4}, {Vector(ts*4, 0, ts*4), 4, 4}, {Vector(ts*4, 0, 0), 4, 0}, Vector(0, 1, 0))
        },
    }
})

-- Basic Gap
local test2 = RegisterTrap({
    name = "Basic Gap",
    xSize = 4,
    ySize = 4,
    conUp = true,
    conDown = true,
    mesh = {
        floor = {
            -- Floor
            Plane({Vector(ts*4, ts, 0), 4, 1}, {Vector(0, ts, 0), 0, 1}, {Vector(0, 0, 0), 0, 0}, {Vector(ts*4, 0, 0), 4, 0}, vector_up),
            Plane({Vector(ts*4, ts*4, 0), 4, 4}, {Vector(0, ts*4, 0), 0, 4}, {Vector(0, ts*3, 0), 0, 3}, {Vector(ts*4, ts*3, 0), 4, 3}, vector_up)
        },
        roof = {
            -- Roof
            Plane({Vector(0, 0, ts*4), 0, 0}, {Vector(0, ts*4, ts*4), 0, 4}, {Vector(ts*4, ts*4, ts*4), 4, 4}, {Vector(ts*4, 0, ts*4), 4, 0}, Vector(0, 0, -1))
        },
        wall = {
            -- Left
            Plane({Vector(0, ts*4, -ts*4), 4, -4}, {Vector(0, ts*4, ts*4), 4, 4}, {Vector(0, 0, ts*4), 0, 4}, {Vector(0, 0, -ts*4), 0, -4}, Vector(1, 0, 0)),

            -- Right
            Plane({Vector(ts*4, ts*4, -ts*4), 4, -4}, {Vector(ts*4, 0, -ts*4), 0, -4}, {Vector(ts*4, 0, ts*4), 0, 4}, {Vector(ts*4, ts*4, ts*4), 4, 4}, Vector(-1, 0, 0)),

            -- Front Hole
            Plane({Vector(0, ts*3, 0), 0, 0}, {Vector(0, ts*3, -ts*4), 0, -4}, {Vector(ts*4, ts*3, -ts*4), 4, -4}, {Vector(ts*4, ts*3, 0), 4, 0}, Vector(0, -1, 0)),

            -- Back Hole
            Plane({Vector(0, ts, 0), 0, 0}, {Vector(ts*4, ts, 0), 4, 0}, {Vector(ts*4, ts, -ts*4), 4, -4}, {Vector(0, ts, -ts*4), 0, -4}, Vector(0, 1, 0))
        },
    }
})

-- Basic Corner
local test3 = RegisterTrap({
    name = "Basic Corner",
    xSize = 4,
    ySize = 4,
    conDown = true,
    conRight = true,
    mesh = {
        floor = {
            -- Floor
            Plane({Vector(ts*4, ts*4, 0), 4, 4}, {Vector(0, ts*4, 0), 0, 4}, {Vector(0, 0, 0), 0, 0}, {Vector(ts*4, 0, 0), 4, 0}, Vector(0, 0, 1))
        },
        roof = {
            -- Roof
            Plane({Vector(0, 0, ts*4), 0, 0}, {Vector(0, ts*4, ts*4), 0, 4}, {Vector(ts*4, ts*4, ts*4), 4, 4}, {Vector(ts*4, 0, ts*4), 4, 0}, Vector(0, 0, -1))
        },
        wall = {
            -- Left
            Plane({Vector(0, ts*4, 0), 4, 0}, {Vector(0, ts*4, ts*4), 4, 4}, {Vector(0, 0, ts*4), 0, 4}, {Vector(0, 0, 0), 0, 0}, Vector(1, 0, 0)),

            -- Front
            Plane({Vector(ts*4, ts*4, 0), 4, 0}, {Vector(ts*4, ts*4, ts*4), 4, 4}, {Vector(0, ts*4, ts*4), 0, 4}, {Vector(0, ts*4, 0), 0, 0}, Vector(0, -1, 0))
        },
    }
})

-- Stick the start in (debug)
for i=0, 15 do
    for j=0, 15 do
        if i == 0 and j == 0 then
            SetMapCell(1+j*4, 1+i*4, 0, test)
        elseif i == 0 then
            local rot = 180
            if j%2 == 1 then
                rot = 90
            end

            SetMapCell(1+j*4, 1+i*4, rot, test3)
        elseif i == 15 then
            local rot = 0
            if j%2 == 1 then
                rot = 270
            end

            SetMapCell(1+j*4, 1+i*4, rot, test3)
        else
            SetMapCell(1+j*4, 1+i*4, 0, test2)
        end
    end
end
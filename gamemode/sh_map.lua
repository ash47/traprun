AddCSLuaFile()

-- Map settings
local mapSettings = {
    -- Size of each tile
    tileSize = 64,

    -- Number of tiles in each direction
    xTiles = 16 * 4,
    yTiles = 16 * 4,

    -- Number of physics handlers in each direction
    xPhys = 1,
    yPhys = 1
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

function GetxPhys()
    return mapSettings.xPhys
end

function GetyPhys()
    return mapSettings.yPhys
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

-- Will store our physics handlers
local physCols = {}

function StorePhysCol(xx, yy, ent)
    physCols[xx.."_"..yy] = ent
end

local worldGen
function StoreWorldGen(ent)
    worldGen = ent
end

-- Finds and updates a physics collision handler
function UpdatePhysicsCol(xx, yy, mesh)
    local col = physCols[xx.."_"..yy]
    if not IsValid(col) then
        print("Failed to find physics collision handler for ("..xx..", "..yy..")")
        return
    end

    -- Update the phys mesh
    col:ApplyMesh(mesh)
end

function SendMapEnts(ply)
    if SERVER then
        -- Send list of entities
        net.Start("mapEnts")
        net.WriteEntity(worldGen)
        for xx=1,GetxPhys() do
            for yy=1,GetyPhys() do
                net.WriteEntity(physCols[xx.."_"..yy])
            end
        end
        net.Send(ply)

        -- TEMP:
        UpdateMapFor(ply)
    else
        -- Ask for list of entities
        net.Start("mapEnts")
        net.SendToServer()
    end
end

function UpdateMapFor(ply)
    net.Start("buildMap")
    net.Send(ply)
end

function BuildMap()
    -- Will store our renderable meshes
    local renderMeshes = {}

    -- Reset out physics mesh
    --local physicsMesh = {}
    local physMeshes = {}

    local tileSize = GetTileSize()

    local xTiles = GetxTiles()
    local yTiles = GetyTiles()

    local xPhys = GetxPhys()
    local yPhys = GetyPhys()

    local xPhysi = xTiles/xPhys
    local yPhysi = yTiles/yPhys

    for xx=1,xTiles do
        for yy=1,yTiles do
            -- Grab a cell
            local cell = GetMapCell(xx, yy)
            if cell then
                -- Check if it has a trap in it
                if cell.trapId ~= nil then
                    -- Grab this trap
                    local trap = GetTrap(cell.trapId)
                    local rot = cell.rot

                    -- Check if it has a mesh
                    if trap and trap.mesh then
                        -- Find which physics cell to place this into
                        local physX = math.ceil(xx/xPhysi)
                        local physY = math.ceil(yy/yPhysi)
                        local physName = physX.."_"..physY

                        -- Ensure the table exists
                        physMeshes[physName] = physMeshes[physName] or {}

                        -- Loop over all sections of this mesh
                        for k,v in pairs(trap.mesh) do
                            -- Workout the offsets
                            local o = Vector((xx-1)*tileSize, (yy-1)*tileSize, 0)

                            -- Build rendereable mesh
                            if CLIENT then
                                -- Ensure we have an instance for this mesh
                                renderMeshes[k] = renderMeshes[k] or {}
                            end

                            -- Build meshes
                            for kk, vv in pairs(v) do
                                for kkk, vvv in pairs(vv) do
                                    -- Make a copy of the vertex
                                    local vert = table.Copy(vvv)

                                    local ang = Angle(0, rot, 0)

                                    -- Apply rotation and offset
                                    vert.pos = vert.pos:RotateAbout(ang, Vector(trap.xSize/2*tileSize, trap.ySize/2*tileSize, 0)) + o

                                    -- If it has a normal, rotate it
                                    if vert.normal then
                                        local newNorm = Vector(vert.normal.x, vert.normal.y, vert.normal.z)
                                        newNorm:Rotate(ang)
                                        vert.normal = newNorm
                                    end

                                    -- Add to our renderable mesh
                                    if CLIENT then
                                        table.insert(renderMeshes[k], vert)
                                    end

                                    -- Check if we need physics on this part of the trap
                                    if not trap.nophysics or not trap.nophysics[k] then
                                        -- Add to our physics mesh
                                        table.insert(physMeshes[physName], vert)
                                    end
                                end
                            end

                            -- Remove duplicate triangles from physics mesh
                        end
                    end
                end
            end
        end
    end

    -- Build the renderable meshes
    if CLIENT then
        -- Reset our rendereables
        local rm = {}

        for k,v in pairs(renderMeshes) do
            -- Create the meshes
            rm[k] = Mesh()
            rm[k]:BuildFromTriangles(v)
        end

        -- Apply it to the renderer
        if IsValid(worldGen) then
            worldGen:UpdateMeshes(rm)
        end
    end

    -- Update collisions
    for xx=1,xPhys do
        for yy=1,yPhys do
            UpdatePhysicsCol(xx, yy, physMeshes[xx.."_"..yy])
        end
    end
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
    return {
        Vertex(bottom_right[1], bottom_right[2], bottom_right[3], normal),
        Vertex(top_right[1], top_right[2], top_right[3], normal),
        Vertex(bottom_left[1], bottom_left[2], bottom_left[3], normal),

        Vertex(top_right[1], top_right[2], top_right[3], normal),
        Vertex(top_left[1], top_left[2], top_left[3], normal),
        Vertex(bottom_left[1], bottom_left[2], bottom_left[3], normal)
    }
end

-- Creates a spike
function Spike(pos, radius, height)
    -- Calculate the corners
    local front = pos + Vector(0, -radius, 0)
    local back  = pos + Vector(0, radius, 0)
    local left  = pos + Vector(-radius, 0, 0)
    local right = pos + Vector(radius, 0, 0)
    local top   = pos + Vector(0, 0, height)

    -- Return a spike
    return {
        Vertex(front, 0, 0, Vector(0, 0, 1)),
        Vertex(left, 1, 0, Vector(0, 0, 1)),
        Vertex(top, 0.5, 1, Vector(0, 0, 1)),

        Vertex(left, 0, 0, Vector(0, 0, 1)),
        Vertex(back, 1, 0, Vector(0, 0, 1)),
        Vertex(top, 0.5, 1, Vector(0, 0, 1)),

        Vertex(back, 0, 0, Vector(0, 0, 1)),
        Vertex(right, 1, 0, Vector(0, 0, 1)),
        Vertex(top, 0.5, 1, Vector(0, 0, 1)),

        Vertex(right, 0, 0, Vector(0, 0, 1)),
        Vertex(front, 1, 0, Vector(0, 0, 1)),
        Vertex(top, 0.5, 1, Vector(0, 0, 1)),
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
        spike = {
            -- Middle Row
            Spike(Vector(ts*0.5, ts*2, -ts*4), ts*0.25, ts),
            Spike(Vector(ts*1.5, ts*2, -ts*4), ts*0.25, ts),
            Spike(Vector(ts*2.5, ts*2, -ts*4), ts*0.25, ts),
            Spike(Vector(ts*3.5, ts*2, -ts*4), ts*0.25, ts),

            -- Top Row
            Spike(Vector(ts*1, ts*2.5, -ts*4), ts*0.25, ts),
            Spike(Vector(ts*2, ts*2.5, -ts*4), ts*0.25, ts),
            Spike(Vector(ts*3, ts*2.5, -ts*4), ts*0.25, ts),

            -- Bottom Row
            Spike(Vector(ts*1, ts*1.5, -ts*4), ts*0.25, ts),
            Spike(Vector(ts*2, ts*1.5, -ts*4), ts*0.25, ts),
            Spike(Vector(ts*3, ts*1.5, -ts*4), ts*0.25, ts),
        }
    },
    nophysics = {
        spike = true
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
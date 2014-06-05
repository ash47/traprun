if(SERVER) then return end

-- Creates a client side vertex
function Vertex(pos, u, v, normal)
    return {pos = pos, u = u, v = v, normal = normal}
end

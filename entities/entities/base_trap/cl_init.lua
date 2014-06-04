include("shared.lua")

function ENT:Initialize()
    self.mesh = Mesh()
    self.mesh:BuildFromTriangles(self.MeshTable)

    self:SetRenderBounds(Vector(-10000,-10000,-10000), Vector(10000, 10000, 10000))
end

MeshMaterial = Material("staircase/tester1")

function ENT:Draw( )

    --self:DrawModel( );

    render.SetMaterial( MeshMaterial );

    local matrix = Matrix( );
    matrix:Translate( self:GetPos( ) );
    matrix:Rotate( self:GetAngles( ) );
    --matrix:Scale( Vector( 1, 1, 1 ) );

    local up = Vector( 0, 0, 1 );
    local right = Vector( 1, 0, 0 );
    local forward = Vector( 0, 1, 0 );

    local down = up * -1;
    local left = right * -1;
    local backward = forward * -1;

    cam.PushModelMatrix( matrix );

        --[[mesh.Begin( MATERIAL_QUADS, 6 );

        mesh.QuadEasy( up / 2, up, 1, 1 );
        mesh.QuadEasy( down / 2, down, 1, 1 );

        mesh.QuadEasy( left / 2, left, 1, 1 );
        mesh.QuadEasy( right / 2, right, 1, 1 );

        mesh.QuadEasy( forward / 2, forward, 1, 1 );
        mesh.QuadEasy( backward / 2, backward, 1, 1 );

        mesh.End( );]]--

        self.mesh:Draw()

    cam.PopModelMatrix( );

end

extends Spatial

# the Map this Chunk is a part of
var map = null

# all voxel types contained in this chunk are stored here
var voxels = null
var origin = Vector3.ZERO
var chunk_size = null

# render mesh vertices and a copy of the mesh
var mesh 
var mesh_vertices
var mesh_normals
var mesh_indices
var mesh_uvs

# collision mesh vertices and a copy of the mesh
var collision_mesh
var collision_mesh_vertices
var collision_mesh_indices

onready var mesh_instance = get_node("MeshInstance");
onready var collision_shape = get_node("StaticBody/CollisionShape");
onready var st = SurfaceTool.new();


func initialize(new_map, new_origin, new_chunk_size):
    """Initialize voxels to chunk_size x chunk_size x chunk_size array
        and set the origin of this chunk appropriately
    """
    map = new_map
    origin = new_origin
    chunk_size = new_chunk_size
    
    voxels = []
    for x in range(0, chunk_size):
        voxels.append([])
        for y in range(0, chunk_size):
            voxels[x].append([])
            for _z in range(0, chunk_size):
                voxels[x][y].append(null)
            
    global_transform.origin = origin
    

func contains(coords):
    """Return true iff this chunk contains the specified Vector3 coords"""
    if coords.x < origin.x or coords.x >= origin.x + chunk_size:
        return false
    if coords.y < origin.y or coords.y >= origin.y + chunk_size:
        return false
    if coords.z < origin.z or coords.z >= origin.z + chunk_size:
        return false
    
    return true


func add_voxel(coords, type):
    """Add a voxel to this chunk at the specified Vector3 coordinates"""
    if not contains(coords):
        return null
    
    var idx = coords - origin
    voxels[idx.x][idx.y][idx.z] = type
    
    return type
   

func update_mesh():
    """Recreate the meshes for this chunk""" 
    mesh_vertices = [];
    mesh_normals = [];
    mesh_indices = [];
    mesh_uvs = [];
    
    collision_mesh_vertices = [];
    collision_mesh_indices = [];
    
    create_render_mesh()
    create_collision_mesh()


func create_render_mesh():
    """create mesh for rendering"""
    
    for x in range(0, chunk_size):
        for y in range(0, chunk_size):
            for z in range(0, chunk_size):
                make_voxel(Vector3(x, y, z));
    
    st.clear();
    st.begin(Mesh.PRIMITIVE_TRIANGLES);
    
    # add normal, uv and vertices in that order.
    for i in range(0, mesh_vertices.size()):
        st.add_normal(mesh_normals[i]);
        st.add_uv(mesh_uvs[i]);
        st.add_vertex(mesh_vertices[i]);
    
    # Now add indices and generate tangents.
    for i in range(0, mesh_indices.size()):
        st.add_index(mesh_indices[i]);    
    st.generate_tangents();
    
    # Now create the mesh and update MeshInstance
    mesh = st.commit();
    mesh_instance.mesh = mesh;
    

func make_voxel(idx):
    
    var type = voxels[idx.x][idx.y][idx.z]
    if type == null:
        return
    
    for normal in [Vector3.UP, Vector3.DOWN, Vector3.FORWARD, Vector3.BACK, Vector3.LEFT, Vector3.RIGHT]:
        var test_idx = idx + normal
        if contains(origin + test_idx):
            var test_voxel = voxels[test_idx.x][test_idx.y][test_idx.z]
            if test_voxel == null or Voxel.properties[test_voxel].transparent:
                make_voxel_face(Voxel.offsets[normal], idx, normal, type)
        else:
            make_voxel_face(Voxel.offsets[normal], idx, normal, type)


func make_voxel_face(offsets, coords, normal, type):
    """Make the voxel face with supplied vertices. Requires that vertices are supplied in clockwise
    winding order when looking at the face from the side normal points towards."""
    var is_solid = Voxel.properties[type].solid
    
    for offset in offsets:
        var vertex = coords + offset
        mesh_vertices.append(vertex)
        mesh_normals.append(normal)
        if is_solid:
            collision_mesh_vertices.append(vertex)
    
    var uv_position = Voxel.properties[type][normal];
    var v_texture_unit = Voxel.UV_MAP_UNIT;
    mesh_uvs.append(Vector2( (v_texture_unit * uv_position.x), (v_texture_unit * uv_position.y) + v_texture_unit));
    mesh_uvs.append(Vector2( (v_texture_unit * uv_position.x) + v_texture_unit, (v_texture_unit * uv_position.y) + v_texture_unit));
    mesh_uvs.append(Vector2( (v_texture_unit * uv_position.x) + v_texture_unit, (v_texture_unit * uv_position.y)) );
    mesh_uvs.append(Vector2( (v_texture_unit * uv_position.x), (v_texture_unit * uv_position.y) ));
    
    # Add the triangles to render_mesh_indices.
    # NOTE: Like with the UV, the order is important!
    # The indices tell the surface tool how to connect the vertices to make triangles.
    mesh_indices.append(mesh_vertices.size() - 4);
    mesh_indices.append(mesh_vertices.size() - 3);
    mesh_indices.append(mesh_vertices.size() - 1);
    mesh_indices.append(mesh_vertices.size() - 3);
    mesh_indices.append(mesh_vertices.size() - 2);
    mesh_indices.append(mesh_vertices.size() - 1);
    
    # Add the collision triangles, but only if the voxel is solid.
    # Like with the other two, the order is important!
    if is_solid:
        collision_mesh_indices.append(mesh_vertices.size() - 4);
        collision_mesh_indices.append(mesh_vertices.size() - 3);
        collision_mesh_indices.append(mesh_vertices.size() - 1);
        collision_mesh_indices.append(mesh_vertices.size() - 3);
        collision_mesh_indices.append(mesh_vertices.size() - 2);
        collision_mesh_indices.append(mesh_vertices.size() - 1);


func create_collision_mesh():
    """Create the collision mesh u bum"""
    
    st.clear();
    st.begin(Mesh.PRIMITIVE_TRIANGLES);
    
    # Just add the vertices and indices to the surface tool, in order.
    for i in range(0, collision_mesh_vertices.size()):
        st.add_vertex(collision_mesh_vertices[i]);
    for i in range(0, collision_mesh_indices.size()):
        st.add_index(collision_mesh_indices[i]);

    # create a trimesh collision shape and set the CollisionShape 
    collision_mesh = st.commit();
    collision_shape.shape = collision_mesh.create_trimesh_shape();
    

func _on_StaticBody_input_event(_camera, event, position, normal, _shape_idx):
    """Call the map click delegate's on_map_click method, if it's set."""
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            if map and map.click_delegate:
                var coords = (position - 0.5*normal).floor()
                map.click_delegate.on_map_click(coords, normal)

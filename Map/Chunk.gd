extends Spatial

# the Map this Chunk is a part of
var map = null

# all voxel types contained in this chunk are stored here
var voxels = null
var origin = Vector3.ZERO
var chunk_size = null

# render mesh vertices, uvs, indices, normals for each face type
var mesh_data

# collision mesh vertices and a copy of the mesh
var collision_mesh_vertices
var collision_mesh_indices

onready var meshes = { 
                        Voxel.STONE_FACE:$StoneMeshInstance, Voxel.BEDROCK_FACE:$BedrockMeshInstance, 
                        Voxel.COBBLE_FACE:$CobbleMeshInstance, Voxel.DIRT_FACE:$DirtMeshInstance, 
                        Voxel.GRASS_TOP_FACE:$GrassTopMeshInstance, Voxel.GRASS_SIDE_FACE:$GrassSideMeshInstance
                      }

onready var collision_shape = $StaticBody/CollisionShape
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
    """Recreate the meshes for this chunk.""" 
    mesh_data = {
                    Voxel.STONE_FACE      : {"vertices":[], "normals":[], "indices":[], "uvs":[]}, 
                    Voxel.BEDROCK_FACE    : {"vertices":[], "normals":[], "indices":[], "uvs":[]}, 
                    Voxel.COBBLE_FACE     : {"vertices":[], "normals":[], "indices":[], "uvs":[]}, 
                    Voxel.DIRT_FACE       : {"vertices":[], "normals":[], "indices":[], "uvs":[]}, 
                    Voxel.GRASS_TOP_FACE  : {"vertices":[], "normals":[], "indices":[], "uvs":[]}, 
                    Voxel.GRASS_SIDE_FACE : {"vertices":[], "normals":[], "indices":[], "uvs":[]}, 
                }
    collision_mesh_vertices = []
    collision_mesh_indices = []
    
    create_render_mesh()
    create_collision_mesh()


func create_render_mesh():
    """create mesh for rendering"""
    
    for x in range(0, chunk_size):
        for y in range(0, chunk_size):
            for z in range(0, chunk_size):
                make_voxel(Vector3(x, y, z))
    
    for face_type in mesh_data:
        var data = mesh_data[face_type]
        
        st.clear();
        st.begin(Mesh.PRIMITIVE_TRIANGLES);
    
        # add normal, uv and vertices in that order.
        for i in range(0, data.vertices.size()):
            st.add_normal(data.normals[i])
            st.add_uv(data.uvs[i])
            st.add_vertex(data.vertices[i])
        
        # Now add indices and generate tangents.
        for i in range(0, data.indices.size()):
            st.add_index(data.indices[i])  
        
        # Now create the mesh and update the MeshInstace for each type of face
        meshes[face_type].mesh = st.commit()


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
    
    var face_type = Voxel.properties[type][normal] 
    for offset in offsets:
        var vertex = coords + offset
        mesh_data[face_type].vertices.append(vertex)
        mesh_data[face_type].normals.append(normal)
        if is_solid:
            collision_mesh_vertices.append(vertex)
    
    # add UV coordinates for the vertices
    mesh_data[face_type].uvs.append(Vector2(0, 1))
    mesh_data[face_type].uvs.append(Vector2(1, 1))
    mesh_data[face_type].uvs.append(Vector2(1, 0))
    mesh_data[face_type].uvs.append(Vector2(0, 0))
    
    # Add indices for the vertices
    var num_vertices = mesh_data[face_type].vertices.size()
    mesh_data[face_type].indices.append(num_vertices - 4)
    mesh_data[face_type].indices.append(num_vertices - 3)
    mesh_data[face_type].indices.append(num_vertices - 1)
    mesh_data[face_type].indices.append(num_vertices - 3)
    mesh_data[face_type].indices.append(num_vertices - 2)
    mesh_data[face_type].indices.append(num_vertices - 1)
    
    # create a collision mesh for this face if it is solid
    if is_solid:
        var num_collision_vertices = collision_mesh_vertices.size()
        collision_mesh_indices.append(num_collision_vertices - 4)
        collision_mesh_indices.append(num_collision_vertices - 3)
        collision_mesh_indices.append(num_collision_vertices - 1)
        collision_mesh_indices.append(num_collision_vertices - 3)
        collision_mesh_indices.append(num_collision_vertices - 2)
        collision_mesh_indices.append(num_collision_vertices - 1)


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
    var collision_mesh = st.commit();
    collision_shape.shape = collision_mesh.create_trimesh_shape();
    

func _on_StaticBody_input_event(_camera, event, position, normal, _shape_idx):
    """Call the map click delegate's on_map_click method, if it's set."""
    if event is InputEventMouseButton:
        if event.button_index == BUTTON_LEFT and event.pressed:
            if map and map.click_delegate:
                var coords = (position - 0.5*normal).floor()
                map.click_delegate.on_map_click(coords, normal)

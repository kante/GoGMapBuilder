extends Spatial


# hold all created voxel types here
var voxels = null

var mesh 
var mesh_vertices
var mesh_normals
var mesh_indices
var mesh_uvs

var collision_mesh
var collision_mesh_vertices
var collision_mesh_indices

onready var mesh_instance = get_node("MeshInstance");
onready var collision_shape = get_node("StaticBody/CollisionShape");
onready var st = SurfaceTool.new();


func initialize(chunk_origin, chunk_size):
    voxels = []
    for x in range(0, chunk_size):
        voxels.append([])
        for y in range(0, chunk_size):
            voxels[x].append([])
            for _z in range(0, chunk_size):
                voxels[x][y].append(null)
            
    global_transform.origin = chunk_origin


func add_voxel(x, y, z, type):
    """Add a voxel to this chunk at the specified coordinates"""
    print("ya add one u bitch")
    

func create_mesh():
    """create mesh u bum"""
    mesh_vertices = [];
    mesh_normals = [];
    mesh_indices = [];
    mesh_uvs = [];

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
    

func create_collision_mesh():
    """Create the collision mesh u bum"""
    collision_mesh_vertices = [];
    collision_mesh_indices = [];
    
    st.clear();
    st.begin(Mesh.PRIMITIVE_TRIANGLES);
    
    # Just add the vertices and indices to the surface tool, in order.
    for i in range(0, collision_mesh_vertices.size()):
        st.add_vertex(collision_mesh_vertices[i]);
    for i in range(0, collision_mesh_indices.size()):
        st.add_index(collision_mesh_indices[i]);

    # now create a trimesh collision shape and set the CollisionShape appropriately
    collision_mesh = st.commit();
    collision_shape.shape = collision_mesh.create_trimesh_shape();
    


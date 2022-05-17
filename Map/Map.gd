extends Spatial

# base Chunk scene to render a chunk_size x chunk_size x chunk_size cube in the map
var chunk_prototype = preload("res://Map/Chunk.tscn");

# container to hold all the Chunk nodes we have generated
onready var chunk_nodes = $Chunks;

# set in initialize_map (see func comment for details
var click_delegate = null
var chunk_size = null
var voxel_map = null
var chunk_dict = {}


func initialize_map(new_click_delegate, new_chunk_size, new_voxel_map):
    """ Initialize and render the supplied new_voxel_map
    
    new_click_delegate - Must implement on_map_click(coords, normal)
    new_chunk_size - positive integer Chunk size (3D cube of width new_chunk_size)
    new_voxel_map - dictionary indexed by Vector3 chunk_index where world space origin of each Chunk
                    is defined by chunk_index * chunk_size. Values are a 3D array of integers with
                    values null (no voxel) or the voxel type defined in Voxel.gd
    """
    click_delegate = new_click_delegate
    chunk_size = new_chunk_size
    voxel_map = new_voxel_map
    
    build_and_render_chunks()


func build_and_render_chunks():
    """Go through the voxel chunks defined in map, create Chunk nodes and their render meshes."""
    for chunk_index in voxel_map:
        var chunk_voxels = voxel_map[chunk_index]
        var new_chunk = chunk_prototype.instance()
        
        chunk_nodes.add_child(new_chunk)
        chunk_dict[chunk_index] = new_chunk 
            
        new_chunk.initialize(self, chunk_size*chunk_index, chunk_size) 
        new_chunk.voxels = chunk_voxels
        new_chunk.update_mesh()


func add_voxel(coords, type):
    """Add a voxel of the specified type at the supplied_coordinates
    """
    var chunk_index = (coords / chunk_size).floor()
    var created_voxel = null
    if chunk_index in voxel_map:
        created_voxel = chunk_dict[chunk_index].add_voxel(coords, type)
    else:
        var new_chunk = chunk_prototype.instance()
        var chunk_origin = chunk_size * chunk_index
        
        chunk_nodes.add_child(new_chunk)
        new_chunk.initialize(self, chunk_origin, chunk_size) 
        chunk_dict[chunk_index] = new_chunk
        created_voxel = new_chunk.add_voxel(coords, type)
            
    chunk_dict[chunk_index].update_mesh()
    
    return created_voxel


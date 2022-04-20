extends Spatial


var chunk_prototype = preload("res://VoxelMap/Chunk.tscn");
onready var chunks = $Chunks;


func _ready():
    var num_chunks_x = 8
    var num_chunks_y = 8
    var chunk_size = 16
    var map = build_starting_terrain_map(num_chunks_x, num_chunks_y, chunk_size)
    
    for origin in map:
        var chunk_map = map[origin]
        var new_chunk = chunk_prototype.instance();
        chunks.add_child(new_chunk);
        new_chunk.initialize(chunk_size*origin, chunk_size) 
        new_chunk.voxels = chunk_map
        new_chunk.update_mesh()


func build_starting_terrain_map(num_chunks_x, num_chunks_z, chunk_size):
    """Return a 3D array map with a flat plane of grass->dirt->cobble->stone->bedrock"""
    var map = {}
    var chunk_map = build_starting_chunk_map(chunk_size)
    
    for i in range(-num_chunks_x/2, num_chunks_x/2):
        for j in range(-num_chunks_z/2, num_chunks_z/2):
            map[Vector3(i, -1, j)] = chunk_map.duplicate(true)
    
    return map


func build_starting_chunk_map(chunk_size):
    var map = []
    for x in range(0, chunk_size):
        map.append([])
        for y in range(0, chunk_size):
            map[x].append([])
            for _z in range(0, chunk_size):
                if y == chunk_size - 1:
                        map[x][y].append(Voxel.GRASS)
                elif y in [chunk_size-2, chunk_size-3, chunk_size-4]:
                        map[x][y].append(Voxel.DIRT)
                elif y == chunk_size - 5:
                        map[x][y].append(Voxel.COBBLE)
                elif y == chunk_size - 6:
                        map[x][y].append(Voxel.STONE)
                elif y == chunk_size - 7:
                        map[x][y].append(Voxel.BEDROCK)
                else:
                        map[x][y].append(null)
    return map
                
                


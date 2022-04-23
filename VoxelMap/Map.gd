extends Spatial

# object to send click events to. Must implement on_map_click(coords, normal)
var click_delegate = null


var chunk_prototype = preload("res://VoxelMap/Chunk.tscn");
onready var chunks = $Chunks;


# TODO: woow put these somewhere, rename chunk_map, rename map, map.map durbpee durp mapapeeeeee
var num_chunks_x = 10
var num_chunks_z = 10
var chunk_size = 16
var map = build_starting_terrain_map()
var chunk_shit = {}

func _ready():
    """Some shit initialization of this shit map. Just playing around for now..."""
    for origin in map:
        var chunk_map = map[origin]
        var new_chunk = chunk_prototype.instance()
        
        chunks.add_child(new_chunk)
        chunk_shit[origin] = new_chunk # ya.... TODO: refactor is next after this fucking clikey poo add block is done
            
        new_chunk.initialize(self, chunk_size*origin, chunk_size) 
        new_chunk.voxels = chunk_map
        new_chunk.update_mesh()


func add_voxel(coords, type):
    """Add a voxel of the specified type at the supplied_coordinates
        
        TODO: rename chunk to chunk_origin  here i thinkeee or chunk index.. .fuck i dunno... thinks bout this stuff soononn
    """
    var chunk = (coords / chunk_size).floor()
    if chunk in map:
        return chunk_shit[chunk].add_voxel(coords, type)
    else:
        var new_chunk = chunk_prototype.instance()
        chunks.add_child(new_chunk)
        new_chunk.initialize(self, chunk_size*chunk, chunk_size) 
        chunk_shit[chunk] = new_chunk
        new_chunk.add_voxel(coords, type)
            
    chunk_shit[chunk].update_mesh()


func build_starting_terrain_map():
    """Return a 3D array map with a flat plane of grass->dirt->cobble->stone->bedrock"""
    var new_map = {}
    var chunk_map = build_starting_chunk_map()
    
    for i in range(-num_chunks_x/2, num_chunks_x/2):
        for j in range(-num_chunks_z/2, num_chunks_z/2):
            new_map[Vector3(i, -1, j)] = chunk_map.duplicate(true)
    
    return new_map


func build_starting_chunk_map():
    var chunk_map = []
    for x in range(0, chunk_size):
        chunk_map.append([])
        for y in range(0, chunk_size):
            chunk_map[x].append([])
            for _z in range(0, chunk_size):
                if y == chunk_size - 1:
                        chunk_map[x][y].append(Voxel.GRASS)
                elif y in [chunk_size-2, chunk_size-3, chunk_size-4]:
                        chunk_map[x][y].append(Voxel.DIRT)
                elif y == chunk_size - 5:
                        chunk_map[x][y].append(Voxel.COBBLE)
                elif y == chunk_size - 6:
                        chunk_map[x][y].append(Voxel.STONE)
                elif y == chunk_size - 7:
                        chunk_map[x][y].append(Voxel.BEDROCK)
                else:
                        chunk_map[x][y].append(null)
    return chunk_map
                
                


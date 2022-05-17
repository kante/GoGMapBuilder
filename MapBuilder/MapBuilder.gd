extends Spatial


# Declare member variables here. Examples:
onready var player = $Player
onready var camera = $Player/Camera
onready var input_ui = CombatInputUI.new()
onready var map = $Map
onready var hud = $MapBuilderHUD


# Called when the node enters the scene tree for the first time.
func _ready():
    camera.follow_combatant(player)

    # build a really basic starting map and initialize it TODO: saving and loading maps!
    var chunk_size = 16
    var voxel_map = build_starting_terrain_map(10, 10, chunk_size)
    map.initialize_map(self, chunk_size, voxel_map)
      

func build_starting_terrain_map(num_chunks_x, num_chunks_z, chunk_size):
    """Return a 3D array map with a flat plane of grass->dirt->cobble->stone->bedrock. maps are 
    indexed by Vector3 chunk_index (see Map.gd) and """
    var voxel_map = {}
    var chunk_voxels = build_starting_chunk_voxels(chunk_size)
    
    for i in range(-num_chunks_x/2, num_chunks_x/2):
        for j in range(-num_chunks_z/2, num_chunks_z/2):
            var chunk_index = Vector3(i, -1, j)
            voxel_map[chunk_index] = chunk_voxels.duplicate(true)
    
    return voxel_map


func build_starting_chunk_voxels(chunk_size):
    """Just create a chunk_size ^ 3 3D array of voxels with gras->dirt->cobble->stone->bedrock at 
    the top. Completely flat terrain with no features."""
    var chunk_voxels = []
    for x in range(0, chunk_size):
        chunk_voxels.append([])
        for y in range(0, chunk_size):
            chunk_voxels[x].append([])
            for _z in range(0, chunk_size):
                if y == chunk_size - 1:
                        chunk_voxels[x][y].append(Voxel.GRASS)
                elif y in [chunk_size-2, chunk_size-3, chunk_size-4]:
                        chunk_voxels[x][y].append(Voxel.DIRT)
                elif y == chunk_size - 5:
                        chunk_voxels[x][y].append(Voxel.COBBLE)
                elif y == chunk_size - 6:
                        chunk_voxels[x][y].append(Voxel.STONE)
                elif y == chunk_size - 7:
                        chunk_voxels[x][y].append(Voxel.BEDROCK)
                else:
                        chunk_voxels[x][y].append(null)
    return chunk_voxels


func _unhandled_input(event):
    """all mouse/multitouch.key UI is done through the input_ui node."""
    input_ui.handle_input(event, self)
               
                
func on_map_click(coords, normal):
    """map.click_delegate method
        Create a new voxel in this map at the specified coords!
        
        TODO: should this stuff should go through input_ui or an extended/refactored ui class?
    """    
    var voxel = map.add_voxel(coords + normal, hud.voxel_type)
    print("made a ", Voxel.properties[voxel].name)



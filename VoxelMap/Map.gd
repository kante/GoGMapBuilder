extends Spatial


var chunk_prototype = preload("res://VoxelMap/Chunk.tscn");
onready var chunks = $Chunks;


func _ready():
    var new_chunk = chunk_prototype.instance();
    chunks.add_child(new_chunk);
    
    # i think we will have Map.gd organize the chunks and keep track of all
    # their origins. Chunk is dumb and just knows where it is
    new_chunk.initialize(Vector3.ZERO, 16)
    var voxel = new_chunk.add_voxel(Vector3(3,1,3), Voxel.GRASS)
    voxel = new_chunk.add_voxel(Vector3(2,1,2), Voxel.GRASS)
    voxel = new_chunk.add_voxel(Vector3(1,1,1), Voxel.GRASS)
    
    new_chunk.update_mesh()
    



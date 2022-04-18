extends Spatial


var chunk_prototype = preload("res://VoxelMap/Chunk.tscn");
onready var chunks = $Chunks;


# Called when the node enters the scene tree for the first time.
func _ready():
    var new_chunk = chunk_prototype.instance();
    chunks.add_child(new_chunk);
    new_chunk.initialize(Vector3.ZERO, 16)
    new_chunk.add_voxel(3, 3, 3, Voxel.GRASS)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass

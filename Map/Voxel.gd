extends Node

class_name Voxel

# The size of each voxel in 3D world coordinates
const VOXEL_SIZE = 1

# The size of the texture and each sub tile to place on the Voxel mesh
const TEXTURE_SIZE = 3072
const TILE_MARGIN = 200
const TILE_SIZE = 1024
const UV_TILE_UNIT = 1.0 / (float(TEXTURE_SIZE) / float(TILE_SIZE))
const UV_TILE_MARGIN = 1.0 / (float(TEXTURE_SIZE) / float(TILE_MARGIN))
const UV_MAP_UNIT = UV_TILE_UNIT - 2.0*UV_TILE_MARGIN

# All the voxel types we have implemented
enum {GRASS, DIRT, COBBLE, STONE, BEDROCK}
# All the possible faces for each voxel
enum {GRASS_TOP_FACE, GRASS_SIDE_FACE, DIRT_FACE, COBBLE_FACE, STONE_FACE, BEDROCK_FACE}

# offset vectors used to add vertices to voxel meshes in clockwise winding order
#   dictionary keys are the normal direction facing away from the voxel surface
const offsets = {
                    Vector3.UP     : [  Vector3(0, VOXEL_SIZE, 0),
                                        Vector3(VOXEL_SIZE, VOXEL_SIZE, 0),
                                        Vector3(VOXEL_SIZE, VOXEL_SIZE, VOXEL_SIZE),
                                        Vector3(0, VOXEL_SIZE, VOXEL_SIZE)],
                    Vector3.DOWN   : [  Vector3(0, 0, VOXEL_SIZE),
                                        Vector3(VOXEL_SIZE, 0, VOXEL_SIZE),
                                        Vector3(VOXEL_SIZE, 0, 0),
                                        Vector3(0, 0, 0)],
                    Vector3.FORWARD: [  Vector3(0, 0, 0),
                                        Vector3(VOXEL_SIZE, 0, 0),
                                        Vector3(VOXEL_SIZE, VOXEL_SIZE, 0),
                                        Vector3(0, VOXEL_SIZE, 0)],
                    Vector3.BACK   : [  Vector3(VOXEL_SIZE, 0, VOXEL_SIZE),
                                        Vector3(0, 0, VOXEL_SIZE),
                                        Vector3(0, VOXEL_SIZE, VOXEL_SIZE),
                                        Vector3(VOXEL_SIZE, VOXEL_SIZE, VOXEL_SIZE)],
                    Vector3.LEFT   : [  Vector3(0, 0, VOXEL_SIZE),
                                        Vector3(0, 0, 0),
                                        Vector3(0, VOXEL_SIZE, 0),
                                        Vector3(0, VOXEL_SIZE, VOXEL_SIZE)],
                    Vector3.RIGHT  : [  Vector3(VOXEL_SIZE, 0, 0),
                                        Vector3(VOXEL_SIZE, 0, VOXEL_SIZE),
                                        Vector3(VOXEL_SIZE, VOXEL_SIZE, VOXEL_SIZE),
                                        Vector3(VOXEL_SIZE, VOXEL_SIZE, 0)]
                }


# properties required to define the uv map and render and collision meshes for a voxel
const properties = {
                        STONE : {
                                    "name" : "stone",
                                    "transparent":false,
                                    "solid":true,
                                    Vector3.UP:STONE_FACE,
                                    Vector3.DOWN:STONE_FACE,
                                    Vector3.FORWARD:STONE_FACE,
                                    Vector3.BACK:STONE_FACE,
                                    Vector3.LEFT:STONE_FACE,
                                    Vector3.RIGHT:STONE_FACE
                                },
                        BEDROCK : {
                                    "name" : "bedrock",
                                    "transparent":false,
                                    "solid":true,
                                    Vector3.UP:BEDROCK_FACE,
                                    Vector3.DOWN:BEDROCK_FACE,
                                    Vector3.FORWARD:BEDROCK_FACE,
                                    Vector3.BACK:BEDROCK_FACE,
                                    Vector3.LEFT:BEDROCK_FACE,
                                    Vector3.RIGHT:BEDROCK_FACE
                                },
                        COBBLE : {
                                    "name" : "cobble",
                                    "transparent":false,
                                    "solid":true,
                                    Vector3.UP:COBBLE_FACE,
                                    Vector3.DOWN:COBBLE_FACE,
                                    Vector3.FORWARD:COBBLE_FACE,
                                    Vector3.BACK:COBBLE_FACE,
                                    Vector3.LEFT:COBBLE_FACE,
                                    Vector3.RIGHT:COBBLE_FACE
                                },
                        DIRT : {
                                    "name" : "dirt",
                                    "transparent":false,
                                    "solid":true,
                                    Vector3.UP:DIRT_FACE,
                                    Vector3.DOWN:DIRT_FACE,
                                    Vector3.FORWARD:DIRT_FACE,
                                    Vector3.BACK:DIRT_FACE,
                                    Vector3.LEFT:DIRT_FACE,
                                    Vector3.RIGHT:DIRT_FACE
                                },
                        GRASS : {
                                    "name" : "grass",
                                    "transparent":false,
                                    "solid":true,
                                    Vector3.UP:GRASS_TOP_FACE,
                                    Vector3.DOWN:DIRT_FACE,
                                    Vector3.FORWARD:GRASS_SIDE_FACE,
                                    Vector3.BACK:GRASS_SIDE_FACE,
                                    Vector3.LEFT:GRASS_SIDE_FACE,
                                    Vector3.RIGHT:GRASS_SIDE_FACE
                                },
                    }

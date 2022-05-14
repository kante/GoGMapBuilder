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
                                    Vector3.UP:Vector2(0, 0),
                                    Vector3.DOWN:Vector2(0, 0),
                                    Vector3.FORWARD:Vector2(0, 0),
                                    Vector3.BACK:Vector2(0, 0),
                                    Vector3.LEFT:Vector2(0, 0),
                                    Vector3.RIGHT:Vector2(0, 0)
                                },
                        BEDROCK : {
                                    "name" : "bedrock",
                                    "transparent":false,
                                    "solid":true,
                                    Vector3.UP:Vector2(2, 0),
                                    Vector3.DOWN:Vector2(2, 0),
                                    Vector3.FORWARD:Vector2(2, 0),
                                    Vector3.BACK:Vector2(2, 0),
                                    Vector3.LEFT:Vector2(2, 0),
                                    Vector3.RIGHT:Vector2(2, 0)
                                },
                        COBBLE : {
                                    "name" : "cobble",
                                    "transparent":false,
                                    "solid":true,
                                    Vector3.UP:Vector2(1, 0),
                                    Vector3.DOWN:Vector2(1, 0),
                                    Vector3.FORWARD:Vector2(1, 0),
                                    Vector3.BACK:Vector2(1, 0),
                                    Vector3.LEFT:Vector2(1, 0),
                                    Vector3.RIGHT:Vector2(1, 0)
                                },
                        DIRT : {
                                    "name" : "dirt",
                                    "transparent":false,
                                    "solid":true,
                                    Vector3.UP:Vector2(0, 1),
                                    Vector3.DOWN:Vector2(0, 1),
                                    Vector3.FORWARD:Vector2(0, 1),
                                    Vector3.BACK:Vector2(0, 1),
                                    Vector3.LEFT:Vector2(0, 1),
                                    Vector3.RIGHT:Vector2(0, 1)
                                },
                        GRASS : {
                                    "name" : "grass",
                                    "transparent":false,
                                    "solid":true,
                                    Vector3.UP:Vector2(2, 1),
                                    Vector3.DOWN:Vector2(0, 1),
                                    Vector3.FORWARD:Vector2(1, 1),
                                    Vector3.BACK:Vector2(1, 1),
                                    Vector3.LEFT:Vector2(1, 1),
                                    Vector3.RIGHT:Vector2(1, 1)
                                },
                    }

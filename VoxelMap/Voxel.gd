extends Node

class_name Voxel

# The size of each voxel in 3D world coordinates
const VOXEL_SIZE = 1

# The size of the texture and each sub tile to place on the Voxel mesh
const TEXTURE_SIZE = 96
const TILE_SIZE = 32
const UV_MAP_UNIT = 1.0 / (TEXTURE_SIZE / TILE_SIZE)

# All the voxel types we have implemented
enum {STONE, BEDROCK, COBBLE, DIRT, GRASS}


# offset vectors used to add vertices to voxel meshes in clockwise winding order
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

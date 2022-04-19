extends Node

class_name Voxel


const VOXEL_SIZE = 1


const TEXTURE_SIZE = 96
const TILE_SIZE = 32
const UV_MAP_UNIT = 1.0 / (TEXTURE_SIZE / TILE_SIZE)


const STONE = 1
const BEDROCK = 2
const COBBLE = 3
const DIRT = 4
const GRASS = 5


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

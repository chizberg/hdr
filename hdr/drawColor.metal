//
//  drawColor.metal
//  hdr
//
//  Created by Alexey Sherstnev on 30.09.2024.
//

#include <metal_stdlib>
using namespace metal;

kernel void drawColor(
    constant float4 &color [[buffer(0)]],
    texture2d<float, access::write> texture [[texture(0)]],
    uint2 global_id [[thread_position_in_grid]]
) {
    texture.write(color, global_id);
}

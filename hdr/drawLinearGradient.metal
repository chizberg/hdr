//
//  drawLinearGradient.metal
//  hdr
//
//  Created by Alexey Sherstnev on 01.10.2024.
//

#include <metal_stdlib>
using namespace metal;

kernel void drawLinearGradient (
    constant float4* fromColor [[buffer(0)]],
    constant float2* fromPosition [[buffer(1)]],
    constant float4* toColor [[buffer(2)]],
    constant float2* toPosition [[buffer(3)]],
    texture2d<float, access::write> texture [[texture(0)]],
    uint2 global_id [[thread_position_in_grid]]
) {
    // Get the texture size
    uint width = texture.get_width();
    uint height = texture.get_height();
    float2 textureSize = float2(width, height);

    // Normalize pixel position to [0, 1]
    float2 pixelPosition = float2(global_id) / textureSize;

    // Calculate the gradient vector (direction from start to end)
    float2 gradientVector = *toPosition - *fromPosition;

    // Calculate the vector from the start position to the current pixel
    float2 pixelVector = pixelPosition - *fromPosition;

    // Calculate the length squared of the gradient vector
    float gradientLengthSquared = dot(gradientVector, gradientVector);

    // Initialize interpolation factor
    float t = 0.0;

    // Avoid division by zero
    if (gradientLengthSquared != 0.0) {
        // Project pixelVector onto gradientVector to find t
        t = dot(pixelVector, gradientVector) / gradientLengthSquared;
        // Clamp t to [0, 1] to stay within the gradient range
        t = clamp(t, 0.0, 1.0);
    }

    // Interpolate between fromColor and toColor based on t
    float4 color = mix(*fromColor, *toColor, t);

    // Write the interpolated color to the texture at the current pixel
    texture.write(color, global_id);
}

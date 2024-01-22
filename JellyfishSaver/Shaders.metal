//
//  Shaders.metal
//  EquationGraphics
//
//  Created by Eskil Gjerde Sviggum on 27/11/2023.
//

#include <metal_stdlib>
using namespace metal;
#include <SwiftUI/SwiftUI_Metal.h>

float3 palette(float t) {
    float3 offsets = float3(M_PI_F, 2 * M_PI_F / 3 - M_PI_F, 0);
    return 0.5 * cos(M_2_PI_F * t - offsets) + 0.5;
}

float magnitude(float2 c) {
    return sqrt(pow(c.x, 2) + pow(c.y, 2));
}

float argument(float2 c) {
    return atan2(c.y, c.x);
}

float2 complexPow(float2 c1, float power) {
    float magn = pow(magnitude(c1), power);
    float arg = power * argument(c1);
    
    return float2(magn * cos(arg), magn * sin(arg));
}

float2 rotate(float2 c1, float angle) {
    float magn = magnitude(c1);
    float arg = argument(c1) + angle;
    
    return float2(magn * cos(arg), magn * sin(arg));
}

/// Mirrored smoothsteep curve.
/// @@
///   @@@@
///       @@@
///          @@@
///            @@@
///              @@@
///                @@@
///                   @@@
///                     @@@
///                        @@@@@
float nsmoothstep (float edge0, float edge1, float x) {
   x = saturate((x - edge0) / (edge1 - edge0));

   return -(x * x) * (3.0f - 2.0f * x) + 1;
}

/// Skips a section of a function. In effect a fancy step function.
///@@@@@@@@@@
///                                        
///
///          @@@@@@@@@@
float skipSection(float radius, float offset, float value) {
    if (value > offset) {
        return value + radius;
    }
    
    if (value < offset) {
        return value - radius;
    }
    
    return value;
}

                                        
/// Bounces between two values in a linear way.
///                  @@@@*
///                @@@. @@@
///              @@@       @@@             
///           ,@@@           @@@           
///         @@@                @@@
///       @@@                     @@@
///     @@@                         @@@    
///  @@@/                             @@@/
float bounceBetweenLin(float start, float endIn, float value) {
    float end = endIn - start;
    float phased = fmod(value, 2 * end);
    if (phased < end) {
        return phased + start;
    } else {
        return (2 * end - phased) + start;
    }
}

[[stitchable]] half4 shadeFunction(float2 position, SwiftUI::Layer layer, float2 size, float tIn, float sections, float iterations, float angularSeparation) {
    
    float tOffset = 2 * M_PI_F;
    float t = tIn + tOffset;
    float niceMultiple = 3 * M_PI_F / 2;
    float bouncedT = bounceBetweenLin(-6 * niceMultiple, 6 * niceMultiple, tIn);
    float skippedT = skipSection(niceMultiple + tOffset, 0, bouncedT);
    float2 uvN = (2 * (position / size) - 1);
    float2 uvN2 = complexPow(uvN, sections);
    
    float3 color = float3(0);
    
    for (int i = 0; i < iterations; i++) {
        float angle = t / 10 + (i * angularSeparation);
        float2 uv = rotate(uvN2, angle);
        
        float value = (sin(uv.x * M_PI_F + skippedT + (i * angularSeparation)) / skippedT) * 2 + 1.2;
        
        float distance = 1 - sqrt(abs(value - uv.y));
        
        float3 contribution = palette(distance + t / 10) / iterations;
        
        float scale = pow(0.1 / distance, 0.3);
        
        color += contribution * scale;
    }
    
    return half4(half3(color), 1);
    
}



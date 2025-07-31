#ifndef VIBRANCE_INTENSITY
    #define VIBRANCE_INTENSITY 1.0
#endif

#ifndef SHADER_VIBRANCE_SKIN_TONE_PROTECTION
    #define SHADER_VIBRANCE_SKIN_TONE_PROTECTION 0.75
#endif

#ifndef GREEN_HUE_SHIFT
    #define GREEN_HUE_SHIFT 0.4 
#endif


#version 300 es
precision highp float;

in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

const float VIBRANCE = VIBRANCE_INTENSITY; 
const float SKIN_TONE_PROTECTION = SHADER_VIBRANCE_SKIN_TONE_PROTECTION;
const float GREEN_SHIFT_STRENGTH = GREEN_HUE_SHIFT;

vec3 rgb2hsl(vec3 color) {
    float cmax = max(max(color.r, color.g), color.b);
    float cmin = min(min(color.r, color.g), color.b);
    float h = 0.0, s = 0.0, l = (cmax + cmin) / 2.0;
    float delta = cmax - cmin;

    if (delta > 0.00001) {
        s = l > 0.5 ? delta / (2.0 - cmax - cmin) : delta / (cmax + cmin);
        if (cmax == color.r) {
            h = (color.g - color.b) / delta + (color.g < color.b ? 6.0 : 0.0);
        } else if (cmax == color.g) {
            h = (color.b - color.r) / delta + 2.0;
        } else {
            h = (color.r - color.g) / delta + 4.0;
        }
        h /= 6.0;
    }
    return vec3(h, s, l);
}

// Converts an HSL color value to RGB.
// Assumes h, s, and l are contained in the set [0, 1] and
// returns r, g, and b in the set [0, 1].
float hue2rgb_helper(float p, float q, float t) {
    if (t < 0.0) t += 1.0;
    if (t > 1.0) t -= 1.0;
    if (t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if (t < 1.0/2.0) return q;
    if (t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

vec3 hsl2rgb(vec3 hsl) {
    if (hsl.y == 0.0) {
        return vec3(hsl.z); // achromatic
    }
    float q = hsl.z < 0.5 ? hsl.z * (1.0 + hsl.y) : hsl.z + hsl.y - hsl.z * hsl.y;
    float p = 2.0 * hsl.z - q;
    float r = hue2rgb_helper(p, q, hsl.x + 1.0/3.0);
    float g = hue2rgb_helper(p, q, hsl.x);
    float b = hue2rgb_helper(p, q, hsl.x - 1.0/3.0);
    return vec3(r, g, b);
}

// --- Color Correction & Vibrance ---

// Shifts yellowish-greens towards a purer green.
vec3 correctGreenHue(vec3 color) {
    if (GREEN_SHIFT_STRENGTH <= 0.0) return color;

    vec3 hsl = rgb2hsl(color);
    float hue = hsl.x; // Hue is in [0, 1]

    // Target range: Yellow (60deg) to Yellow-Green (100deg)
    // We shift hues in this range towards pure green (120deg)
    const float yellowHue = 60.0 / 360.0;
    const float targetGreenHue = 120.0 / 360.0;
    const float rangeStart = yellowHue;
    const float rangeEnd = 100.0 / 360.0;

    if (hue > rangeStart && hue < rangeEnd) {
        // Create a smooth influence factor. It's 1 at yellowHue and 0 at rangeEnd.
        float influence = smoothstep(rangeEnd, rangeStart, hue);
        
        // Calculate how much to shift the hue. The shift is strongest for the most yellow-ish colors.
        float hueShiftAmount = (targetGreenHue - hue) * influence * GREEN_SHIFT_STRENGTH;
        
        hsl.x = mod(hsl.x + hueShiftAmount, 1.0);
        return hsl2rgb(hsl);
    }
    return color;
}

float getLuminance(vec3 color) { return dot(color, vec3(0.2126, 0.7152, 0.0722)); }
float getSaturation(vec3 color) {
    float cmax = max(max(color.r, color.g), color.b);
    float cmin = min(min(color.r, color.g), color.b);
    return (cmax == 0.0) ? 0.0 : (cmax - cmin) / cmax;
}
float getSkinMask(vec3 color) {
    float sum = color.r + color.g + color.b;
    if (sum < 0.01) return 0.0;
    vec3 chroma = color / sum;
    vec3 skinChromaRef = vec3(0.472, 0.311, 0.217);
    float dist = distance(chroma, skinChromaRef);
    return smoothstep(0.15, 0.05, dist);
}
float getWarmthMask(vec3 color) {
    float warmth = (color.r + color.g) - color.b * 2.0;
    return smoothstep(0.5, 0.9, warmth) * 0.5;
}

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 color = pixColor.rgb;
    
    // Step 1: Correct the hue of greens before doing anything else.
    color = correctGreenHue(color);
    
    // Step 2: Apply vibrance logic to the (potentially corrected) color.
    if (VIBRANCE == 0.0) {
        fragColor = vec4(color, pixColor.a);
        return;
    }
    
    float luma = getLuminance(color);
    vec3 grayColor = vec3(luma);
    float vibranceAmount = (1.0 - getSaturation(color)) * abs(VIBRANCE);
    
    vec3 result;
    if (VIBRANCE > 0.0) {
        float skinProtection = getSkinMask(color) * SKIN_TONE_PROTECTION;
        float warmthProtection = getWarmthMask(color);
        float totalProtection = max(skinProtection, warmthProtection);
        float adjustedVibrance = vibranceAmount * (1.0 - totalProtection);
        result = mix(grayColor, color, 1.0 + adjustedVibrance);
    } else {
        result = mix(color, grayColor, vibranceAmount);
    }
    
    fragColor = vec4(clamp(result, 0.0, 1.0), pixColor.a);
}


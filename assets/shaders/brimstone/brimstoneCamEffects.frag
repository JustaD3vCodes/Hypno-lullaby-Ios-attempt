#pragma header

float threshold = 0.125; // Threshold for dithering (0.0045 found to be optimal)
uniform float intensity;
mat2 dither_2 = mat2(0.,1.,1.,0.);

struct dither_tile {
    float height;
};

vec3 gb_colors(int color) {
    vec3 gb_colors[4];
    gb_colors[0] = vec3(8., 24., 32.) / 255.;
    gb_colors[1] = vec3(52., 104., 86.) / 255.;
    gb_colors[2] = vec3(136., 192., 112.) / 255.;
    gb_colors[3] = vec3(224., 248., 208.) / 255.;
    vec3 daColor = gb_colors[color];
    return daColor;
}

float gb_colors_distance(vec3 color, int dist) {
    return distance(color, gb_colors(dist));
}

vec3 closest_gb(vec3 color) {
    int best_i = 0;
    float best_d = 2.;
    
    vec3 colors[4];
    colors[0] = gb_colors(0);
    colors[1] = gb_colors(1);
    colors[2] = gb_colors(2);
    colors[3] = gb_colors(3);
    for (int i = 0; i < 4; i++) {
        float dis = distance(colors[i], color);
        if (dis < best_d) {
            best_d = dis;
            best_i = i;
        }
    }
    return colors[best_i];
}

vec3 gb_2_closest(vec3 color, int i) {
 	float distances[4];
    
 	distances[0] = gb_colors_distance(color, 0);
 	distances[1] = gb_colors_distance(color, 1);
 	distances[2] = gb_colors_distance(color, 2);
 	distances[3] = gb_colors_distance(color, 3);

    int first_i = 0;
    float first_d = 2.;
    
    int second_i = 0;
    float second_d = 2.;
    
    for (int i = 0; i < 4; i++) {
        float d = distances[i];
        if (distances[i] <= first_d) {
            second_i = first_i;
            second_d = first_d;
            first_i = i;
            first_d = d;
        } else if (distances[i] <= second_d) {
            second_i = i;
            second_d = d;
        }
    }
    vec3 colors[4];
    colors[0] = gb_colors(0);
    colors[1] = gb_colors(1);
    colors[2] = gb_colors(2);
    colors[3] = gb_colors(3);
    vec3 result[2];
    if (first_i < second_i)
    {
        result[0] = colors[first_i];
        result[1] = colors[second_i];
    }
    else
    {
        result[1] = colors[first_i];
        result[0] = colors[second_i];
    }
    return result[i];
}

bool needs_dither(vec3 color) {
 	float distances[4];
   
 	distances[0] = gb_colors_distance(color, 0);
 	distances[1] = gb_colors_distance(color, 1);
 	distances[2] = gb_colors_distance(color, 2);
 	distances[3] = gb_colors_distance(color, 3);
    
    int first_i = 0;
    float first_d = 2.;
    
    int second_i = 0;
    float second_d = 2.;
    
    for (int i = 0; i < 4; i++) {
        float d = distances[i];
        if (d <= first_d) {
            second_i = first_i;
            second_d = first_d;
            first_i = i;
            first_d = d;
        } else if (d <= second_d) {
            second_i = i;
            second_d = d;
        }
    }
    return abs(first_d - second_d) <= threshold;
}

vec3 return_gbColor(vec3 sampleColor) {
    vec3 endColor;
    vec3 closest[2];

    if (needs_dither(sampleColor)) {
   		closest[0] = gb_2_closest(sampleColor, 0);
  		closest[1] = gb_2_closest(sampleColor, 1);
        endColor = (closest[int(dither_2[int(openfl_TextureCoordv.x)][int(openfl_TextureCoordv.y)])]);
    } else
        endColor = closest_gb(texture2D(bitmap, openfl_TextureCoordv).rgb);
    return endColor;
}

vec3 buried_eye_color = vec3(255.0, 0.0, 0.0) / 255.0;
vec3 buried_grave_color = vec3(121.0, 133.0, 142.0) / 255.0;
vec3 buried_wall_color = vec3(107., 130., 149.) / 255.0;

void main() {
    vec4 sampleColor = texture2D(bitmap, openfl_TextureCoordv);
    vec3 colors[4];

    colors[0] = gb_colors(0);
    colors[1] = gb_colors(1);
    colors[2] = gb_colors(2);
    colors[3] = gb_colors(3);
    
    if (sampleColor.a != 0.0) {
        vec3 colorB = return_gbColor(sampleColor.rgb);
        vec4 newColor;
        if (sampleColor.rgb == buried_eye_color)
            colorB = colors[2];
        if (sampleColor.rgb == buried_grave_color)
            colorB = colors[2];
        if (sampleColor.rgb == buried_wall_color)
            colorB = colors[2];
        newColor = vec4(mix(sampleColor.rgb * sampleColor.a, colorB.rgb, intensity), sampleColor.a);
        gl_FragColor = newColor;
    } else
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);

    /*
    vec3 gbColor = vec3(closest_gb(texture2D(bitmap, openfl_TextureCoordv).rgb));
    // Output to screen
    gl_FragColor = vec4(
        mix(texture2D(bitmap, openfl_TextureCoordv).rgb * texture2D(bitmap, openfl_TextureCoordv).a, gbColor.rgb, intensity),
        texture2D(bitmap, openfl_TextureCoordv).a
    );
    */
}
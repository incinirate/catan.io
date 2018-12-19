uniform vec2 resolution;

vec4 position(mat4 transform_projection, vec4 vertex_position) {
    // The order of operations matters when doing matrix multiplication.
    return transform_projection * vertex_position;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(texture, texture_coords);
    vec3 col = texturecolor.rgb * color.rgb;

    vec2 bp = (screen_coords.xy / resolution.xy)*2-1;
    // fancy vignetting
    float vgn1 = pow(smoothstep(0.0,.3,(bp.x + 1.)*(bp.y + 1.)*(bp.x - 1.)*(bp.y - 1.)),.5);
    float vgn2 = 1.-pow(dot(vec2(bp.x*.3, bp.y),bp),3.);
    col *= mix(vgn1,vgn2,.4)*.5+0.5;
    // col *= (screen_coords.x / resolution.x)*2-1.;

    return vec4(col.rgb, texturecolor.a * color.a);
}

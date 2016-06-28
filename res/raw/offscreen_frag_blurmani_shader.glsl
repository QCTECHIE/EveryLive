precision mediump float;

varying vec2 v_TexCoords;

uniform sampler2D sTexture;
uniform float     uRadius;
uniform float     u_rt_size;


vec4 blurI(sampler2D texture, float radius, float resulotion, vec2 texCoords, vec2 direction){
    vec4 color = vec4(0.0);
    float blur = radius / resulotion;

    color += texture2D(texture, vec2(texCoords.x - 4.0*blur*direction.x, texCoords.y - 4.0*blur*direction.y)) * 0.0162162162;
    color += texture2D(texture, vec2(texCoords.x - 3.0*blur*direction.x, texCoords.y - 3.0*blur*direction.y)) * 0.0540540541;
    color += texture2D(texture, vec2(texCoords.x - 2.0*blur*direction.x, texCoords.y - 2.0*blur*direction.y)) * 0.1216216216;
    color += texture2D(texture, vec2(texCoords.x - 1.0*blur*direction.x, texCoords.y - 1.0*blur*direction.y)) * 0.1945945946;

    color += texture2D(texture, vec2(texCoords.x, texCoords.y)) * 0.2270270270;

    color += texture2D(texture, vec2(texCoords.x + 1.0*blur*direction.x, texCoords.y + 1.0*blur*direction.y)) * 0.1945945946;
    color += texture2D(texture, vec2(texCoords.x + 2.0*blur*direction.x, texCoords.y + 2.0*blur*direction.y)) * 0.1216216216;
    color += texture2D(texture, vec2(texCoords.x + 3.0*blur*direction.x, texCoords.y + 3.0*blur*direction.y)) * 0.0540540541;
    color += texture2D(texture, vec2(texCoords.x + 4.0*blur*direction.x, texCoords.y + 4.0*blur*direction.y)) * 0.0162162162;

    return color;

}

void main() {

    vec4 rgbA = blurI(sTexture, uRadius, u_rt_size, v_TexCoords, vec2(1,0));

    gl_FragColor = vec4(rgbA.rgb, 1.0);
}

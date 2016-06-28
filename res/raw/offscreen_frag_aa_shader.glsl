#version 300 es
precision highp float;

uniform sampler2D sTexture;

uniform float vx_offset;
//uniform vec2 u_rt_size;
in  vec2 v_rt_size;
float AA_SPAN_MAX =  8.0;
float AA_REDUCE_MUL = 1.0/256.0;

in vec4 v_TexCoords;
layout(location = 0) out vec4 outColor;

#define AaInt2    ivec2
#define AaFloat2  vec2
#define AaTexLod0(t,p)        textureLod(t,p,0.0)
#define AaTexOff(t,p,o,r)      textureOffset(t, p, o, 0.0)

vec3 AaSampleShader(vec4 texCoords, sampler2D tex, vec2 rcpFrame){
    #define AA_REDUCE_MIN (1.0/128.0)

    vec3 rgbNW = AaTexLod0(tex, texCoords.zw).xyz;
    vec3 rgbNE = AaTexOff(tex, texCoords.zw, AaInt2(1, 0), rcpFrame.xy).xyz;
    vec3 rgbSW = AaTexOff(tex, texCoords.zw, AaInt2(0, 1), rcpFrame.xy).xyz;
    vec3 rgbSE = AaTexOff(tex, texCoords.zw, AaInt2(1, 1), rcpFrame.xy).xyz;
    vec3 rgbM = AaTexLod0(tex, texCoords.xy).xyz;

    vec3 luma = vec3(0.299, 0.587, 0.114);
    float lumaNW =  dot(rgbNW, luma);
    float lumaNE =  dot(rgbNE, luma);
    float lumaSW =  dot(rgbSW, luma);
    float lumaSE =  dot(rgbSE, luma);
    float lumaM  =  dot(rgbM, luma);

    float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));
    float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));

    vec2 dir;
    dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));
    dir.y = ((lumaNW + lumaSW) - (lumaNE + lumaSE));

    float  dirReduce = max((lumaNW + lumaNE +  lumaSW +  lumaSE)*(0.25*AA_REDUCE_MUL), AA_REDUCE_MIN);
    float  rcpDirMin = 1.0/(min(abs(dir.x), abs(dir.y)) + dirReduce);
    dir = min(AaFloat2(AA_SPAN_MAX, AA_SPAN_MAX), max(AaFloat2(-AA_SPAN_MAX, -AA_SPAN_MAX),
            dir*rcpDirMin))*rcpFrame.xy;

    vec3 rgbA = (1.0/2.0)*(AaTexLod0(tex, texCoords.xy + dir*(1.0/3.0 - 0.5)).xyz +
                            AaTexLod0(tex, texCoords.xy +  dir*(2.0/3.0 - 0.5)).xyz);
        vec3 rgbB = rgbA*(1.0/2.0) + (1.0/4.0)*(AaTexLod0(tex, texCoords.xy + dir*(0.0/3.0 - 0.5)).xyz +AaTexLod0(tex, texCoords.xy + dir*(3.0/3.0 - 0.5)).xyz);
        float lumaB = dot(rgbB, luma);
        if((lumaB < lumaMin) || (lumaB>lumaMax)){
            return rgbA;
        }
    return rgbB;
}

vec4 PostFX(sampler2D tex, vec2 uv){
    vec4 c = vec4(0.0);
    vec2 rcpFrame = vec2(1.0/v_rt_size.x, 1.0/v_rt_size.y);
    c.rgb = AaSampleShader(v_TexCoords, tex, rcpFrame);
    c.a = 1.0;
    return c;
}


void main()
{
   vec2 uv = v_TexCoords.st;
   outColor = PostFX(sTexture, uv);
}
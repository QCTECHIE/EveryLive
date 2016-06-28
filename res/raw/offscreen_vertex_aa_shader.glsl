#version 300 es
layout(location = 0) in vec4 a_Position;
layout(location = 1) in vec2 a_TexCoords;

uniform mat4 u_Transform;

float AA_SUBPIX_SHIFT = 1.0/128.0;
uniform vec2 u_rt_size;

out vec4 v_TexCoords;


out  vec2 v_rt_size;

void main()
{
   vec2 rcpFrame = vec2(1.0/u_rt_size.x, 1.0/u_rt_size.y);
   v_rt_size = u_rt_size;
   v_TexCoords.xy = (a_TexCoords).xy;
   v_TexCoords.zw = (a_TexCoords).xy - (rcpFrame*(0.5 + AA_SUBPIX_SHIFT));

   gl_Position = u_Transform*a_Position;
}
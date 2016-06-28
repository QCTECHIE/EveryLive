attribute vec4 a_Position;
attribute vec4 a_TexCoords;

uniform mat4 u_Transform;
uniform mat4 u_STMatrix;

varying vec2 v_TexCoords;

void main()
{
   v_TexCoords = (a_TexCoords).xy;
   gl_Position = u_Transform*a_Position;
}
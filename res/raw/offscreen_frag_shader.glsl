precision mediump float;

uniform sampler2D sTexture;

varying vec2 v_TexCoords;

void main()
{
   gl_FragColor = texture2D(sTexture, v_TexCoords);
}
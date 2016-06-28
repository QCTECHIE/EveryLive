#extension GL_OES_EGL_image_external:require

precision mediump float;

uniform samplerExternalOES sTexture;

varying vec2 v_TexCoords;

void main()
{
   gl_FragColor = vec4(texture2D(sTexture, v_TexCoords).xyz+0.2, 1.0);
}
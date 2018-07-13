/*
** Copyright (c) 2012, Romain Dura romain@shazbits.com
** 
** Permission to use, copy, modify, and/or distribute this software for any 
** purpose with or without fee is hereby granted, provided that the above 
** copyright notice and this permission notice appear in all copies.
** 
** THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES 
** WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF 
** MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY 
** SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES 
** WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN 
** ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR 
** IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
*/

/*
** Photoshop & misc math
** Blending modes, RGB/HSL/Contrast/Desaturate, levels control
**
** Romain Dura | Romz
** Blog: http://mouaif.wordpress.com
** Post: http://mouaif.wordpress.com/?p=94
** Update : Bonjour Lab
*/


#version 150
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;
uniform sampler2D base;
uniform float opacity;

in vec4 vertTexCoord;
out vec4 fragColor;

#define BlendAdd(base, blend) 		min(base + blend, vec3(1.0))

void main(){
	vec2 uv = vertTexCoord.xy;
	vec3 based = texture2D(base, uv).rgb;
	vec3 blend = texture2D(texture, uv).rgb;
	vec3 blended = BlendAdd(based, blend);

	fragColor = mix(vec4(based, 1.0), vec4(blended, 1.0), opacity);
}
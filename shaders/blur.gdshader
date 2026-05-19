shader_type canvas_item;

// Настройка силы размытия, которая появится в Инспекторе
uniform float blur_amount : hint_range(0.0, 5.0) = 2.0;

// Классический способ забрать текстуру экрана в Godot 4.x
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // textureLod плавно размывает картинку, используя мип-мапы экрана
    vec4 color = textureLod(screen_texture, SCREEN_UV, blur_amount);
    COLOR = color;
}

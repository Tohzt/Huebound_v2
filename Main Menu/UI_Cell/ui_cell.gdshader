shader_type canvas_item;

// --- Uniforms --- //
uniform bool weighted = true;    // Determines whether to use normal or weighted averages
uniform float brightness = 0.2;  // Controls overall brightness (-1.0 to 1.0)
uniform float contrast = 1.2;    // Controls contrast (0.0 upwards, 1.0 is neutral)

void fragment() {
    // Calculate greyscale value using either simple or weighted average
    float grey = weighted ? 
        (0.299 * COLOR.r + 0.587 * COLOR.g + 0.114 * COLOR.b) :
        (COLOR.r + COLOR.g + COLOR.b) / 3.0;
    
    // Apply contrast adjustment
    grey = (grey - 0.5) * contrast + 0.5;
    
    // Apply brightness adjustment
    grey = grey + brightness;
    
    // Clamp the final value to valid range
    grey = clamp(grey, 0.0, 1.0);
    
    COLOR.rgb = vec3(grey);
}
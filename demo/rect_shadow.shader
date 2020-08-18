shader_type canvas_item;

// this describes the rect the shadow will cover and should include any desired offset
uniform vec2 rect_position = vec2(0,0);
uniform vec2 rect_end = vec2(100, 100);
uniform uint rect_corner_radius = 0;
uniform highp float shadow_size = 20;

varying vec2 _vertex;   // the new 'FRAGCOORD' of the scaled shadow rect

void vertex()
{
    highp float shadow_margin = 3.0 * shadow_size;
    
    // scale the shadow rect to account for the margin
    _vertex = mix(rect_position.xy - shadow_margin, rect_end.xy + shadow_margin, UV);
    VERTEX = _vertex;
}

// This approximates the error function, needed for the gaussian integral
vec4 rect_erf(vec4 x)
{
    vec4 s = sign(x);
    vec4 a = abs(x);
    x = 1.0 + (0.278393 + (0.230389 + 0.078108 * (a * a)) * a) * a;
    x *= x;
    return s - s / (x * x);    
}

highp float rect_shadow()
{
    vec4 query = vec4(_vertex - rect_position, _vertex - rect_end);
    vec4 integral = 0.5 + 0.5 * rect_erf(query * (sqrt(0.5) / shadow_size));
    return (integral.z - integral.x) * (integral.w - integral.y);
}

// This approximates the error function, needed for the gaussian integral
vec2 rounded_rect_erf(vec2 x)
{
    vec2 s = sign(x);
    vec2 a = abs(x);
    x = 1.0 + (0.278393 + (0.230389 + 0.078108 * (a * a)) * a) * a;
    x *= x;
    return s - s / (x * x);    
}

// A standard gaussian function, used for weighting samples
highp float gaussian(highp float x)
{
    const highp float PI = 3.14159265358979323846;
    return exp(-(x * x) / (2.0 * shadow_size * shadow_size)) / (sqrt(2.0 * PI) * shadow_size);
}

// Return the blurred mask along the x dimension
highp float rounded_rect_shadow_x(highp float x, highp float y, vec2 half_size)
{
    highp float corner = float(rect_corner_radius);
    highp float delta = min(half_size.y - corner - abs(y), 0.0);
    highp float curved = half_size.x - corner + sqrt(max(0.0, corner * corner - delta * delta));
    vec2 integral = 0.5 + 0.5 * rounded_rect_erf((x + vec2(-curved, curved)) * (sqrt(0.5) / shadow_size));
    return integral.y - integral.x;
}

highp float rounded_rect_shadow()
{
    // Center everything to make math easier
    vec2 center = (rect_position + rect_end) * 0.5;
    vec2 half_size = (rect_end - rect_position) * 0.5;
    vec2 point = _vertex - center;
    
    // The signal is only non-zero in a limited range, so don't waste samples
    highp float low = point.y - half_size.y;
    highp float high = point.y + half_size.y;
    highp float start = clamp(-3.0 * shadow_size, low, high);
    highp float end = clamp(3.0 * shadow_size, low, high);

    highp float delta = (end - start) / 4.0;
    highp float y = start + delta * 0.5;
    highp float value = 0.0;
    for (int i = 0; i < 4; i++)
    {
        value += rounded_rect_shadow_x(point.x, point.y - y, half_size) * gaussian(y) * delta;
        y += delta;
    }
    return value;
}

void fragment()
{
    if (rect_corner_radius == uint(0))
    {
        COLOR.a *= rect_shadow(); 
    }
    else
    {
        COLOR.a *= rounded_rect_shadow();    
    }
}
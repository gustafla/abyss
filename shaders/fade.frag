#version 450

layout(location = 0) out vec4 out_color;

layout(std140, set = 3, binding = 0) uniform FragmentFrameData {
    float u_time_g;
};

layout(std430, set = 2, binding = 0) readonly buffer TagTimes {
    float tag_times[NUM_TAGS];
};
layout(std430, set = 2, binding = 1) readonly buffer TagDurations {
    float tag_durations[NUM_TAGS];
};

void main() {
    float t = tag_times[TAG_FADE] / tag_durations[TAG_FADE];
    out_color = vec4(vec3(0.0), t);
}

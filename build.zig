const std = @import("std");
const engine = @import("mehustin2");

pub fn build(b: *std.Build) void {
    const options = engine.initOptions(b);
    const engine_dep = b.dependency("mehustin2", options);

    const engine_mod = engine_dep.module("engine");

    const script_mod = b.createModule(.{
        .root_source_file = b.path("src/script.zig"),
    });

    script_mod.addImport("engine", engine_mod);
    engine_mod.addImport("script", script_mod);
    engine_dep.module("render").addImport("script", script_mod);
    engine_dep.module("exe").addImport("script", script_mod);

    // Compile and install shaders
    engine.compileShaders(b, engine_dep, @import("src/config.zon"));

    // Extract and install the artifacts the engine builds
    const demo_exe = engine_dep.artifact(options.exe_name);
    b.installArtifact(demo_exe);
    const render_lib = engine_dep.artifact("render");
    b.installArtifact(render_lib);

    const run_cmd = b.addRunArtifact(demo_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_cmd.step);
}

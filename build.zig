const std = @import("std");
const engine = @import("mehustin2");

pub fn build(b: *std.Build) void {
    // Initialize options and dependency
    const options = engine.Options.init(b);
    const engine_dep = b.dependency("mehustin2", options);

    const engine_mod = engine_dep.module("engine");
    const script_mod = b.createModule(.{
        .root_source_file = b.path("src/script.zig"),
    });

    // Hook up module dependencies
    script_mod.addImport("engine", engine_mod);
    engine_mod.addImport("script", script_mod);
    engine_dep.module("render").addImport("script", script_mod);
    engine_dep.module("exe").addImport("script", script_mod);

    // Compile and install shaders
    engine.compileShaders(b, engine_dep, @import("src/config.zon"));

    // Install the build artifacts
    engine.install(b, engine_dep, options);
}

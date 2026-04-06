const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const script_mod = b.createModule(.{
        .root_source_file = b.path("src/script.zig"),
    });

    const engine_dep = b.dependency("mehustin2", .{
        .target = target,
        .optimize = optimize,
    });

    script_mod.addImport("lib", engine_dep.module("script"));
    engine_dep.module("render").addImport("script", script_mod);
    engine_dep.module("exe").addImport("script", script_mod);

    // Extract and install the artifacts the engine builds
    const demo_exe = engine_dep.artifact("demo"); // TODO configure this with options
    b.installArtifact(demo_exe);
    const render_lib = engine_dep.artifact("render");
    b.installArtifact(render_lib);

    // Optional: Re-expose the run step
    const run_cmd = b.addRunArtifact(demo_exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the application");
    run_step.dependOn(&run_cmd.step);
}

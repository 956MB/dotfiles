const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const regex_module = b.dependency("regex", .{ .target = target, .optimize = optimize }).module("regex");

    buildExe(b, target, optimize, "aliaz", "aliaz.zig", regex_module);
}

fn buildExe(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    comptime name: []const u8,
    source_path: []const u8,
    regex_module: *std.Build.Module,
) void {
    const exe_mod = b.createModule(.{
        .root_source_file = b.path(source_path),
        .target = target,
        .optimize = optimize,
    });
    exe_mod.addImport("regex", regex_module);
    const exe = b.addExecutable(.{
        .name = name,
        .root_module = exe_mod,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run-" ++ name, "Run the " ++ name ++ " app");
    run_step.dependOn(&run_cmd.step);
}

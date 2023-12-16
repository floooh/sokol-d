// based on sokol-zig

const std = @import("std");
const builtin = @import("builtin");
const Builder = std.build;
const CompileStep = std.build.CompileStep;
const CrossTarget = std.zig.CrossTarget;
const OptimizeMode = std.builtin.OptimizeMode;

pub const Backend = enum {
    auto, // Windows: D3D11, macOS/iOS: Metal, otherwise: GL
    d3d11,
    metal,
    gl,
    gles2,
    gles3,
    wgpu,
};

pub const Config = struct {
    backend: Backend = .auto,
    force_egl: bool = false,
    enable_x11: bool = true,
    enable_wayland: bool = false,
};

fn rootPath() []const u8 {
    return std.fs.path.dirname(@src().file) orelse ".";
}

// build sokol into a static library
pub fn buildSokol(b: *Builder, target: CrossTarget, optimize: OptimizeMode, config: Config, comptime prefix_path: []const u8) *CompileStep {
    const lib = b.addStaticLibrary(.{
        .name = "sokol",
        .target = target,
        .optimize = optimize,
    });
    switch (optimize) {
        // zig have custom compiler-rt and another toolchains not include it (fix: unknown ref zig_stack_protector)
        .Debug, .ReleaseSafe => lib.bundle_compiler_rt = true,
        else => lib.disable_sanitize_c = true,
    }
    lib.pie = true;
    lib.linkLibC();
    const sokol_path = prefix_path ++ "src/sokol/c/";
    const csources = [_][]const u8{
        "sokol_log.c",
        "sokol_app.c",
        "sokol_gfx.c",
        "sokol_glue.c",
        "sokol_time.c",
        "sokol_audio.c",
        "sokol_gl.c",
        "sokol_debugtext.c",
        "sokol_shape.c",
    };
    var _backend = config.backend;
    if (_backend == .auto) {
        if (lib.target.isDarwin()) {
            _backend = .metal;
        } else if (lib.target.isWindows()) {
            _backend = .d3d11;
        } else if (lib.target.getAbi() == .android) {
            _backend = .gles3;
        } else {
            _backend = .gl;
        }
    }
    const backend_option = switch (_backend) {
        .d3d11 => "-DSOKOL_D3D11",
        .metal => "-DSOKOL_METAL",
        .gl => "-DSOKOL_GLCORE33",
        .gles2 => "-DSOKOL_GLES2",
        .gles3 => "-DSOKOL_GLES3",
        .wgpu => "-DSOKOL_WGPU",
        else => unreachable,
    };

    if (lib.target.isDarwin()) {
        inline for (csources) |csrc| {
            lib.addCSourceFile(.{
                .file = .{ .path = sokol_path ++ csrc },
                .flags = &[_][]const u8{ "-ObjC", "-DIMPL", backend_option },
            });
        }
        lib.linkFramework("Foundation");
        lib.linkFramework("AudioToolbox");
        if (.metal == _backend) {
            lib.linkFramework("MetalKit");
            lib.linkFramework("Metal");
        }
        if (lib.target.getOsTag() == .ios) {
            lib.linkFramework("UIKit");
            lib.linkFramework("AVFoundation");
            if (.gl == _backend) {
                lib.linkFramework("OpenGLES");
                lib.linkFramework("GLKit");
            }
        } else if (lib.target.getOsTag() == .macos) {
            lib.linkFramework("Cocoa");
            lib.linkFramework("QuartzCore");
            if (.gl == _backend) {
                lib.linkFramework("OpenGL");
            }
        }
    } else {
        const egl_flag = if (config.force_egl) "-DSOKOL_FORCE_EGL " else "";
        const x11_flag = if (!config.enable_x11) "-DSOKOL_DISABLE_X11 " else "";
        const wayland_flag = if (!config.enable_wayland) "-DSOKOL_DISABLE_WAYLAND" else "";

        inline for (csources) |csrc| {
            lib.addCSourceFile(.{
                .file = .{ .path = sokol_path ++ csrc },
                .flags = &[_][]const u8{ "-DIMPL", backend_option, egl_flag, x11_flag, wayland_flag },
            });
        }

        if (lib.target.getAbi() == .android) {
            if (.gles3 != _backend) {
                @panic("For android targets, you must have backend set to GLES3");
            }
            lib.linkSystemLibrary("GLESv3");
            lib.linkSystemLibrary("EGL");
            lib.linkSystemLibrary("android");
            lib.linkSystemLibrary("log");
        } else if (lib.target.isLinux()) {
            const link_egl = config.force_egl or config.enable_wayland;
            const egl_ensured = (config.force_egl and config.enable_x11) or config.enable_wayland;

            lib.linkSystemLibrary("asound");

            if (.gles2 == _backend) {
                lib.linkSystemLibrary("glesv2");
                if (!egl_ensured) {
                    @panic("GLES2 in Linux only available with Config.force_egl and/or Wayland");
                }
            } else {
                lib.linkSystemLibrary("GL");
            }
            if (config.enable_x11) {
                lib.linkSystemLibrary("X11");
                lib.linkSystemLibrary("Xi");
                lib.linkSystemLibrary("Xcursor");
            }
            if (config.enable_wayland) {
                lib.linkSystemLibrary("wayland-client");
                lib.linkSystemLibrary("wayland-cursor");
                lib.linkSystemLibrary("wayland-egl");
                lib.linkSystemLibrary("xkbcommon");
            }
            if (link_egl) {
                lib.linkSystemLibrary("egl");
            }
        } else if (lib.target.isWindows()) {
            lib.linkSystemLibraryName("kernel32");
            lib.linkSystemLibraryName("user32");
            lib.linkSystemLibraryName("gdi32");
            lib.linkSystemLibraryName("ole32");
            if (.d3d11 == _backend) {
                lib.linkSystemLibraryName("d3d11");
                lib.linkSystemLibraryName("dxgi");
            }
        }
    }
    return lib;
}

pub fn build(b: *Builder) !void {
    var config: Config = .{};

    const force_gl = b.option(bool, "gl", "Force GL backend") orelse false;
    config.backend = if (force_gl) .gl else .auto;

    // NOTE: Wayland support is *not* currently supported in the standard sokol-zig bindings,
    // you need to generate your own bindings using this PR: https://github.com/floooh/sokol/pull/425
    config.enable_wayland = b.option(bool, "wayland", "Compile with wayland-support (default: false)") orelse false;
    config.enable_x11 = b.option(bool, "x11", "Compile with x11-support (default: true)") orelse true;
    config.force_egl = b.option(bool, "egl", "Use EGL instead of GLX if possible (default: false)") orelse false;

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const sokol = buildSokol(b, target, optimize, config, "");
    b.installArtifact(sokol);

    const examples = .{
        // "clear",
        // "triangle",
        // "quad",
        // "bufferoffsets",
        // "cube",
        // "noninterleaved",
        // "texcube",
        // "blend",
        // "offscreen",
        // "instancing",
        // "mrt",
        // "saudio",
        // "sgl",
        // "sgl-context",
        // "sgl-points",
        // "debugtext",
        "debugtext_print",
        // "debugtext-userfont",
        // "shapes",
    };
    inline for (examples) |example| {
        const ldc = try buildLDC(b, sokol, config, example);
        ldc.step.dependOn(b.getInstallStep());
        const run = b.step(b.fmt("{s}", .{example}), b.fmt("Build example {s}", .{example}));
        run.dependOn(&ldc.step);
    }
    buildShaders(b);
}

// a separate step to compile shaders, expects the shader compiler in ../sokol-tools-bin/
fn buildShaders(b: *Builder) void {
    const sokol_tools_bin_dir = "../sokol-tools-bin/bin/";
    const shaders_dir = "src/examples/shaders/";
    const shaders = .{
        "bufferoffsets.glsl",
        "cube.glsl",
        "instancing.glsl",
        "mrt.glsl",
        "noninterleaved.glsl",
        "offscreen.glsl",
        "quad.glsl",
        "shapes.glsl",
        "texcube.glsl",
        "blend.glsl",
    };
    const optional_shdc: ?[:0]const u8 = comptime switch (builtin.os.tag) {
        .windows => "win32/sokol-shdc.exe",
        .linux => "linux/sokol-shdc",
        .macos => if (builtin.cpu.arch.isX86()) "osx/sokol-shdc" else "osx_arm64/sokol-shdc",
        else => null,
    };
    if (optional_shdc == null) {
        std.log.warn("unsupported host platform, skipping shader compiler step", .{});
        return;
    }
    const shdc_path = sokol_tools_bin_dir ++ optional_shdc.?;
    const shdc_step = b.step("shaders", "Compile shaders (needs ../sokol-tools-bin)");
    inline for (shaders) |shader| {
        const cmd = b.addSystemCommand(&.{
            shdc_path,
            "-i",
            shaders_dir ++ shader,
            "-o",
            shaders_dir ++ shader ++ ".zig",
            "-l",
            "glsl330:metal_macos:hlsl4",
            "-f",
            "sokol_zig",
        });
        shdc_step.dependOn(&cmd.step);
    }
}

// Use LDC2 (https://github.com/ldc-developers/ldc) to compile the D examples
fn buildLDC(b: *Builder, lib: *Builder.CompileStep, config: Config, comptime example: []const u8) !*Builder.RunStep {
    const ldc = try b.findProgram(&.{"ldc2"}, &.{});

    var cmds = std.ArrayList([]const u8).init(b.allocator);
    try cmds.append(ldc);
    switch (lib.optimize) {
        .Debug => {
            try cmds.append("-d-debug");
            try cmds.append("--gc");
            try cmds.append("--O0");
        },
        .ReleaseSafe => {
            try cmds.append("--O2");
            try cmds.append("--release");
            try cmds.append("--boundscheck=on");
        },
        .ReleaseFast => {
            try cmds.append("--O3");
            try cmds.append("--release");
            try cmds.append("--betterC");
            try cmds.append("--boundscheck=off");
        },
        .ReleaseSmall => {
            try cmds.append("--Oz");
            try cmds.append("--release");
            try cmds.append("--boundscheck=off");
        },
    }
    try cmds.append(b.fmt("-I{s}", .{b.pathJoin(&.{ rootPath(), "src/sokol" })}));
    const srcs = &.{
        "app",
        "audio",
        "gl",
        "gfx",
        "glue",
        "log",
        "shape",
        "time",
        "debugtext",
    };
    inline for (srcs) |src| {
        try cmds.append(b.fmt("{s}.d", .{b.pathJoin(&.{ rootPath(), "src/sokol", src })}));
    }

    try cmds.append(b.pathJoin(&.{ rootPath(), "/src/examples", b.fmt("{s}.d", .{example}) }));

    for (lib.lib_paths.items) |libpath| {
        if (libpath.path.len > 0)
            try cmds.append(b.fmt("-L-L{s}", .{libpath.path}));
    }

    try cmds.append(b.fmt("-L-L{s}", .{b.pathJoin(&.{ b.install_prefix, "lib" })}));
    try cmds.append("-L-lsokol");

    for (lib.link_objects.items) |link_object| {
        if (link_object != .system_lib) continue;
        const system_lib = link_object.system_lib;
        try cmds.append(b.fmt("-L-l{s}", .{system_lib.name}));
    }

    if (lib.target.isDarwin()) {
        var it = lib.frameworks.iterator();
        while (it.next()) |framework| {
            try cmds.append(b.fmt("-L-framework {s}", .{framework.key_ptr.*}));
        }
    }

    var _backend = config.backend;
    if (_backend == .auto) {
        if (lib.target.isDarwin()) {
            _backend = .metal;
        } else if (lib.target.isWindows()) {
            _backend = .d3d11;
        } else if (lib.target.getAbi() == .android) {
            _backend = .gles3;
        } else {
            _backend = .gl;
        }
    }
    const backend_option = switch (_backend) {
        .d3d11 => "-DSOKOL_D3D11",
        .metal => "-DSOKOL_METAL",
        .gl => "-DSOKOL_GLCORE33",
        .gles2 => "-DSOKOL_GLES2",
        .gles3 => "-DSOKOL_GLES3",
        .wgpu => "-DSOKOL_WGPU",
        else => unreachable,
    };

    try cmds.append(b.fmt("--Xcc={s}", .{backend_option}));

    for (lib.link_objects.items) |link_object| {
        if (link_object != .c_source_file) continue;
        const c_source_file = link_object.c_source_file;
        for (c_source_file.flags) |flag|
            if (flag.len > 0) // skip empty flags
                try cmds.append(b.fmt("--Xcc={s}", .{flag}));
    }

    if (lib.want_lto) |_|
        try cmds.append("--flto=full");
    if (lib.target.isNative())
        try cmds.append(b.fmt("--mtriple={s}-{s}-{s}", .{ @tagName(lib.target.getCpuArch()), @tagName(lib.target.getOsTag()), @tagName(lib.target.getAbi()) }))
    else
        try cmds.append(b.fmt("--mtriple={s}", .{try lib.target.linuxTriple(b.allocator)}));

    try cmds.append(b.fmt("--mcpu={s}", .{lib.target.getCpuModel().name}));
    try cmds.append(b.fmt("--of={s}", .{b.pathJoin(&.{ b.install_prefix, "bin", example })}));

    return b.addSystemCommand(cmds.items);
}

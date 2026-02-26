/*
zlib/libpng license

Copyright (c) 2023-2025 Matheus Catarino França <matheus-catarino@hotmail.com>

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the
use of this software.
*/
module build;

import std;

// Dependency versions
enum emsdk_version = "5.0.1";
enum imgui_version = "1.92.6";
enum nuklear_version = "4.12.8";

void main(string[] args) @safe
{
    static if (__VERSION__ < 2111)
    {
        static assert(false, "This project requires DMD-frontend 2.111.0 or newer");
    }

    // Command-line options
    struct Options
    {
        bool help, verbose, downloadEmsdk, downloadShdc;
        string compiler, target = defaultTarget(), optimize = "debug", linkExample, runExample, linkage = "static";
        SokolBackend backend;
        bool useX11 = true, useWayland, useEgl, useLTO, withSokolImgui, withSokolNuklear;
    }

    Options opts;
    immutable sokolRoot = environment.get("SOKOL_ROOTPATH", getcwd);
    immutable vendorPath = absolutePath(buildPath(sokolRoot, "vendor"));
    immutable sokolSrcPath = absolutePath(buildPath(sokolRoot, "src", "sokol", "c"));

    // Parse arguments
    foreach (arg; args[1 .. $])
        with (opts) switch (arg)
    {
    case "--help":
        help = true;
        break;
    case "--verbose":
        verbose = true;
        break;
    case "--enable-wasm-lto":
        useLTO = true;
        break;
    case "--download-emsdk":
        downloadEmsdk = true;
        break;
    case "--download-sokol-tools":
        downloadShdc = true;
        break;
    case "--with-sokol-imgui":
        withSokolImgui = true;
        break;
    case "--with-sokol-nuklear":
        withSokolNuklear = true;
        break;
    case "--enable-wayland":
        useWayland = true;
        break;
    case "--disable-x11":
        useX11 = false;
        break;
    case "--enable-egl":
        useEgl = true;
        break;
    default:
        if (arg.startsWith("--backend="))
            backend = arg[10 .. $].to!SokolBackend;
        else if (arg.startsWith("--toolchain="))
            compiler = findProgram(arg[12 .. $]);
        else if (arg.startsWith("--optimize="))
            optimize = arg[11 .. $];
        else if (arg.startsWith("--target="))
            target = arg[9 .. $];
        else if (arg.startsWith("--link="))
            linkExample = arg[7 .. $];
        else if (arg.startsWith("--run="))
            runExample = arg[6 .. $];
        else if (arg.startsWith("--linkage="))
        {
            linkage = arg[10 .. $];
            if (!["static", "dynamic"].canFind(linkage))
                throw new Exception("Invalid linkage: use static or dynamic");
        }
        else
            throw new Exception("Unknown argument: " ~ arg);
        break;
    }

    if (args.length < 2 || opts.help)
    {
        writeln("Usage: build [options]\nOptions:");
        writeln("  --help                   Show this help message");
        writeln("  --verbose                Enable verbose output");
        writeln(
            "  --backend=<backend>      Select backend (d3d11, metal, glcore, gles3, wgpu, vulkan)");
        writeln("  --toolchain=<compiler>   Select C toolchain (e.g., gcc, clang, emcc)");
        writeln("  --optimize=<level>       Select optimization level (debug, release, small)");
        writeln("  --target=<target>        Select target (native, wasm, android)");
        writeln("  --linkage=<type>         Library linkage (static or dynamic, default: static)");
        writeln("  --enable-wayland         Enable Wayland support (Linux only)");
        writeln("  --disable-x11            Disable X11 support (Linux only)");
        writeln("  --enable-egl             Force EGL (Linux only)");
        writeln("  --enable-wasm-lto        Enable Emscripten LTO");
        writeln("  --download-emsdk         Download Emscripten SDK");
        writeln("  --download-sokol-tools   Download sokol-tools");
        writeln("  --link=<example>         Link WASM example (e.g., triangle)");
        writeln("  --run=<example>          Run WASM example (e.g., triangle)");
        writeln("  --with-sokol-imgui       Enable sokol_imgui integration");
        writeln("  --with-sokol-nuklear     Enable sokol_nuklear integration");
        return;
    }

    if (opts.backend == SokolBackend._auto)
        opts.backend = resolveSokolBackend(opts.backend, opts.target);

    opts.target = resolveTarget(opts.target);

    if (!opts.linkExample && !opts.runExample)
    {
        if (opts.target.canFind("wasm"))
            opts.downloadEmsdk = true;
        writeln("Configuration:");
        writeln("  Target: ", opts.target, ", Optimize: ", opts.optimize, ", Backend: ", opts
                .backend);
        writeln("  Linkage: ", opts.linkage);
        writeln("  Download: Emscripten=", opts.downloadEmsdk, ", ImGui=", opts.withSokolImgui,
            ", Nuklear=", opts.withSokolNuklear, ", Sokol-tools=", opts.downloadShdc);
        writeln("  Verbose: ", opts.verbose);
    }

    // Setup dependencies
    if (opts.downloadEmsdk || opts.target.canFind("wasm"))
        getEmSDK(vendorPath);
    if (opts.withSokolImgui)
        getIMGUI(vendorPath);
    if (opts.withSokolNuklear)
        getNuklear(vendorPath);

    // Execute build steps
    if (opts.downloadShdc)
    {
        buildShaders(vendorPath, opts.backend);
    }
    else if (opts.linkExample)
    {
        EmLinkOptions linkOpts = {
            target: "wasm",
            optimize: opts.optimize,
            lib_main: buildPath("build", "lib" ~ opts.linkExample ~ ".a"),
            vendor: vendorPath,
            backend: opts.backend,
            use_emmalloc: true,
            release_use_lto: opts.useLTO,
            use_imgui: opts.withSokolImgui,
            use_nuklear: opts.withSokolNuklear,
            use_filesystem: false,
            shell_file_path: absolutePath(buildPath(sokolRoot, "src", "sokol", "web", "shell.html")),
            extra_args: [
                "-L" ~ absolutePath(buildPath(sokolRoot, "build")), "-lsokol"
            ],
            verbose: opts.verbose
        };
        emLinkStep(linkOpts);
    }
    else if (opts.runExample)
    {
        emRunStep(EmRunOptions(opts.runExample, vendorPath, opts.verbose));
    }
    else
    {
        LibSokolOptions libOpts = {
            target: opts.target,
            optimize: opts.optimize,
            toolchain: opts.compiler,
            vendor: vendorPath,
            sokolSrcPath: sokolSrcPath,
            backend: opts.backend,
            use_x11: opts.useX11,
            use_wayland: opts.useWayland,
            use_egl: opts.useEgl,
            with_sokol_imgui: opts.withSokolImgui,
            with_sokol_nuklear: opts.withSokolNuklear,
            linkageStatic: opts.target.canFind("wasm") ? true : opts.linkage == "static",
            verbose: opts.verbose
        };

        buildLibSokol(libOpts);
    }
}

// Dependency management
void getEmSDK(string vendor) @safe
{
    downloadAndExtract("Emscripten SDK", vendor, "emsdk",
        format("https://github.com/emscripten-core/emsdk/archive/refs/tags/%s.zip", emsdk_version),
        (path) => emSdkSetupStep(path));
}

void getIMGUI(string vendor) @safe
{
    string url;
    enum commitHashRegex = ctRegex!`^[0-9a-fA-F]{7,40}$`;
    if (matchFirst(imgui_version, commitHashRegex))
        url = format("https://github.com/floooh/dcimgui/archive/%s.zip", imgui_version);
    else
        url = format("https://github.com/floooh/dcimgui/archive/refs/tags/v%s.zip", imgui_version);
    downloadAndExtract("ImGui", vendor, "imgui", url);
}

void getNuklear(string vendor) @safe
{
    writeln("Setting up Nuklear");
    string path = absolutePath(buildPath(vendor, "nuklear"));
    string file = "nuklear.h";

    if (!exists(path))
    {
        mkdirRecurse(path);
        download(
            format("https://raw.githubusercontent.com/Immediate-Mode-UI/Nuklear/refs/tags/%s/nuklear.h",
                nuklear_version), file);
        std.file.write(buildPath(path, "nuklear.h"), read(file));
    }
}

void buildShaders(string vendor, ref SokolBackend opts) @safe
{
    immutable shdcPath = getSHDC(vendor);
    immutable shadersDir = "examples/shaders";
    immutable shaders = [
        "triangle", "bufferoffsets", "cube", "instancing", "instancingcompute",
        "mrt", "noninterleaved", "offscreen", "quad", "shapes", "texcube", "blend",
        "vertexpull"
    ];

    version (OSX)
        enum glsl = "glsl410";
    else
        enum glsl = "glsl430";

    immutable slangTemplate = opts == SokolBackend.vulkan
        ? glsl ~ ":metal_macos:hlsl5:%s:wgsl:spirv_vk" : glsl ~ ":metal_macos:hlsl5:%s:wgsl";

    version (Posix)
        executeOrFail(["chmod", "+x", shdcPath], "Failed to set shader permissions", true);

    foreach (shader; shaders)
    {
        immutable essl = (shader == "instancingcompute" || shader == "vertexpull")
            ? "glsl310es" : "glsl300es";
        immutable slang = slangTemplate.format(essl);
        executeOrFail([
            shdcPath, "-i", buildPath(shadersDir, shader ~ ".glsl"),
            "-o", buildPath(shadersDir, shader ~ ".d"), "-l", slang, "-f",
            "sokol_d"
        ], "Shader compilation failed for " ~ shader, true);
    }
}

// Download and extract utility
void downloadAndExtract(string name, string vendor, string dir, string url,
    void delegate(string) @safe postExtract = null) @safe
{
    writeln("Setting up ", name);
    string path = absolutePath(buildPath(vendor, dir));
    string file = dir ~ ".zip";
    scope (exit)
        if (exists(file))
            remove(file);

    if (!exists(path))
    {
        download(url, file);
        extractZip(file, path);
    }
    if (postExtract)
        postExtract(path);
}

// Core build structures
enum SokolBackend
{
    _auto,
    d3d11,
    metal,
    glcore,
    gles3,
    wgpu,
    vulkan
}

struct LibSokolOptions
{
    string target, optimize, toolchain, vendor, sokolSrcPath;
    SokolBackend backend;
    bool use_egl, use_x11 = true, use_wayland, with_sokol_imgui, with_sokol_nuklear,
    linkageStatic, verbose;
}

struct EmLinkOptions
{
    string target, optimize, lib_main, vendor, shell_file_path;
    SokolBackend backend;
    bool release_use_closure = true, release_use_lto, use_emmalloc, use_filesystem,
    use_imgui, use_nuklear, verbose;
    string[] extra_args;
}

struct EmRunOptions
{
    string name, vendor;
    bool verbose;
}

struct EmbuilderOptions
{
    string port_name, vendor;
}

// ---------------------------------------------------------------------------
// Platform helpers
// ---------------------------------------------------------------------------

/// Resolve "native" to the actual compile-time platform string so that all
/// subsequent target checks work correctly when DUB passes --target=native.
string resolveTarget(string target) @safe pure nothrow
{
    if (target != "native")
        return target;
    version (Windows)
        return "windows";
    else version (OSX)
        return "darwin";
    else version (linux)
        return "linux";
    else version (Android)
        return "android";
    else version (Emscripten)
        return "wasm";
    else
        return "linux"; // safe fallback
}

/// Returns true when compiling for (or running on) Windows.
bool targetIsWindows(string target) @safe pure nothrow
{
    return resolveTarget(target).canFind("windows");
}

bool targetIsDarwin(string target) @safe pure nothrow
{
    return resolveTarget(target).canFind("darwin");
}

bool targetIsWasm(string target) @safe pure nothrow
{
    return resolveTarget(target).canFind("wasm");
}

/// Object-file extension: ".obj" on Windows, ".o" elsewhere.
string objExt(string target) @safe pure nothrow
{
    return targetIsWindows(target) ? ".obj" : ".o";
}

/// Emit a single compiler flag that defines a C preprocessor macro,
/// formatted correctly for the target toolchain.
string defineFlag(string macro_, string target) @safe pure nothrow
{
    return (targetIsWindows(target) ? "/D" : "-D") ~ macro_;
}

/// Emit an include-path flag for the target toolchain.
string includeFlag(string path, string target) @safe pure nothrow
{
    return targetIsWindows(target) ? "/I" ~ path : "-I" ~ path;
}

// ---------------------------------------------------------------------------
// Build Sokol (and optionally ImGui / Nuklear) native libraries
// ---------------------------------------------------------------------------

void buildLibSokol(LibSokolOptions opts) @safe
{
    immutable buildDir = absolutePath("build");
    mkdirRecurse(buildDir);

    immutable isWin = targetIsWindows(opts.target);
    immutable isMac = targetIsDarwin(opts.target);
    immutable isWasm = targetIsWasm(opts.target);

    string compiler = opts.toolchain ? opts.toolchain : defaultCompiler(opts.target);

    // ------------------------------------------------------------------
    // Assemble compiler flags — kept strictly per-toolchain from the start
    // ------------------------------------------------------------------
    string[] cflags;
    string[] lflags;

    immutable backendMacro = format("SOKOL_%s",
        resolveSokolBackend(opts.backend, opts.target).to!string.toUpper);

    if (isWin)
    {
        // MSVC (cl.exe) style
        cflags = [
            "/DNDEBUG", "/DIMPL", "/D" ~ backendMacro,
            "/nologo", "/wd4190",
            opts.optimize == "debug" ? "/Od": "/O2"
        ];
        // For Vulkan backend, add the Vulkan SDK include path
        if (opts.backend == SokolBackend.vulkan || resolveSokolBackend(opts.backend, opts.target) == SokolBackend
            .vulkan)
        {
            immutable vulkanSdk = environment.get("VULKAN_SDK", "");
            if (vulkanSdk.length)
                cflags ~= "/I" ~ buildPath(vulkanSdk, "Include");
            else
                throw new Exception("VULKAN_SDK environment variable is not set. " ~
                        "Install the Vulkan SDK from https://vulkan.lunarg.com/");
        }
        // Windows libs are handled by DUB; lflags unused here but kept for
        // completeness if linkLibrary ever needs them.
    }
    else
    {
        // GCC / Clang / emcc style
        cflags = [
            "-DNDEBUG", "-DIMPL", "-D" ~ backendMacro,
            "-Wall", "-Wextra", "-Wno-unused-function",
        ];

        if (isMac)
            cflags ~= "-Wno-return-type-c-linkage";

        if (!isWasm)
        {
            cflags ~= opts.optimize == "debug" ? "-O0" : "-O2";
            // Position-independent code: PIE for static, PIC for shared
            cflags ~= opts.linkageStatic ? "-fPIE" : "-fPIC";
        }

        if (!isMac && !isWasm)
        {
            // Linux-specific defines
            if (opts.use_egl)
                cflags ~= "-DSOKOL_FORCE_EGL";
            if (!opts.use_x11)
                cflags ~= "-DSOKOL_DISABLE_X11";
            if (!opts.use_wayland)
                cflags ~= "-DSOKOL_DISABLE_WAYLAND";

            // Linux link flags (informational; actual linking done by DUB)
            if (opts.use_wayland)
                lflags ~= [
                "-lwayland-client", "-lwayland-egl",
                "-lwayland-cursor", "-lxkbcommon"
            ];
            lflags ~= opts.backend == SokolBackend.vulkan ? ["-lvulkan"] : [
                "-lGL"
            ];
            lflags ~= ["-lX11", "-lXi", "-lXcursor", "-lasound", "-lm", "-ldl"];
        }

        if (isMac)
            lflags ~= [
            "-framework", "Cocoa",
            "-framework", "QuartzCore",
            "-framework", "Foundation",
            "-framework", "Metal",
            "-framework", "AudioToolbox",
        ];

        if (isWasm)
        {
            if (opts.backend == SokolBackend.wgpu)
            {
                EmbuilderOptions embopts = {
                    port_name: "emdawnwebgpu",
                    vendor: opts.vendor,
                };
                embuilderStep(embopts);
                cflags ~= format("-I%s",
                    buildPath(opts.vendor, "emsdk", "upstream", "emscripten",
                        "cache", "ports", "emdawnwebgpu",
                        "emdawnwebgpu_pkg", "webgpu", "include"));
            }
            compiler = buildPath(opts.vendor, "emsdk", "upstream",
                "emscripten", "emcc") ~ (isWindows() ? ".bat" : "");
        }
    }

    // ------------------------------------------------------------------
    // Optional third-party include paths
    // ------------------------------------------------------------------
    if (opts.with_sokol_nuklear)
        cflags ~= includeFlag(absolutePath(buildPath(opts.vendor, "nuklear")), opts.target);

    // ------------------------------------------------------------------
    // Compile & archive libsokol
    // ------------------------------------------------------------------
    immutable sokolSources = [
        "sokol_log.c", "sokol_app.c", "sokol_gfx.c", "sokol_time.c",
        "sokol_audio.c", "sokol_gl.c", "sokol_debugtext.c", "sokol_shape.c",
        "sokol_glue.c", "sokol_fetch.c", "sokol_memtrack.c", "sokol_args.c",
    ];

    // On macOS the sokol .c headers use ObjC syntax — compile them as ObjC.
    // This flag must NOT be in the shared cflags because it would force
    // C++ source files (imgui) to be compiled as ObjC instead of C++.
    string[] sokolCFlags = isMac ? cflags ~ ["-x", "objective-c"] : cflags;

    auto sokolObjs = compileSources(
        sokolSources, buildDir, opts.sokolSrcPath,
        compiler, sokolCFlags, "sokol_", opts.target, opts.verbose);

    immutable sokolLib = buildPath(buildDir, sokolLibName(opts.target, opts.linkageStatic));
    linkLibrary(sokolLib, sokolObjs, opts.target, opts.linkageStatic,
        opts.vendor, lflags, opts.verbose);
    sokolObjs.each!(obj => exists(obj) && remove(obj));

    // ------------------------------------------------------------------
    // Optionally compile & archive libcimgui
    // ------------------------------------------------------------------
    if (opts.with_sokol_imgui)
    {
        immutable imguiRoot = absolutePath(buildPath(opts.vendor, "imgui", "src"));
        enforce(exists(imguiRoot), "ImGui source not found. Run with --with-sokol-imgui after setup.");

        // ImGui needs its own C++ compiler; also include its headers
        string imguiCompiler = cppCompiler(compiler, opts.target, opts.vendor);
        string[] imguiFlags = cflags ~ includeFlag(imguiRoot, opts.target);
        if (!isWin)
            imguiFlags ~= "-DNDEBUG"; // already in cflags but harmless duplicate

        immutable imguiSources = [
            "cimgui.cpp", "imgui.cpp", "imgui_demo.cpp", "imgui_draw.cpp",
            "imgui_tables.cpp", "imgui_widgets.cpp", "cimgui_internal.cpp"
        ];
        auto imguiObjs = compileSources(
            imguiSources, buildDir, imguiRoot,
            imguiCompiler, imguiFlags, "imgui_", opts.target, opts.verbose);

        // sokol_imgui.c and sokol_gfx_imgui.c are C, compiled with the C compiler
        // On macOS they also need -x objective-c (same reason as the core sokol sources)
        foreach (sokolImguiSrc; ["sokol_imgui.c", "sokol_gfx_imgui.c"])
        {
            immutable srcPath = buildPath(opts.sokolSrcPath, sokolImguiSrc);
            enforce(exists(srcPath), sokolImguiSrc ~ " not found");
            immutable objPath = buildPath(buildDir,
                sokolImguiSrc.stripExtension ~ objExt(opts.target));
            compileSource(srcPath, objPath, compiler,
                sokolCFlags ~ includeFlag(imguiRoot, opts.target),
                opts.target, opts.verbose);
            imguiObjs ~= objPath;
        }

        immutable imguiLib = buildPath(buildDir, imguiLibName(opts.target, opts.linkageStatic));
        linkLibrary(imguiLib, imguiObjs, opts.target, opts.linkageStatic,
            opts.vendor, lflags, opts.verbose);
        imguiObjs.each!(obj => exists(obj) && remove(obj));
    }

    // ------------------------------------------------------------------
    // Optionally compile & archive libnuklear
    // ------------------------------------------------------------------
    if (opts.with_sokol_nuklear)
    {
        immutable nuklearRoot = absolutePath(buildPath(opts.vendor, "nuklear"));
        enforce(exists(nuklearRoot), "Nuklear source not found. Run after setup.");

        immutable sokolNuklearPath = buildPath(opts.sokolSrcPath, "sokol_nuklear.c");
        enforce(exists(sokolNuklearPath), "sokol_nuklear.c not found");

        // sokol_nuklear.c compiled with SOKOL_NUKLEAR_IMPL (triggered by -DIMPL)
        // already includes nuklear.h with NK_IMPLEMENTATION internally.
        // Compiling nuklearc.c separately would redefine every nk_* symbol → link error.
        // Solution: only compile sokol_nuklear.c, passing the nuklear include path.
        // On macOS also needs -x objective-c (same as core sokol C sources).
        string[] nuklearFlags = sokolCFlags ~ includeFlag(nuklearRoot, opts.target);

        immutable objPath = buildPath(buildDir, "sokol_nuklear" ~ objExt(opts.target));
        compileSource(sokolNuklearPath, objPath, compiler, nuklearFlags, opts.target, opts.verbose);

        immutable nuklearLib = buildPath(buildDir, nuklearLibName(opts.target, opts.linkageStatic));
        linkLibrary(nuklearLib, [objPath], opts.target, opts.linkageStatic,
            opts.vendor, lflags, opts.verbose);
        if (exists(objPath))
            remove(objPath);
    }
}

// ---------------------------------------------------------------------------
// Library name helpers
// ---------------------------------------------------------------------------

string sokolLibName(string target, bool static_) @safe pure nothrow
{
    return sharedOrStaticName("sokol", target, static_);
}

string imguiLibName(string target, bool static_) @safe pure nothrow
{
    return sharedOrStaticName("cimgui", target, static_);
}

string nuklearLibName(string target, bool static_) @safe pure nothrow
{
    return sharedOrStaticName("nuklear", target, static_);
}

string sharedOrStaticName(string base, string target, bool static_) @safe pure nothrow
{
    if (targetIsWindows(target))
        return static_ ? base ~ ".lib" : base ~ ".dll";
    if (targetIsDarwin(target))
        return static_ ? "lib" ~ base ~ ".a" : "lib" ~ base ~ ".dylib";
    if (targetIsWasm(target))
        return "lib" ~ base ~ ".a"; // wasm is always static
    return static_ ? "lib" ~ base ~ ".a" : "lib" ~ base ~ ".so"; // linux
}

// ---------------------------------------------------------------------------
// Compile helpers
// ---------------------------------------------------------------------------

/// Compile one source file to an object file.
void compileSource(string srcPath, string objPath, string compiler,
    string[] cflags, string target, bool verbose) @safe
{
    enforce(exists(srcPath), format("Source file does not exist: %s", srcPath));

    string[] cmd;
    if (targetIsWindows(target))
        cmd = [compiler] ~ cflags ~ ["/c", "/Fo" ~ objPath, srcPath];
    else
        cmd = [compiler] ~ cflags ~ ["-c", "-o", objPath, srcPath];

    executeOrFail(cmd, format("Failed to compile %s", srcPath.baseName), verbose);
}

/// Compile a list of source files; returns the list of object-file paths.
string[] compileSources(const(string[]) sources, string buildDir, string srcRoot,
    string compiler, string[] cflags, string prefix,
    string target, bool verbose) @safe
{
    string[] objFiles;
    foreach (src; sources)
    {
        immutable srcPath = buildPath(srcRoot, src);
        immutable objPath = buildPath(buildDir, prefix ~ src.baseName ~ objExt(target));
        compileSource(srcPath, objPath, compiler, cflags, target, verbose);
        objFiles ~= objPath;
    }
    return objFiles;
}

// ---------------------------------------------------------------------------
// Link helper
// ---------------------------------------------------------------------------

void linkLibrary(string libPath, string[] objFiles, string target,
    bool linkageStatic, string vendor, string[] lflags, bool verbose) @safe
{
    immutable isWin = targetIsWindows(target);
    immutable isMac = targetIsDarwin(target);
    immutable isWasm = targetIsWasm(target);

    string[] cmd;

    if (linkageStatic || isWasm)
    {
        // Static archive
        string ar;
        if (isWasm)
            ar = buildPath(vendor, "emsdk", "upstream", "emscripten", "emar") ~
                (isWindows() ? ".bat" : "");
        else if (isWin)
            ar = "lib.exe";
        else
            ar = "ar";

        if (isWin)
            cmd = [ar, "/nologo", "/OUT:" ~ libPath] ~ objFiles;
        else
            cmd = [ar, "rcs", libPath] ~ objFiles;
    }
    else
    {
        // Shared library
        if (isMac)
        {
            cmd = [findProgram("clang"), "-dynamiclib", "-o", libPath] ~ objFiles ~ lflags;
        }
        else if (isWin)
        {
            // cl.exe /LD
            cmd = [findProgram("cl"), "/LD", "/nologo", "/Fe:" ~ libPath] ~ objFiles ~ lflags;
        }
        else
        {
            cmd = [findProgram("gcc"), "-shared", "-o", libPath] ~ objFiles ~ lflags;
        }
    }

    executeOrFail(cmd, format("Failed to create %s", libPath.baseName), verbose);
}

// ---------------------------------------------------------------------------
// Determine the C++ compiler that matches the given C compiler
// ---------------------------------------------------------------------------

string cppCompiler(string cc, string target, string vendor) @safe
{
    if (targetIsWasm(target))
        return buildPath(vendor, "emsdk", "upstream", "emscripten", "em++") ~
            (
                isWindows() ? ".bat" : "");
    if (cc.canFind("clang"))
        return findProgram(cc.baseName ~ "++");
    if (cc.canFind("gcc"))
        return findProgram("g++");
    // MSVC: same compiler handles both C and C++
    return cc;
}

// ---------------------------------------------------------------------------
// WASM link / run steps
// ---------------------------------------------------------------------------

void emLinkStep(EmLinkOptions opts) @safe
{
    string emcc = buildPath(opts.vendor, "emsdk", "upstream", "emscripten",
        opts.use_imgui ? "em++" : "emcc") ~ (isWindows() ? ".bat" : "");
    string[] cmd = [emcc];

    if (opts.use_imgui)
        cmd ~= "-lcimgui";
    if (opts.use_nuklear)
        cmd ~= "-lnuklear";

    if (opts.optimize == "debug")
        cmd ~= ["-Og", "-sSAFE_HEAP=1", "-sSTACK_OVERFLOW_CHECK=1"];
    else
    {
        cmd ~= "-sASSERTIONS=0";
        cmd ~= opts.optimize == "small" ? "-Oz" : "-O3";
        if (opts.release_use_lto)
            cmd ~= "-flto";
        if (opts.release_use_closure)
            cmd ~= ["--closure", "1"];
    }

    if (opts.backend == SokolBackend.wgpu)
        cmd ~= "--use-port=emdawnwebgpu";
    if (opts.backend == SokolBackend.gles3)
        cmd ~= "-sUSE_WEBGL2=1";
    if (!opts.use_filesystem)
        cmd ~= "-sNO_FILESYSTEM=1";
    if (opts.use_emmalloc)
        cmd ~= "-sMALLOC='emmalloc'";
    if (opts.shell_file_path)
        cmd ~= "--shell-file=" ~ opts.shell_file_path;

    cmd ~= ["-sSTACK_SIZE=512KB"] ~ opts.extra_args ~ opts.lib_main;

    immutable baseName = opts.lib_main.baseName[3 .. $ - 2]; // strip "lib" and ".a"
    string outFile = buildPath("build", baseName ~ ".html");
    cmd ~= ["-o", outFile];

    executeOrFail(cmd, "emcc link failed for " ~ outFile, opts.verbose);

    string webDir = "web";
    mkdirRecurse(webDir);
    foreach (ext; [".html", ".wasm", ".js"])
        copy(buildPath("build", baseName ~ ext), buildPath(webDir, baseName ~ ext));
    rmdirRecurse(buildPath("build"));
}

void emRunStep(EmRunOptions opts) @safe
{
    string emrun = buildPath(opts.vendor, "emsdk", "upstream", "emscripten", "emrun") ~
        (
            isWindows() ? ".bat" : "");
    executeOrFail([emrun, buildPath("web", opts.name ~ ".html")], "emrun failed", opts.verbose);
}

// ---------------------------------------------------------------------------
// Emscripten SDK setup
// ---------------------------------------------------------------------------

void emSdkSetupStep(string emsdk) @safe
{
    if (!exists(buildPath(emsdk, ".emscripten")))
    {
        immutable cmd = buildPath(emsdk, "emsdk") ~ (isWindows() ? ".bat" : "");
        executeOrFail(
            [!isWindows() ? "bash " ~ cmd: cmd, "install", "latest"],
            "emsdk install failed", true);
        executeOrFail(
            [!isWindows() ? "bash " ~ cmd: cmd, "activate", "latest"],
            "emsdk activate failed", true);
    }
}

void embuilderStep(EmbuilderOptions opts) @safe
{
    string embuilder = buildPath(opts.vendor, "emsdk", "upstream", "emscripten", "embuilder") ~
        (
            isWindows() ? ".bat" : "");
    executeOrFail([embuilder, "build", opts.port_name],
        "embuilder failed to build " ~ opts.port_name, true);
}

// ---------------------------------------------------------------------------
// Utility functions
// ---------------------------------------------------------------------------

string findProgram(string programName) @safe
{
    foreach (path; environment.get("PATH").split(pathSeparator))
    {
        string fullPath = buildPath(path, programName);
        version (Windows)
            fullPath ~= ".exe";
        if (exists(fullPath) && isFile(fullPath))
            return fullPath;
    }
    throw new Exception(format("Program '%s' not found in PATH", programName));
}

string defaultCompiler(string target) @safe
{
    if (targetIsWasm(target))
        return ""; // set later from vendor/emsdk
    version (linux)
        return findProgram("gcc");
    version (Windows)
        return "cl"; // found via PATH / vcvarsall
    version (OSX)
        return findProgram("clang");
    version (Android)
        return findProgram("clang");
    throw new Exception("Unsupported platform for defaultCompiler");
}

SokolBackend resolveSokolBackend(SokolBackend backend, string target) @safe
{
    immutable t = resolveTarget(target);
    if (t.canFind("linux"))
        return backend == SokolBackend.vulkan ? SokolBackend.vulkan : SokolBackend.glcore;
    if (t.canFind("darwin"))
        return SokolBackend.metal;
    if (t.canFind("windows"))
        return backend == SokolBackend.vulkan ? SokolBackend.vulkan : SokolBackend.d3d11;
    if (t.canFind("wasm"))
        return backend == SokolBackend.wgpu ? backend : SokolBackend.gles3;
    if (t.canFind("android"))
        return SokolBackend.gles3;
    return backend;
}

void executeOrFail(string[] cmd, string errorMsg, bool verbose) @safe
{
    if (verbose)
        writeln("Executing: ", cmd.join(" "));
    auto result = executeShell(cmd.join(" "));
    if (verbose && result.output.length)
        writeln("Output:\n", result.output);
    enforce(result.status == 0, format("%s: %s", errorMsg, result.output));
}

bool isWindows() @safe nothrow
{
    version (Windows)
        return true;
    return false;
}

string defaultTarget() @safe
{
    version (linux)
        return "linux";
    version (Windows)
        return "windows";
    version (OSX)
        return "darwin";
    version (Android)
        return "android";
    version (Emscripten)
        return "wasm";
    throw new Exception("Unsupported platform");
}

// ---------------------------------------------------------------------------
// Download / zip helpers
// ---------------------------------------------------------------------------

void download(string url, string fileName) @trusted
{
    auto buf = appender!(ubyte[])();
    size_t contentLength;
    auto http = HTTP(url);
    http.onReceiveHeader((in k, in v) {
        if (k == "content-length")
            contentLength = to!size_t(v);
    });

    int barWidth = 50;
    http.onReceive((data) {
        buf.put(data);
        if (contentLength)
        {
            float progress = cast(float) buf.data.length / contentLength;
            write("\r[",
                "=".replicate(cast(int)(barWidth * progress)), ">",
                " ".replicate(barWidth - cast(int)(barWidth * progress)),
                "] ", format("%d%%", cast(int)(progress * 100)));
            stdout.flush();
        }
        return data.length;
    });

    http.perform();
    enforce(http.statusLine.code / 100 == 2 || http.statusLine.code == 302,
        format("HTTP request failed: %s", http.statusLine.code));
    std.file.write(fileName, buf.data);
    writeln();
}

void extractZip(string zipFile, string destination) @trusted
{
    ZipArchive archive = new ZipArchive(read(zipFile));
    string prefix = archive.directory.keys.front[0 .. $
        - archive.directory.keys.front.find("/")
            .length + 1];

    if (exists(destination))
        rmdirRecurse(destination);
    mkdirRecurse(destination);

    foreach (name, am; archive.directory)
    {
        if (!am.expandedSize)
            continue;
        string path = buildPath(destination, chompPrefix(name, prefix));
        mkdirRecurse(dirName(path));
        std.file.write(path, archive.expand(am));
    }
}

string getSHDC(string vendor) @safe
{
    string path = absolutePath(buildPath(vendor, "shdc"));
    string file = "shdc.zip";
    scope (exit)
        if (exists(file))
            remove(file);

    if (!exists(path))
    {
        download("https://github.com/floooh/sokol-tools-bin/archive/refs/heads/master.zip", file);
        extractZip(file, path);
    }

    version (Windows)
        immutable shdc = buildPath("bin", "win32", "sokol-shdc.exe");
    else version (linux)
        immutable shdc = buildPath("bin", isAArch64() ? "linux_arm64" : "linux", "sokol-shdc");
    else version (OSX)
        immutable shdc = buildPath("bin", isAArch64() ? "osx_arm64" : "osx", "sokol-shdc");
    else
        throw new Exception("Unsupported platform for sokol-tools");

    return buildPath(path, shdc);
}

bool isAArch64() @safe nothrow
{
    version (AArch64)
        return true;
    return false;
}

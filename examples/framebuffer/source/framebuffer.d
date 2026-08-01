//------------------------------------------------------------------------------
//  framebuffer.d - Example Sokol Framebuffer
//
//  Render into a CPU framebuffer and blit to window, based on the
//  sokol-zig framebuffer example.
//------------------------------------------------------------------------------
module examples.framebuffer;

private:

import sg = sokol.gfx;
import sapp = sokol.app;
import slog = sokol.log;
import sfb = sokol.framebuffer;
import sglue = sokol.glue;
import handmade.math : sin;

extern (C):
@safe:

enum FB_WIDTH = 320;
enum FB_HEIGHT = 240;

static struct State
{
    sg.PassAction pass_action = {
        colors: [{
            load_action: sg.LoadAction.Clear,
            clear_value: {r: 0.25, g: 0.5, b: 0.75, a: 1.0},
        }],
    };
    sfb.Framebuffer fb;
}

static State state;

static uint[FB_WIDTH][FB_HEIGHT] pixels;

uint rgb(ubyte r, ubyte g, ubyte b) pure nothrow @nogc
{
    return cast(uint)(r) + (cast(uint)(g) << 8) + (cast(uint)(b) << 16);
}

static immutable uint[16] palette_rgb = [
    rgb(0x0d, 0x08, 0x14),
    rgb(0x36, 0x1d, 0x59),
    rgb(0x65, 0x33, 0x99),
    rgb(0x5c, 0x69, 0xd4),
    rgb(0x5c, 0xc1, 0xe5),
    rgb(0x88, 0xe3, 0xbb),
    rgb(0xd8, 0xea, 0x79),
    rgb(0xff, 0xe0, 0x6d),
    rgb(0xff, 0xad, 0x58),
    rgb(0xf0, 0x70, 0x44),
    rgb(0xd0, 0x42, 0x5f),
    rgb(0xaf, 0x42, 0x95),
    rgb(0x82, 0x3e, 0xb0),
    rgb(0x52, 0x3d, 0x82),
    rgb(0x28, 0x24, 0x49),
    rgb(0x12, 0x0b, 0x18),
];

float sintab(float i) pure nothrow @nogc
{
    const float f = i * 2.0f + 1.0f;
    return 128.0f + 125.0f * sin(f * 3.14159265358979f / 256.0f);
}

void init()
{
    sg.Desc gfxd = {
        environment: sglue.environment,
        logger: {func: &slog.func},
    };
    sg.setup(gfxd);

    sfb.Desc sfb_desc = {
        logger: {func: &slog.func},
    };
    sfb.setup(sfb_desc);

    sfb.FramebufferDesc fb_desc = {
        width: FB_WIDTH,
        height: FB_HEIGHT,
    };
    state.fb = sfb.makeFramebuffer(fb_desc);
}

void frame()
{
    // CPU render some pixels. Loosely ported from https://www.shadertoy.com/view/4dXfWf
    const float t = cast(float)(sapp.frameCount()) * 0.1f;
    const float s = 75.0f + 12.0f * sin(t * 0.02f);
    foreach (y; 0 .. FB_HEIGHT)
    {
        foreach (x; 0 .. FB_WIDTH)
        {
            const float fx = cast(float)(x) / 4.0f;
            const float fy = cast(float)(y) / 4.0f;
            const float xs = (sintab(((fx - 40.0f) * s * 8.0f + t * 456.0f) / 256.0f)
                + sintab(((fx - 40.0f) * s * 13.0f - t * 321.0f) / 256.0f)) / 16.0f;
            const float ys = (sintab(((fy - 25.0f) * s * 9.0f + t * 567.0f) / 256.0f)
                + sintab(((fy - 25.0f) * s * 13.0f - t * 123.0f) / 256.0f)) / 16.0f;
            const int idx = cast(int)(xs + ys);
            pixels[y][x] = palette_rgb[idx & 15];
        }
    }

    // update the pixel data
    sfb.UpdateDesc upd = {
        pixels: sg.Range(&pixels, pixels.sizeof),
    };
    sfb.update(state.fb, upd);

    // draw framebuffer in a sokol-gfx render pass
    // dfmt off
    sg.Pass pass = {
        action: state.pass_action,
        swapchain: sglue.swapchain,
    };
    // dfmt on
    sg.beginPass(pass);
    sfb.RenderDesc rd = {use_nearest_filter: true};
    sfb.renderEx(state.fb, rd);
    sg.endPass();
    sg.commit();
}

void cleanup()
{
    sfb.shutdown();
    sg.shutdown();
}

void main()
{
    // dfmt off
    sapp.Desc runner = {
        window_title: "framebuffer.d",
        init_cb: &init,
        frame_cb: &frame,
        cleanup_cb: &cleanup,
        width: 800,
        height: 600,
        icon: {sokol_default: true},
        logger: {func: &slog.func},
    };
    sapp.run(runner);
    // dfmt on
}

version (WebAssembly)
{
    debug
    {
        import emscripten.assertd;
    }
}

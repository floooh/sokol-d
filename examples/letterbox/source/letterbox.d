//------------------------------------------------------------------------------
//  letterbox.d - Example Sokol LetterBox
//
//  Demonstrate/test sokol_letterbox.h
//------------------------------------------------------------------------------
module examples.letterbox;

private:

import sg = sokol.gfx;
import sapp = sokol.app;
import slog = sokol.log;
import sglue = sokol.glue;
import slbx = sokol.letterbox;
import sgl = sokol.gl;
import simgui = sokol.imgui;
import imgui.cimgui;

extern (C):
@safe:

enum NUM_ANCHORS = 5;

static struct State
{
    sg.PassAction pass_action = {
        colors: [{
            load_action: sg.LoadAction.Clear,
            clear_value: {r: 0.0, g: 0.0, b: 0.0, a: 1.0},
        }],
    };
    slbx.LetterboxDesc lbox = {
        content_aspect_ratio: 4.0f / 3.0f,
    };
    bool link_lr_border = true;
    bool link_tb_border = true;
    int cur_anchor_idx = 0;
}

static State state;

static immutable slbx.Anchor[NUM_ANCHORS] anchor_values = [
    slbx.Anchor.Center, slbx.Anchor.Top, slbx.Anchor.Bottom,
    slbx.Anchor.Left, slbx.Anchor.Right,
];
static immutable string[NUM_ANCHORS] anchor_labels = [
    "Center", "Top", "Bottom", "Left", "Right",
];

void init() @trusted nothrow
{
    sg.Desc gfxd = {
        environment: sglue.environment,
        logger: {func: &slog.func},
    };
    sg.setup(gfxd);

    sgl.Desc gld = {
        logger: {func: &slog.func},
    };
    sgl.setup(gld);

    simgui.Desc simgui_desc = {
        logger: {func: &slog.func},
    };
    simgui.setup(simgui_desc);
}

void frame() @trusted nothrow
{
    draw_ui();
    const int width = sapp.width();
    const int height = sapp.height();

    // draw a letterboxed fullscreen quad via sgl
    sgl.defaults();
    const slbx.Viewport vp = slbx.letterbox(width, height, state.lbox);
    sgl.viewport(vp.x, vp.y, vp.width, vp.height, true);
    sgl.beginQuads();
    main_quad();
    corner_quad(-0.9f, +0.9f);
    corner_quad(+0.9f, +0.9f);
    corner_quad(+0.9f, -0.9f);
    corner_quad(-0.9f, -0.9f);
    sgl.end();
    sgl.viewport(0, 0, width, height, true);

    // render everything in a sokol-gfx pass
    // dfmt off
    sg.Pass pass = {
        action: state.pass_action,
        swapchain: sglue.swapchain,
    };
    // dfmt on
    sg.beginPass(pass);
    sgl.draw();
    simgui.render();
    sg.endPass();
    sg.commit();
}

void cleanup() @safe nothrow
{
    simgui.shutdown();
    sgl.shutdown();
    sg.shutdown();
}

void event(const(sapp.Event)* ev) @trusted nothrow
{
    simgui.simgui_handle_event(ev);
}

const(char)* anchor_getter(void* userdata, int index) pure nothrow @nogc
{
    assert((index >= 0) && (index < NUM_ANCHORS));
    return &anchor_labels[index][0];
}

void draw_ui() @trusted nothrow
{
    // dfmt off
    simgui.FrameDesc frame_desc = {
        width: sapp.width(),
        height: sapp.height(),
        delta_time: sapp.frameDuration(),
        dpi_scale: sapp.dpiScale(),
    };
    // dfmt on
    simgui.newFrame(frame_desc);
    const ImVec2 window_pos = {30, 50};
    SetNextWindowPos(window_pos, ImGuiCond_.ImGuiCond_Once);
    SetNextWindowBgAlpha(0.75f);
    if (Begin("Controls", null, ImGuiWindowFlags_.ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_.ImGuiWindowFlags_AlwaysAutoResize))
    {
        Text("Resize app window!\n");
        SliderFloat("Content Aspect Ratio", &state.lbox.content_aspect_ratio, 0.5f, 2.0f);
        if (ComboCallback("Anchor", &state.cur_anchor_idx, &anchor_getter, null, NUM_ANCHORS))
        {
            state.lbox.anchor = anchor_values[state.cur_anchor_idx];
        }
        SeparatorText("Border");
        Checkbox("Link Left/Right", &state.link_lr_border);
        if (SliderInt("Left", &state.lbox.border.left, -50, 50) && state.link_lr_border)
        {
            state.lbox.border.right = state.lbox.border.left;
        }
        if (SliderInt("Right", &state.lbox.border.right, -50, 50) && state.link_lr_border)
        {
            state.lbox.border.left = state.lbox.border.right;
        }
        Checkbox("Link Top/Bottom", &state.link_tb_border);
        if (SliderInt("Top", &state.lbox.border.top, -50, 50) && state.link_tb_border)
        {
            state.lbox.border.bottom = state.lbox.border.top;
        }
        if (SliderInt("Bottom", &state.lbox.border.bottom, -50, 50) && state.link_tb_border)
        {
            state.lbox.border.top = state.lbox.border.bottom;
        }
    }
    End();
}

void main_quad() nothrow
{
    sgl.v2fC3b(-1.0f, +1.0f, 255, 0, 0);
    sgl.v2fC3b(+1.0f, +1.0f, 255, 255, 0);
    sgl.v2fC3b(+1.0f, -1.0f, 0, 255, 0);
    sgl.v2fC3b(-1.0f, -1.0f, 0, 255, 255);
}

void corner_quad(float x, float y) nothrow
{
    float s = 0.05f;
    ubyte r = 255;
    ubyte g = 128;
    ubyte b = 255;
    sgl.v2fC3b(x - s, y + s, r, g, b);
    sgl.v2fC3b(x + s, y + s, r, g, b);
    sgl.v2fC3b(x + s, y - s, r, g, b);
    sgl.v2fC3b(x - s, y - s, r, g, b);
}

void main() @safe nothrow
{
    // dfmt off
    sapp.Desc runner = {
        window_title: "letterbox.d",
        init_cb: &init,
        frame_cb: &frame,
        cleanup_cb: &cleanup,
        event_cb: &event,
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

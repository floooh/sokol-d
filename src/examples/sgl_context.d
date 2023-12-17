//------------------------------------------------------------------------------
//  sgl-context.d
//
//  Demonstrates how to render into different render passes with sokol-gl.
//  using contexts.
//------------------------------------------------------------------------------
module examples.sgl_context;

import std.stdio;
import sg = sokol.gfx;
import sgapp = sokol.glue;
import sapp = sokol.app;
import log = sokol.log;
import sgl = sokol.gl;
import std.math : sin, cos;

struct State
{
    struct Offscreen
    {
        sg.PassAction pass_action;
        sg.Pass pass;
        sg.Image img;
        sgl.Context sgl_ctx;
    }

    struct Display
    {
        sg.PassAction pass_action;
        sg.Sampler smp;
        sgl.Pipeline sgl_pip;
    }
}

enum offscreen_pixel_format = sg.PixelFormat.RGBA8;
enum offscreen_sample_count = 1;
enum offscreen_width = 32;
enum offscreen_height = 32;

State.Offscreen offscreen;
State.Display display;

void init()
{
    sg.Desc gfxd;
    gfxd.context = sgapp.context();
    gfxd.logger.func = &log.func;
    sg.setup(gfxd);

    // setup sokol-gl with the default context compatible with the default
    // render pass (which means just keep pixelformats and sample count at defaults)
    //
    // reduce the vertex- and command-count though, otherwise we just waste memory
    sgl.Desc gld;
    gld.max_vertices = 64;
    gld.max_commands = 16;
    gld.logger.func = &log.func;
    sgl.setup(gld);

    // initialize a pass action struct for the default pass to clear to a light-blue color
    display.pass_action.colors[0].load_action = sg.LoadAction.CLEAR;
    display.pass_action.colors[0].clear_value.r = 0.5;
    display.pass_action.colors[0].clear_value.g = 0.7;
    display.pass_action.colors[0].clear_value.b = 1;
    display.pass_action.colors[0].clear_value.a = 1;

    // create a sokol-gl pipeline object for 3D rendering into the default pass
    sg.PipelineDesc pld;
    pld.cull_mode = sg.CullMode.BACK;
    pld.depth.write_enabled = true;
    pld.depth.compare = sg.CompareFunc.LESS_EQUAL;
    display.sgl_pip = sgl.contextMakePipeline(sgl.defaultContext, pld);

    // create a sokol-gl context compatible with the offscreen render pass
    // (specific color pixel format, no depth-stencil-surface, no MSAA)
    sgl.ContextDesc ctd;
    ctd.max_vertices = 8;
    ctd.max_commands = 4;
    ctd.color_format = offscreen_pixel_format,
    ctd.depth_format = sg.PixelFormat.NONE,
    ctd.sample_count = offscreen_sample_count,

    offscreen.sgl_ctx = sgl.makeContext(ctd);

    // create an offscreen render target texture, pass and pass-action
    sg.ImageDesc imgd;
    imgd.render_target = true,
    imgd.width = offscreen_width,
    imgd.height = offscreen_height,
    imgd.pixel_format = offscreen_pixel_format,
    imgd.sample_count = offscreen_sample_count,

    offscreen.img = sg.makeImage(imgd);

    sg.PassDesc pass_desc;
    pass_desc.color_attachments[0].image = offscreen.img;
    offscreen.pass = sg.makePass(pass_desc);

    offscreen.pass_action.colors[0].load_action = sg.LoadAction.CLEAR;
    offscreen.pass_action.colors[0].clear_value.r = 0;
    offscreen.pass_action.colors[0].clear_value.g = 0;
    offscreen.pass_action.colors[0].clear_value.b = 0;
    offscreen.pass_action.colors[0].clear_value.a = 1;

    // sampler for sampling the offscreen render target
    sg.SamplerDesc smd;
    smd.wrap_u = sg.Wrap.CLAMP_TO_EDGE,
    smd.wrap_v = sg.Wrap.CLAMP_TO_EDGE,
    smd.min_filter = sg.Filter.NEAREST,
    smd.mag_filter = sg.Filter.NEAREST,
    display.smp = sg.makeSampler(smd);
}

void frame()
{
    const a = sgl.asRadians(sapp.frameCount());

    // draw a rotating quad into the offscreen render target texture
    sgl.setContext(offscreen.sgl_ctx);
    sgl.defaults();
    sgl.matrixModeModelview();
    sgl.rotate(a, 0, 0, 1);
    draw_quad();

    // draw a rotating 3D cube, using the offscreen render target as texture
    sgl.setContext(sgl.defaultContext());
    sgl.defaults();
    sgl.enableTexture();
    sgl.texture(offscreen.img, display.smp);
    sgl.loadPipeline(display.sgl_pip);
    sgl.matrixModeProjection();
    sgl.perspective(sgl.asRadians(45.0), sapp.widthf() / sapp.heightf(), 0.1, 100.0);
    const(float)[3] eye = [
        sin(a) * 6.0,
        sin(a) * 3.0,
        cos(a) * 6.0,
    ];
    sgl.matrixModeModelview();
    sgl.lookat(eye[0], eye[1], eye[2], 0, 0, 0, 0, 1, 0);
    draw_cube();

    // do the actual offscreen and display rendering in sokol-gfx passes
    sg.beginPass(offscreen.pass, offscreen.pass_action);
    sgl.contextDraw(offscreen.sgl_ctx);
    sg.endPass();
    sg.beginDefaultPass(display.pass_action, sapp.width(), sapp.height());
    sgl.contextDraw(sgl.defaultContext());
    sg.endPass();
    sg.commit();
}

void cleanup()
{
    sgl.shutdown();
    sg.shutdown();
}

void main()
{
    sapp.IconDesc icon = {sokol_default: true};
    sapp.Desc runner = {
        window_title: "sgl_context.d",
        init_cb: &init,
        frame_cb: &frame,
        cleanup_cb: &cleanup,
        width: 800,
        height: 600,
        sample_count: 4,
    };
    runner.icon = icon;
    runner.logger.func = &log.func;
    sapp.run(runner);
}

void draw_quad()
{
    sgl.beginQuads();
    sgl.v2fC3b(0.0, -1.0, 255, 0, 0);
    sgl.v2fC3b(1.0, 0.0, 0, 0, 255);
    sgl.v2fC3b(0.0, 1.0, 0, 255, 255);
    sgl.v2fC3b(-1.0, 0.0, 0, 255, 0);
    sgl.end();
}

void draw_cube()
{
    sgl.beginQuads();
    sgl.v3fT2f(-1.0, 1.0, -1.0, 0.0, 1.0);
    sgl.v3fT2f(1.0, 1.0, -1.0, 1.0, 1.0);
    sgl.v3fT2f(1.0, -1.0, -1.0, 1.0, 0.0);
    sgl.v3fT2f(-1.0, -1.0, -1.0, 0.0, 0.0);
    sgl.v3fT2f(-1.0, -1.0, 1.0, 0.0, 1.0);
    sgl.v3fT2f(1.0, -1.0, 1.0, 1.0, 1.0);
    sgl.v3fT2f(1.0, 1.0, 1.0, 1.0, 0.0);
    sgl.v3fT2f(-1.0, 1.0, 1.0, 0.0, 0.0);
    sgl.v3fT2f(-1.0, -1.0, 1.0, 0.0, 1.0);
    sgl.v3fT2f(-1.0, 1.0, 1.0, 1.0, 1.0);
    sgl.v3fT2f(-1.0, 1.0, -1.0, 1.0, 0.0);
    sgl.v3fT2f(-1.0, -1.0, -1.0, 0.0, 0.0);
    sgl.v3fT2f(1.0, -1.0, 1.0, 0.0, 1.0);
    sgl.v3fT2f(1.0, -1.0, -1.0, 1.0, 1.0);
    sgl.v3fT2f(1.0, 1.0, -1.0, 1.0, 0.0);
    sgl.v3fT2f(1.0, 1.0, 1.0, 0.0, 0.0);
    sgl.v3fT2f(1.0, -1.0, -1.0, 0.0, 1.0);
    sgl.v3fT2f(1.0, -1.0, 1.0, 1.0, 1.0);
    sgl.v3fT2f(-1.0, -1.0, 1.0, 1.0, 0.0);
    sgl.v3fT2f(-1.0, -1.0, -1.0, 0.0, 0.0);
    sgl.v3fT2f(-1.0, 1.0, -1.0, 0.0, 1.0);
    sgl.v3fT2f(-1.0, 1.0, 1.0, 1.0, 1.0);
    sgl.v3fT2f(1.0, 1.0, 1.0, 1.0, 0.0);
    sgl.v3fT2f(1.0, 1.0, -1.0, 0.0, 0.0);
    sgl.end();
}
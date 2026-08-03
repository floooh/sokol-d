//------------------------------------------------------------------------------
//  box3d.d
//
//  Basic integration with the Box3D physics engine, ported from:
//  https://github.com/floooh/sokol-samples/blob/master/sapp/box3d-simple-sapp.c
//------------------------------------------------------------------------------

module app;

private:

import sg = sokol.gfx;
import sgapp = sokol.glue;
import sapp = sokol.app;
import stm = sokol.time;
import slog = sokol.log;
import sshape = sokol.shape;
import simgui = sokol.imgui;
import sgimgui = sokol.gfximgui;
import sappimgui = sokol.appimgui;
import imgui.cimgui;
import box3d;
import m = handmade.math;
import shd = shaders.box3d;

enum max_shapes = 1024;
enum max_instances = (max_shapes / 2) + 1;
enum ground_size = 200.0f;
enum ball_radius = 1.0f;
enum box_size = 1.5f;
enum shadow_map_size = 2048;
enum usec_per_sec = 1000000.0;
enum physics_tick_usec = cast(ulong)((1.0 / 250.0) * usec_per_sec);
enum spawn_interval_sec = 0.25;

extern (C):
@safe:

struct InstData
{
    m.Vec4 xxxx;
    m.Vec4 yyyy;
    m.Vec4 zzzz;
    m.Vec4 color;
}

// quick'n'dirty Maya-style orbit camera (port of util/camera.h)
struct Camera
{
    float min_dist = 2.0f;
    float max_dist = 30.0f;
    float min_lat = -85.0f;
    float max_lat = 85.0f;
    float distance = 5.0f;
    float latitude = 0.0f;
    float longitude = 0.0f;
    float fov = 60.0f;
    float nearz = 0.01f;
    float farz = 100.0f;
    m.Vec3 center;
    m.Vec3 eye_pos;

    static float def(float val, float dflt) @nogc nothrow
    {
        return val == 0.0f ? dflt : val;
    }

    void init(m.Vec3 center_, float latitude, float longitude, float distance_,
        float max_dist_) @nogc nothrow
    {
        this.min_dist = 2.0f;
        this.max_dist = def(max_dist_, 30.0f);
        this.min_lat = -85.0f;
        this.max_lat = 85.0f;
        this.distance = def(distance_, 5.0f);
        this.center = center_;
        this.latitude = latitude;
        this.longitude = longitude;
        this.fov = 60.0f;
        this.nearz = 0.01f;
        this.farz = 100.0f;
    }

    void orbit(float dx, float dy) @nogc nothrow
    {
        longitude -= dx;
        if (longitude < 0.0f)
        {
            longitude += 360.0f;
        }
        if (longitude > 360.0f)
        {
            longitude -= 360.0f;
        }
        latitude = m.clamp(latitude + dy, min_lat, max_lat);
    }

    void zoom(float d) @nogc nothrow
    {
        distance = m.clamp(distance + d * distance * 0.1f, min_dist, max_dist);
    }

    void update(int fb_width, int fb_height) @nogc nothrow
    {
        const float lat = m.radians(latitude);
        const float lng = m.radians(longitude);
        const m.Vec3 dir = m.Vec3(
            m.cos(lat) * m.sin(lng),
            m.sin(lat),
            m.cos(lat) * m.cos(lng));
        eye_pos = m.Vec3.add(center, m.Vec3.mul(dir, distance));
    }

    void handleEvent(const(sapp.Event)* ev) @trusted nothrow
    {
        switch (ev.type)
        {
            case sapp.EventType.Mouse_down:
                if (ev.mouse_button == sapp.Mousebutton.Left)
                {
                    sapp.lockMouse(true);
                }
                break;
            case sapp.EventType.Mouse_up:
                if (ev.mouse_button == sapp.Mousebutton.Left)
                {
                    sapp.lockMouse(false);
                }
                break;
            case sapp.EventType.Mouse_scroll:
                zoom(ev.scroll_y * 0.5f);
                break;
            case sapp.EventType.Mouse_move:
                if (sapp.mouseLocked())
                {
                    orbit(ev.mouse_dx * 0.25f, ev.mouse_dy * 0.25f);
                }
                break;
            default:
                break;
        }
    }
}

struct Shapes
{
    sshape.ElementRange plane;
    sshape.ElementRange ball;
    sshape.ElementRange box;
}

struct Shadow
{
    sg.Pass pass;
    sg.View tex_view;
    sg.Sampler smp;
    sg.Pipeline inst_pip;
}

struct Display
{
    sg.PassAction pass_action;
    sg.Pipeline pip;
    sg.Pipeline inst_pip;
}

struct Profiling
{
    ulong physics_world_step_time;
    ulong copy_transforms_time;
    int sub_steps_per_frame;
    int num_awake_bodies;
}

struct Ui
{
    bool show_sleeping;
}

struct Physics
{
    b3WorldId world;
    b3BodyId ground;
    long tick_error_us;
    int num_bodies;
    b3BodyId[max_shapes] bodies;
}

struct InstDataBlock
{
    int num_boxes;
    int num_balls;
    InstData[max_instances] boxes;
    InstData[max_instances] balls;
}

struct State
{
    sg.Buffer vbuf;
    sg.Buffer ibuf;
    sg.Buffer box_inst_buf;
    sg.Buffer ball_inst_buf;
    Shapes shapes;
    Shadow shadow;
    Display display;
    double spawn_timer = 0.0;
    Camera camera;
    m.Vec3 light_pos;
    m.Mat4 light_view_proj;
    m.Mat4 view_proj;
    Profiling profiling;
    Ui ui;
    Physics physics;
    InstDataBlock inst_data;
}

static State state;

@trusted nothrow:
void init()
{
    stm.setup;
    sg.Desc gfx = {
        environment: sgapp.environment,
        logger: {func: &slog.slog_func}
    };
    sg.setup(gfx);
    sgimgui.Desc sgimgui_desc;
    sgimgui.setup(sgimgui_desc);
    sappimgui.setup;
    simgui.Desc imgui_desc = {0};
    simgui.setup(imgui_desc);

    state.camera.init(m.Vec3(0.0f, 0.0f, 0.0f), 25.0f, 225.0f, 50.0f, 300.0f);
    physicsInit();
    gfxInit();
}

void frame()
{
    state.camera.update(sapp.width(), sapp.height());
    state.spawn_timer -= sapp.frameDuration();
    if (state.spawn_timer <= 0.0)
    {
        state.spawn_timer += spawn_interval_sec;
        physicsAddBody();
    }
    physicsUpdate();
    updateInstanceBuffers();
    updateMatrices();
    uiDraw();

    sg.beginPass(state.shadow.pass);
    drawInstancedShapesShadowPass(&state.shapes.box, state.box_inst_buf, state.inst_data.num_boxes);
    drawInstancedShapesShadowPass(&state.shapes.ball, state.ball_inst_buf, state.inst_data.num_balls);
    sg.endPass();

    // display pass (ground + hardware-instanced physics body shapes)
    sg.Pass pass = {action: state.display.pass_action, swapchain: sgapp.swapchain};
    sg.beginPass(pass);
    drawShapeDisplayPass(&state.shapes.plane, m.Mat4.identity, m.Vec4(0.5f, 0.5f, 0.5f, 1.0f));
    drawInstancedShapesDisplayPass(&state.shapes.box, state.box_inst_buf, state.inst_data.num_boxes);
    drawInstancedShapesDisplayPass(&state.shapes.ball, state.ball_inst_buf, state.inst_data.num_balls);
    simgui.render;
    sg.endPass;
    sg.commit;
}

void input(const(sapp.Event)* ev)
{
    sappimgui.sappimgui_track_event(ev);
    if (simgui.simgui_handle_event(ev))
    {
        return;
    }
    state.camera.handleEvent(ev);
}

void cleanup() @safe nothrow
{
    physicsCleanup();
    sgimgui.shutdown;
    sappimgui.shutdown;
    simgui.shutdown;
    sg.shutdown;
}

void updateMatrices() @trusted nothrow
{
    // matrices for shadow pass
    const m.Mat4 light_view = m.Mat4.lookAt(state.light_pos, m.Vec3(0.0f, 0.0f, 0.0f), m.Vec3(0.0f, 1.0f, 0.0f));
    const m.Mat4 light_proj = m.Mat4.ortho(-100.0f, 100.0f, -100.0f, 100.0f, 1.0f, 250.0f);
    state.light_view_proj = m.Mat4.mul(light_proj, light_view);

    // matrices for display pass
    const m.Mat4 proj = m.Mat4.perspective(60.0f, sapp.widthf() / sapp.heightf(), 0.1f, 500.0f);
    const m.Mat4 view = m.Mat4.lookAt(state.camera.eye_pos, m.Vec3(0.0f, 0.0f, 0.0f), m.Vec3(0.0f, 1.0f, 0.0f));
    state.view_proj = m.Mat4.mul(proj, view);
}

void updateInstanceBuffers() @trusted nothrow
{
    if (state.inst_data.num_boxes > 0)
    {
        sg.Range r = {ptr: &state.inst_data.boxes[0], size: InstData.sizeof * state.inst_data.num_boxes};
        sg.updateBuffer(state.box_inst_buf, r);
    }
    if (state.inst_data.num_balls > 0)
    {
        sg.Range r = {ptr: &state.inst_data.balls[0], size: InstData.sizeof * state.inst_data.num_balls};
        sg.updateBuffer(state.ball_inst_buf, r);
    }
}

void drawInstancedShapesShadowPass(const(sshape.ElementRange)* shape, sg.Buffer inst_buf, int num_instances) @trusted nothrow
{
    if (num_instances == 0)
    {
        return;
    }
    shd.ShadowInstVsParams vs_params = {
        light_view_proj: state.light_view_proj,
    };
    sg.applyPipeline(state.shadow.inst_pip);
    sg.Bindings bindings = {
        vertex_buffers: [0: state.vbuf, 1: inst_buf],
        index_buffer: state.ibuf,
    };
    sg.applyBindings(bindings);
    sg.Range r = {ptr: &vs_params, size: vs_params.sizeof};
    sg.applyUniforms(shd.UB_SHADOW_INST_VS_PARAMS, r);
    sg.draw(shape.base_element, shape.num_elements, num_instances);
}

void drawShapeDisplayPass(const(sshape.ElementRange)* shape, m.Mat4 model, m.Vec4 color) @trusted nothrow
{
    shd.DisplayVsParams vs_params = {
        model: model,
        mvp: m.Mat4.mul(state.view_proj, model),
        light_mvp: m.Mat4.mul(state.light_view_proj, model),
        diff_color: color,
    };
    shd.DisplayFsParams fs_params = {
        eye_pos: state.camera.eye_pos,
        light_dir: m.Vec3.norm(state.light_pos),
    };
    sg.applyPipeline(state.display.pip);
    sg.Bindings bindings = {
        vertex_buffers: [0: state.vbuf],
        index_buffer: state.ibuf,
        views: [shd.VIEW_SHADOW_MAP: state.shadow.tex_view],
        samplers: [shd.SMP_SHADOW_SAMPLER: state.shadow.smp],
    };
    sg.applyBindings(bindings);
    sg.Range r_vs = {ptr: &vs_params, size: vs_params.sizeof};
    sg.applyUniforms(shd.UB_DISPLAY_VS_PARAMS, r_vs);
    sg.Range r_fs = {ptr: &fs_params, size: fs_params.sizeof};
    sg.applyUniforms(shd.UB_DISPLAY_FS_PARAMS, r_fs);
    sg.draw(shape.base_element, shape.num_elements, 1);
}

void drawInstancedShapesDisplayPass(const(sshape.ElementRange)* shape, sg.Buffer inst_buf, int num_instances) @trusted nothrow
{
    if (num_instances == 0)
    {
        return;
    }
    shd.DisplayInstVsParams vs_params = {
        view_proj: state.view_proj,
        light_view_proj: state.light_view_proj,
        awake_filter: state.ui.show_sleeping ? 1.0f : 0.0f,
    };
    shd.DisplayFsParams fs_params = {
        eye_pos: state.camera.eye_pos,
        light_dir: m.Vec3.norm(state.light_pos),
    };
    sg.applyPipeline(state.display.inst_pip);
    sg.Bindings bindings = {
        vertex_buffers: [0: state.vbuf, 1: inst_buf],
        index_buffer: state.ibuf,
        views: [shd.VIEW_SHADOW_MAP: state.shadow.tex_view],
        samplers: [shd.SMP_SHADOW_SAMPLER: state.shadow.smp],
    };
    sg.applyBindings(bindings);
    sg.Range r_vs = {ptr: &vs_params, size: vs_params.sizeof};
    sg.applyUniforms(shd.UB_DISPLAY_INST_VS_PARAMS, r_vs);
    sg.Range r_fs = {ptr: &fs_params, size: fs_params.sizeof};
    sg.applyUniforms(shd.UB_DISPLAY_FS_PARAMS, r_fs);
    sg.draw(shape.base_element, shape.num_elements, num_instances);
}

void physicsInit() @trusted nothrow
{
    b3WorldDef world_def = b3DefaultWorldDef();
    state.physics.world = b3CreateWorld(&world_def);

    b3BodyDef ground_body_def = b3DefaultBodyDef();
    ground_body_def.position = b3Vec3(0.0f, -10.0f, 0.0f);
    state.physics.ground = b3CreateBody(state.physics.world, &ground_body_def);

    const float hs = ground_size * 0.5f;
    b3BoxHull ground_box = b3MakeBoxHull(hs, 10.0f, hs);
    b3ShapeDef ground_shape_def = b3DefaultShapeDef();
    b3CreateHullShape(state.physics.ground, &ground_shape_def, &ground_box.base);
}

void copyInstanceTransform(InstData* inst_data, const(b3WorldTransform)* tf) @trusted nothrow
{
    const m.Mat4 rm = m.Mat4.fromQuat(tf.q.v.x, tf.q.v.y, tf.q.v.z, tf.q.s);
    const m.Mat4 tm = m.Mat4.translate(m.Vec3(tf.p.x, tf.p.y, tf.p.z));
    // column-major model matrix: rotate, then translate
    const m.Mat4 model = m.Mat4.mul(tm, rm);
    // the shader reconstructs the instance transform from the three rows
    // (translation is stored in the 4th component of each row)
    inst_data.xxxx = m.Vec4(model.m[0][0], model.m[1][0], model.m[2][0], model.m[3][0]);
    inst_data.yyyy = m.Vec4(model.m[0][1], model.m[1][1], model.m[2][1], model.m[3][1]);
    inst_data.zzzz = m.Vec4(model.m[0][2], model.m[1][2], model.m[2][2], model.m[3][2]);
}

void physicsUpdate() @trusted nothrow
{
    const double dt_sec = sapp.frameDuration();
    const long dt_usec = cast(long)(dt_sec * usec_per_sec);
    state.physics.tick_error_us += dt_usec;
    long num_sub_steps = state.physics.tick_error_us / cast(long)physics_tick_usec;
    state.physics.tick_error_us -= num_sub_steps * cast(long)physics_tick_usec;
    ulong t = stm.now;
    b3World_Step(state.physics.world, cast(float)dt_sec, cast(int)num_sub_steps);
    state.profiling.physics_world_step_time = stm.since(t);
    state.profiling.sub_steps_per_frame = cast(int)num_sub_steps;

    // update moved body transform matrices
    t = stm.now;
    b3BodyEvents events = b3World_GetBodyEvents(state.physics.world);
    for (int i = 0; i < events.moveCount; i++)
    {
        b3BodyMoveEvent* ev = &events.moveEvents[i];
        InstData* inst_data = cast(InstData*)ev.userData;
        copyInstanceTransform(inst_data, &ev.transform);
    }
    state.profiling.copy_transforms_time = stm.since(t);
    state.profiling.num_awake_bodies = b3World_GetAwakeBodyCount(state.physics.world);

    if (state.ui.show_sleeping)
    {
        for (int i = 0; i < state.physics.num_bodies; i++)
        {
            InstData* inst_data = cast(InstData*)b3Body_GetUserData(state.physics.bodies[i]);
            if (b3Body_IsAwake(state.physics.bodies[i]))
            {
                inst_data.color.w = 0.0f;
            }
            else
            {
                inst_data.color.w = 1.0f;
            }
        }
    }
}

uint xorshift32() @nogc nothrow
{
    static uint x = 0x12345678;
    x ^= x << 13;
    x ^= x >> 17;
    x ^= x << 5;
    return x;
}

m.Vec3 randUvec3() @nogc nothrow
{
    const uint c = xorshift32();
    const float x = cast(float)(c & 255) / 255.0f;
    const float y = cast(float)((c >> 8) & 255) / 255.0f;
    const float z = cast(float)((c >> 16) & 255) / 255.0f;
    return m.Vec3(x, y, z);
}

m.Vec3 randIvec3() @nogc nothrow
{
    const m.Vec3 v = randUvec3();
    return m.Vec3.mul(m.Vec3.sub(v, m.Vec3(0.5f, 0.5f, 0.5f)), 2.0f);
}

bool physicsIsBox(int idx) @nogc nothrow
{
    // even indices are boxes, odd indices are balls
    return (idx & 1) == 0;
}

void physicsAddBody() @trusted nothrow
{
    const int idx = state.physics.num_bodies;
    if (idx >= max_shapes)
    {
        return;
    }
    InstData* inst_data = null;
    if (physicsIsBox(idx))
    {
        inst_data = &state.inst_data.boxes[state.inst_data.num_boxes++];
    }
    else
    {
        inst_data = &state.inst_data.balls[state.inst_data.num_balls++];
    }

    const m.Vec3 pos = m.Vec3(0.0f, 15.0f, 0.0f);
    b3BodyDef body_def = b3DefaultBodyDef();
    body_def.type = b3_dynamicBody;
    body_def.position = b3Vec3(pos.x, pos.y, pos.z);
    body_def.userData = cast(void*)inst_data;
    b3BodyId body = b3CreateBody(state.physics.world, &body_def);

    b3ShapeDef shape_def = b3DefaultShapeDef();
    shape_def.density = 1.0f;
    shape_def.baseMaterial.restitution = 0.25f;
    if (physicsIsBox(idx))
    {
        b3BoxHull hull = b3MakeCubeHull(box_size * 0.5f);
        b3CreateHullShape(body, &shape_def, &hull.base);
    }
    else
    {
        shape_def.baseMaterial.rollingResistance = 0.05f;
        b3Sphere sphere = {radius: ball_radius};
        b3CreateSphereShape(body, &shape_def, &sphere);
    }
    state.physics.bodies[idx] = body;
    const m.Vec3 c = randUvec3();
    inst_data.color = m.Vec4(c.x, c.y, c.z, 1.0f);
    const b3WorldTransform tf = b3Body_GetTransform(body);
    copyInstanceTransform(inst_data, &tf);

    // apply linear and angular impulse to get a fountain effect
    const m.Vec3 v = randIvec3();
    const m.Vec3 li = m.Vec3.mul(m.Vec3.norm(m.Vec3(v.x, v.y + 10.0f, v.z)), 75.0f);
    b3Body_ApplyLinearImpulseToCenter(body, b3Vec3(li.x, li.y, li.z), true);
    const m.Vec3 av = randIvec3();
    const m.Vec3 ai = m.Vec3.mul(av, 5.0f);
    b3Body_ApplyAngularImpulse(body, b3Vec3(ai.x, ai.y, ai.z), true);

    state.physics.num_bodies += 1;
}

void physicsCleanup() @trusted nothrow
{
    b3DestroyWorld(state.physics.world);
}

void gfxInit() @trusted nothrow
{
    // fixed light position in world space
    state.light_pos = m.Vec3(50.0f, 100.0f, -75.0f);

    // display pass clear color (blue-ish)
    sg.PassAction pass_action = {
        colors: [
            {
                load_action: sg.LoadAction.Clear,
                clear_value: {r: 0.2f, g: 0.4f, b: 0.8f, a: 1.0f}
            }
        ]
    };
    state.display.pass_action = pass_action;

    // plane, box and sphere shapes
    ubyte[sshape.max_vertex_size * 4096] vertices;
    ushort[4096] indices;
    sshape.State shp = {
        disable: {texcoords: true, colors: true},
        vertices: {buffer: {ptr: vertices.ptr, size: vertices.sizeof}},
        indices: {buffer: {ptr: indices.ptr, size: indices.sizeof}},
    };
    sshape.buildPlane(shp, sshape.Plane(width: ground_size, depth: ground_size));
    state.shapes.plane = sshape.elementRange(shp);
    sshape.buildSphere(shp, sshape.Sphere(radius: ball_radius, slices: 15, stacks: 11));
    state.shapes.ball = sshape.elementRange(shp);
    sshape.buildBox(shp, sshape.Box(width: box_size, height: box_size, depth: box_size));
    state.shapes.box = sshape.elementRange(shp);

    // shape vertex and index buffer
    sg.BufferDesc vbuf_desc = sshape.vertexBufferDesc(shp);
    sg.BufferDesc ibuf_desc = sshape.indexBufferDesc(shp);
    state.vbuf = sg.makeBuffer(vbuf_desc);
    state.ibuf = sg.makeBuffer(ibuf_desc);

    // pipeline objects for regular and instanced rendering
    sg.PipelineDesc pip_desc = {
        shader: sg.makeShader(shd.displayShaderDesc(sg.queryBackend())),
        layout: {
            buffers: [0: sshape.vertexBufferLayoutState(shp)],
            attrs: [
                shd.ATTR_DISPLAY_POS: sshape.positionVertexAttrState(shp),
                shd.ATTR_DISPLAY_NORMAL: sshape.normalVertexAttrState(shp)
            ]
        },
        depth: {write_enabled: true, compare: sg.CompareFunc.Less_equal},
        index_type: sg.IndexType.Uint16,
        cull_mode: sg.CullMode.Back,
        label: "display-pipeline"
    };
    state.display.pip = sg.makePipeline(pip_desc);

    sg.PipelineDesc inst_pip_desc = {
        shader: sg.makeShader(shd.display_instancedShaderDesc(sg.queryBackend())),
        layout: {
            buffers: [
                0: sshape.vertexBufferLayoutState(shp),
                1: {step_func: sg.VertexStep.Per_instance, stride: InstData.sizeof}
            ],
            attrs: [
                // NOTE: sshape helper functions return explicit offsets, so the
                // instance attribute offsets must also be explicitly provided
                shd.ATTR_DISPLAY_INSTANCED_POS: sshape.positionVertexAttrState(shp),
                shd.ATTR_DISPLAY_INSTANCED_NORMAL: sshape.normalVertexAttrState(shp),
                shd.ATTR_DISPLAY_INSTANCED_INST_XXXX: {format: sg.VertexFormat.Float4, buffer_index: 1, offset: 0},
                shd.ATTR_DISPLAY_INSTANCED_INST_YYYY: {format: sg.VertexFormat.Float4, buffer_index: 1, offset: 16},
                shd.ATTR_DISPLAY_INSTANCED_INST_ZZZZ: {format: sg.VertexFormat.Float4, buffer_index: 1, offset: 32},
                shd.ATTR_DISPLAY_INSTANCED_INST_COLOR: {format: sg.VertexFormat.Float4, buffer_index: 1, offset: 48}
            ]
        },
        depth: {write_enabled: true, compare: sg.CompareFunc.Less_equal},
        index_type: sg.IndexType.Uint16,
        cull_mode: sg.CullMode.Back,
        label: "display-instanced-pipeline"
    };
    state.display.inst_pip = sg.makePipeline(inst_pip_desc);

    // shadow pass resources
    sg.ImageDesc shadow_map_desc = {
        usage: {depth_stencil_attachment: true},
        width: shadow_map_size,
        height: shadow_map_size,
        pixel_format: sg.PixelFormat.Depth,
        sample_count: 1,
        label: "shadow-map-image"
    };
    const sg.Image shadow_map_img = sg.makeImage(shadow_map_desc);
    sg.ViewDesc tex_view_desc = {
        texture: {image: shadow_map_img},
        label: "shadow-map-texview"
    };
    state.shadow.tex_view = sg.makeView(tex_view_desc);
    sg.ViewDesc ds_view_desc = {
        depth_stencil_attachment: {image: shadow_map_img},
        label: "shadow-map-dsview"
    };
    sg.Pass shadow_pass = {
        action: {depth: {load_action: sg.LoadAction.Clear, store_action: sg.StoreAction.Store, clear_value: 1.0f}},
        attachments: {depth_stencil: sg.makeView(ds_view_desc)},
        label: "shadow-pass"
    };
    state.shadow.pass = shadow_pass;
    sg.SamplerDesc smp_desc = {
        min_filter: sg.Filter.Linear,
        mag_filter: sg.Filter.Linear,
        wrap_u: sg.Wrap.Clamp_to_edge,
        wrap_v: sg.Wrap.Clamp_to_edge,
        compare: sg.CompareFunc.Less,
        label: "shadow-map-sampler"
    };
    state.shadow.smp = sg.makeSampler(smp_desc);
    sg.PipelineDesc shadow_inst_pip_desc = {
        shader: sg.makeShader(shd.shadow_instancedShaderDesc(sg.queryBackend())),
        layout: {
            buffers: [
                0: sshape.vertexBufferLayoutState(shp),
                1: {step_func: sg.VertexStep.Per_instance, stride: InstData.sizeof}
            ],
            attrs: [
                shd.ATTR_SHADOW_INSTANCED_POS: sshape.positionVertexAttrState(shp),
                shd.ATTR_SHADOW_INSTANCED_INST_XXXX: {format: sg.VertexFormat.Float4, buffer_index: 1, offset: 0},
                shd.ATTR_SHADOW_INSTANCED_INST_YYYY: {format: sg.VertexFormat.Float4, buffer_index: 1, offset: 16},
                shd.ATTR_SHADOW_INSTANCED_INST_ZZZZ: {format: sg.VertexFormat.Float4, buffer_index: 1, offset: 32}
            ]
        },
        depth: {pixel_format: sg.PixelFormat.Depth, compare: sg.CompareFunc.Less_equal, write_enabled: true},
        index_type: sg.IndexType.Uint16,
        cull_mode: sg.CullMode.Front,
        sample_count: 1,
        colors: [0: {pixel_format: sg.PixelFormat.None}],
        label: "shadow-instanced-pipeline"
    };
    state.shadow.inst_pip = sg.makePipeline(shadow_inst_pip_desc);

    // instance buffers for box and sphere instances
    sg.BufferDesc box_inst_buf_desc = {
        usage: {stream_update: true},
        size: max_instances * InstData.sizeof,
        label: "box-instance-buffer"
    };
    state.box_inst_buf = sg.makeBuffer(box_inst_buf_desc);
    sg.BufferDesc ball_inst_buf_desc = {
        usage: {stream_update: true},
        size: max_instances * InstData.sizeof,
        label: "ball-instance-buffer"
    };
    state.ball_inst_buf = sg.makeBuffer(ball_inst_buf_desc);
}

void uiDraw() @trusted
{
    sappimgui.trackFrame;
    simgui.FrameDesc imgui_desc = {
        width: sapp.width(),
        height: sapp.height(),
        delta_time: sapp.frameDuration(),
        dpi_scale: sapp.dpiScale(),
    };
    simgui.newFrame(imgui_desc);
    if (BeginMainMenuBar())
    {
        sgimgui.drawMenu("sokol-gfx");
        sappimgui.drawMenu("sokol-app");
        EndMainMenuBar();
    }
    sappimgui.draw;
    sgimgui.draw;
    SetNextWindowPos(ImVec2(30, 50), ImGuiCond_.ImGuiCond_Once);
    SetNextWindowBgAlpha(0.5f);
    if (Begin("Status", null,
        cast(ImGuiWindowFlags)(ImGuiWindowFlags_.ImGuiWindowFlags_NoDecoration |
            ImGuiWindowFlags_.ImGuiWindowFlags_AlwaysAutoResize)))
    {
        Checkbox("Show sleeping", &state.ui.show_sleeping);
        Text("Total bodies: %d", state.physics.num_bodies);
        Text("Awake bodies: %d", state.profiling.num_awake_bodies);
        Text("Sub-steps per frame: %d", state.profiling.sub_steps_per_frame);
        Text("World Step Time: %.3fms", stm.ms(state.profiling.physics_world_step_time));
        Text("Copy Transforms Time: %.3fms", stm.ms(state.profiling.copy_transforms_time));
    }
    End();
}

void main() @safe nothrow
{
    // dfmt off
    sapp.Desc runner = {
        init_cb: &init,
        frame_cb: &frame,
        cleanup_cb: &cleanup,
        event_cb: &input,
        width: 800,
        height: 600,
        sample_count: 4,
        window_title: "box3d.d",
        icon: {sokol_default: true},
        logger: {func: &slog.func}
    };
    // dfmt on
    sapp.run(runner);
}

version (WebAssembly)
{
    debug
    {
        import emscripten.assertd;
    }
}
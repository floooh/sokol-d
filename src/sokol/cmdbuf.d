/++
+ Machine generated D bindings for Sokol library.
+ 
+     Source header: sokol_cmdbuf.h
+     Module: sokol.cmdbuf
+ 
+     Do not edit manually; regenerate using gen_d.py.
+/
module sokol.cmdbuf;
import sg = sokol.gfx;

/++
+ public constants
+/
enum invalid_id = 0;
/++
+ scb_cmdbuf
+ 
+     A command buffer handle created with scb_make_cmdbuf().
+/
extern(C) struct Cmdbuf {
    uint id = 0;
}
/++
+ scb_resource_state
+ 
+     The state of a command buffer object, obtainable via scb_query_cmdbuf_state().
+     Publicly visible values are only SCB_RESOURCESTATE_VALID,
+     SCB_RESOURCESTATE_FAILED and SCB_RESOURCESTATE_INVALID.
+/
enum ResourceState {
    Initial,
    Alloc,
    Valid,
    Failed,
    Invalid,
}
/++
+ scb_cmdbuf_desc
+ 
+     Creation parameters of a command buffer object. Used
+     in scb_make_cmdbuf().
+ 
+     See doc section ESTIMATING COMMAND BUFFER SIZES about
+     how command buffer size can be estimated.
+ 
+     When a label is set, sokol_cmdbuf.h will wrap
+     submitted commands with `sg_push/pop_debug_group()`.
+/
extern(C) struct CmdbufDesc {
    size_t size = 0;
    const(char)* label = null;
}
/++
+ scb_cmdbuf_info
+ 
+     Result of scb_query_cmdbuf_info.
+/
extern(C) struct CmdbufInfo {
    size_t size = 0;
    size_t remaining = 0;
    bool overflown = false;
}
enum LogItem {
    Ok,
    Malloc_failed,
    Cmdbuf_pool_exhausted,
    Cmdbuf_overflow,
    Cmdbuf_not_valid,
    Submit_cmdbuf_overflown,
    Submit_invalid_command,
}
/++
+ scb_logger
+ 
+     Used in scb_desc to provide a custom logging and error reporting
+     callback to sokol_cmdbuf.h
+/
extern(C) struct Logger {
    extern(C) void function(const(char)*, uint, uint, const(char)*, uint, const(char)*, void*) func = null;
    void* user_data = null;
}
/++
+ scb_allocator
+ 
+     Used in scb_desc to provide custom memory-alloc and -free functions
+     to sokol_cmdbuf.h. If memory management should be overridden, both the
+     alloc_fn and free_fn function must be provided (e.g. it's not valid to
+     override one function but not the other).
+/
extern(C) struct Allocator {
    extern(C) void* function(size_t, void*) alloc_fn = null;
    extern(C) void function(void*, void*) free_fn = null;
    void* user_data = null;
}
/++
+ scb_desc
+ 
+     Initialization options passed into scb_setup.
+/
extern(C) struct Desc {
    int cmdbuf_pool_size = 0;
    Allocator allocator = {};
    Logger logger = {};
}
/++
+ setup sokol-cmdbuf
+/
extern(C) void scb_setup(const Desc* desc) @system @nogc nothrow pure;
void setup(scope ref Desc desc) @trusted @nogc nothrow pure {
    scb_setup(&desc);
}
/++
+ shutdown sokol-cmdbuf
+/
extern(C) void scb_shutdown() @system @nogc nothrow pure;
void shutdown() @trusted @nogc nothrow pure {
    scb_shutdown();
}
/++
+ create a cmdbuf object
+/
extern(C) Cmdbuf scb_make_cmdbuf(const CmdbufDesc* desc) @system @nogc nothrow pure;
Cmdbuf makeCmdbuf(scope ref CmdbufDesc desc) @trusted @nogc nothrow pure {
    return scb_make_cmdbuf(&desc);
}
/++
+ destroy cmdbuf object
+/
extern(C) void scb_destroy_cmdbuf(Cmdbuf cb) @system @nogc nothrow pure;
void destroyCmdbuf(Cmdbuf cb) @trusted @nogc nothrow pure {
    scb_destroy_cmdbuf(cb);
}
/++
+ submit command buffer to sokol-gfx and rewind the command buffer (call inside a sokol-gfx pass)
+/
extern(C) void scb_submit(Cmdbuf cb) @system @nogc nothrow pure;
void submit(Cmdbuf cb) @trusted @nogc nothrow pure {
    scb_submit(cb);
}
/++
+ reset a recorded command buffer, discarding its content
+/
extern(C) void scb_reset(Cmdbuf cb) @system @nogc nothrow pure;
void reset(Cmdbuf cb) @trusted @nogc nothrow pure {
    scb_reset(cb);
}
/++
+ record apply-viewport command (integer variant)
+/
extern(C) void scb_apply_viewport(Cmdbuf cb, int x, int y, int width, int height, bool origin_top_left) @system @nogc nothrow pure;
void applyViewport(Cmdbuf cb, int x, int y, int width, int height, bool origin_top_left) @trusted @nogc nothrow pure {
    scb_apply_viewport(cb, x, y, width, height, origin_top_left);
}
/++
+ record apply-viewport command (float variant)
+/
extern(C) void scb_apply_viewportf(Cmdbuf cb, float x, float y, float width, float height, bool origin_top_left) @system @nogc nothrow pure;
void applyViewportf(Cmdbuf cb, float x, float y, float width, float height, bool origin_top_left) @trusted @nogc nothrow pure {
    scb_apply_viewportf(cb, x, y, width, height, origin_top_left);
}
/++
+ record apply-scissor-rect command (integer variant)
+/
extern(C) void scb_apply_scissor_rect(Cmdbuf cb, int x, int y, int width, int height, bool origin_top_left) @system @nogc nothrow pure;
void applyScissorRect(Cmdbuf cb, int x, int y, int width, int height, bool origin_top_left) @trusted @nogc nothrow pure {
    scb_apply_scissor_rect(cb, x, y, width, height, origin_top_left);
}
/++
+ record apply-scissor-rect command (float variant)
+/
extern(C) void scb_apply_scissor_rectf(Cmdbuf cb, float x, float y, float width, float height, bool origin_top_left) @system @nogc nothrow pure;
void applyScissorRectf(Cmdbuf cb, float x, float y, float width, float height, bool origin_top_left) @trusted @nogc nothrow pure {
    scb_apply_scissor_rectf(cb, x, y, width, height, origin_top_left);
}
/++
+ record apply pipeline command
+/
extern(C) void scb_apply_pipeline(Cmdbuf cb, sg.Pipeline pip) @system @nogc nothrow pure;
void applyPipeline(Cmdbuf cb, sg.Pipeline pip) @trusted @nogc nothrow pure {
    scb_apply_pipeline(cb, pip);
}
/++
+ record apply bindings command
+/
extern(C) void scb_apply_bindings(Cmdbuf cb, const sg.Bindings* bindings) @system @nogc nothrow pure;
void applyBindings(Cmdbuf cb, scope ref sg.Bindings bindings) @trusted @nogc nothrow pure {
    scb_apply_bindings(cb, &bindings);
}
/++
+ record apply uniforms command
+/
extern(C) void scb_apply_uniforms(Cmdbuf cb, int ub_slot, const sg.Range* data) @system @nogc nothrow pure;
void applyUniforms(Cmdbuf cb, int ub_slot, scope ref sg.Range data) @trusted @nogc nothrow pure {
    scb_apply_uniforms(cb, ub_slot, &data);
}
/++
+ record draw command
+/
extern(C) void scb_draw(Cmdbuf cb, int base_element, int num_elements, int num_instances) @system @nogc nothrow pure;
void draw(Cmdbuf cb, int base_element, int num_elements, int num_instances) @trusted @nogc nothrow pure {
    scb_draw(cb, base_element, num_elements, num_instances);
}
/++
+ record draw-ex command
+/
extern(C) void scb_draw_ex(Cmdbuf cb, int base_element, int num_elements, int num_instances, int base_vertex, int base_instance) @system @nogc nothrow pure;
void drawEx(Cmdbuf cb, int base_element, int num_elements, int num_instances, int base_vertex, int base_instance) @trusted @nogc nothrow pure {
    scb_draw_ex(cb, base_element, num_elements, num_instances, base_vertex, base_instance);
}
/++
+ record dispatch command
+/
extern(C) void scb_dispatch(Cmdbuf cb, int num_groups_x, int num_groups_y, int num_groups_z) @system @nogc nothrow pure;
void dispatch(Cmdbuf cb, int num_groups_x, int num_groups_y, int num_groups_z) @trusted @nogc nothrow pure {
    scb_dispatch(cb, num_groups_x, num_groups_y, num_groups_z);
}
/++
+ query command buffer resource state (valid, failed, invalid)
+/
extern(C) ResourceState scb_query_cmdbuf_state(Cmdbuf cb) @system @nogc nothrow pure;
ResourceState queryCmdbufState(Cmdbuf cb) @trusted @nogc nothrow pure {
    return scb_query_cmdbuf_state(cb);
}
/++
+ query current command buffer properties
+/
extern(C) CmdbufInfo scb_query_cmdbuf_info(Cmdbuf cb) @system @nogc nothrow pure;
CmdbufInfo queryCmdbufInfo(Cmdbuf cb) @trusted @nogc nothrow pure {
    return scb_query_cmdbuf_info(cb);
}

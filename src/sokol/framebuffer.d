/++
+ Machine generated D bindings for Sokol library.
+ 
+     Source header: sokol_framebuffer.h
+     Module: sokol.framebuffer
+ 
+     Do not edit manually; regenerate using gen_d.py.
+/
module sokol.framebuffer;
import sg = sokol.gfx;

/++
+ Public constants.
+/
enum invalid_id = 0;
/++
+ sfb_framebuffer
+ 
+     A framebuffer handle, created with sfb_make_framebuffer(), destroyed
+     with sfb_destroy_framebuffer()
+/
extern(C) struct Framebuffer {
    uint id = 0;
}
/++
+ sfb_resource_state
+ 
+     The state of a framebuffer object, obtainable via sfg_query_framebuffer_state().
+     Publicly visible values are only SFB_RESOURCESTATE_VALID
+     and SFB_RESOURCESTATE_FAILED.
+/
enum ResourceState {
    Initial,
    Alloc,
    Valid,
    Failed,
    Invalid,
}
/++
+ sfb_format
+ 
+     The framebuffer pixel format. Either RGBA8 direct color where each
+     pixel is an uint32_t, or paletted format with uint8_t pixels as
+     index into a 256 entry color palette.
+/
enum Format {
    Default = 0,
    Rgba8,
    Palette8,
}
/++
+ sfb_rect
+ 
+     Used as clipping rectangle in struct sfb_framebuffer_desc
+     and sfb_resize_desc.
+/
extern(C) struct Rect {
    int x = 0;
    int y = 0;
    int width = 0;
    int height = 0;
}
/++
+ sfb_render_pass_desc
+ 
+     Describes render pass properties in an sfb_framebuffer_desc (color-
+     and depth-pixel-format, sample count). This is used to create the
+     sg_pipeline objects applied in the render functions. When rendering
+     to a default swapchain all the values can remain at default (zero).
+/
extern(C) struct RenderPassDesc {
    sg.PixelFormat color_format = sg.PixelFormat.Default;
    sg.PixelFormat depth_format = sg.PixelFormat.Default;
    int sample_count = 0;
}
/++
+ sfb_framebuffer_desc
+ 
+     Creation parameters for a framebuffer object. Passed into
+     sfb_make_framebuffer().
+/
extern(C) struct FramebufferDesc {
    int width = 0;
    int height = 0;
    int prescale = 0;
    Format format = Format.Default;
    Rect cliprect = {};
    bool rotate90 = false;
    RenderPassDesc render_pass = {};
}
/++
+ sfb_resize_desc
+ 
+     Parameters for sfb_resize(). Needs to be called before sfb_update() in a
+     frame if with potentially new framebuffer size parameters or clipping
+     rectangle. Note that the sfb_resize() function can be called even when no
+     resizing needs to happen, in that case the function will be a silent no-op
+     and return false. When the function returns true this means that internal
+     image objects had been recreated and need to be repopulated again via
+     sfb_update()
+ 
+     Resizing is slightly cheaper than destroying and creating the frambuffer
+     because only image objects needs to be re-created, but no pipeline objects.
+/
extern(C) struct ResizeDesc {
    int width = 0;
    int height = 0;
    int prescale = 0;
    Rect cliprect = {};
}
/++
+ sfb_update_desc
+ 
+     Passed into sfb_update() to update the pixel-date and/or color-palette-data
+     The sfb_update() function should only be called when any of the above
+     actually changes, at most once per frame, and outside any sokol-gfx pass.
+/
extern(C) struct UpdateDesc {
    sg.Range pixels = {};
    sg.Range palette = {};
}
/++
+ sfb_render_overrides
+ 
+     Passed into sfb_render_ex() to override the default shader. Mainly
+     useful to inject custom shaders (like CRT shaders).
+ 
+     TODO: add more details once sokol_crt.h is ready.
+/
extern(C) struct RenderDesc {
    bool use_nearest_filter = false;
    sg.Pipeline pip = {};
    sg.View[32] views = [];
    sg.Sampler[12] samplers = [];
    sg.Range[8] uniforms = [];
}
/++
+ sfb_texture_info
+ 
+     Nested struct in sfb_framebuffer_info to describe the properties of
+     an internal image/view pair.
+/
extern(C) struct TextureInfo {
    int width = 0;
    int height = 0;
    sg.PixelFormat pixel_format = sg.PixelFormat.Default;
    sg.Image image = {};
    sg.View tex_view = {};
}
/++
+ sfb_framebuffer_info
+ 
+     Result of sfb_query_framebuffer_info(), returns handles to the internally
+     managed images, texture views and samplers, image sizes and pixel formats.
+     This is mostly useful when completely replacing the sfb_render[_ex]()
+     functions with a complete custom implementation (like a CRT shader which
+     requires multiple render passes).
+/
extern(C) struct FramebufferInfo {
    TextureInfo update = {};
    TextureInfo offscreen = {};
    TextureInfo palette = {};
    sg.Sampler nearest_sampler = {};
    sg.Sampler linear_sampler = {};
}
/++
+ sfb_allocator
+ 
+     Used in sfb_desc to provide custom memory-alloc and -free functions
+     to sokol_framebuffer.h. If memory management should be overridden, both the
+     alloc and free function must be provided (e.g. it's not valid to
+     override one function but not the other).
+/
extern(C) struct Allocator {
    extern(C) void* function(size_t, void*) alloc_fn = null;
    extern(C) void function(void*, void*) free_fn = null;
    void* user_data = null;
}
/++
+ sfb_logger
+ 
+     Used in sfb_desc to provide a custom logging and error reporting
+     callback to sokol_framebuffer.h.
+/
extern(C) struct Logger {
    extern(C) void function(const(char)*, uint, uint, const(char)*, uint, const(char)*, void*) func = null;
    void* user_data = null;
}
/++
+ Initialization parameters passed into sfb_setup(). You should at least
+     provide a logging function, otherwise you won't see any error logging.
+/
extern(C) struct Desc {
    int framebuffer_pool_size = 0;
    Allocator allocator = {};
    Logger logger = {};
}
/++
+ setup sokol-framebuffer
+/
extern(C) void sfb_setup(const Desc* desc) @system @nogc nothrow pure;
void setup(scope ref Desc desc) @trusted @nogc nothrow pure {
    sfb_setup(&desc);
}
/++
+ shutdown sokol-framebuffer
+/
extern(C) void sfb_shutdown() @system @nogc nothrow pure;
void shutdown() @trusted @nogc nothrow pure {
    sfb_shutdown();
}
/++
+ create a framebuffer object
+/
extern(C) Framebuffer sfb_make_framebuffer(const FramebufferDesc* desc) @system @nogc nothrow pure;
Framebuffer makeFramebuffer(scope ref FramebufferDesc desc) @trusted @nogc nothrow pure {
    return sfb_make_framebuffer(&desc);
}
/++
+ destroy framebuffer object
+/
extern(C) void sfb_destroy_framebuffer(Framebuffer fb) @system @nogc nothrow pure;
void destroyFramebuffer(Framebuffer fb) @trusted @nogc nothrow pure {
    sfb_destroy_framebuffer(fb);
}
/++
+ resize internal images (no-op if resize isn't needed), return true when images had to be re-created
+/
extern(C) bool sfb_resize(Framebuffer fb, const ResizeDesc* desc) @system @nogc nothrow pure;
bool resize(Framebuffer fb, scope ref ResizeDesc desc) @trusted @nogc nothrow pure {
    return sfb_resize(fb, &desc);
}
/++
+ update framebuffer and/or color palette content (must be called outside any sokol-gfx pass)
+/
extern(C) void sfb_update(Framebuffer fb, const UpdateDesc* desc) @system @nogc nothrow pure;
void update(Framebuffer fb, scope ref UpdateDesc desc) @trusted @nogc nothrow pure {
    sfb_update(fb, &desc);
}
/++
+ draw framebuffer content with default shader (must be called inside a sokol-gfx render pass)
+/
extern(C) void sfb_render(Framebuffer fb) @system @nogc nothrow pure;
void render(Framebuffer fb) @trusted @nogc nothrow pure {
    sfb_render(fb);
}
/++
+ draw framebuffer content with injected shader (must be called inside a sokol-gfx render pass)
+/
extern(C) void sfb_render_ex(Framebuffer fb, const RenderDesc* desc) @system @nogc nothrow pure;
void renderEx(Framebuffer fb, scope ref RenderDesc desc) @trusted @nogc nothrow pure {
    sfb_render_ex(fb, &desc);
}
/++
+ query framebuffer resource state (valid or failed)
+/
extern(C) ResourceState sfb_query_framebuffer_state(Framebuffer fb) @system @nogc nothrow pure;
ResourceState queryFramebufferState(Framebuffer fb) @trusted @nogc nothrow pure {
    return sfb_query_framebuffer_state(fb);
}
/++
+ query current framebuffer properties
+/
extern(C) FramebufferInfo sfb_query_framebuffer_info(Framebuffer fb) @system @nogc nothrow pure;
FramebufferInfo queryFramebufferInfo(Framebuffer fb) @trusted @nogc nothrow pure {
    return sfb_query_framebuffer_info(fb);
}
/++
+ query the framebuffer desc, with default values patched in
+/
extern(C) FramebufferDesc sfb_query_framebuffer_desc(Framebuffer fb) @system @nogc nothrow pure;
FramebufferDesc queryFramebufferDesc(Framebuffer fb) @trusted @nogc nothrow pure {
    return sfb_query_framebuffer_desc(fb);
}

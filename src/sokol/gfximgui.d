/++
+ Machine generated D bindings for Sokol library.
+ 
+     Source header: sokol_gfx_imgui.h
+     Module: sokol.gfximgui
+ 
+     Do not edit manually; regenerate using gen_d.py.
+/
module sokol.gfximgui;
import sg = sokol.gfx;
import sapp = sokol.app;

/++
+ sgimgui_allocator_t
+ 
+     Used in sgimgui_desc_t to provide custom memory-alloc and -free functions
+     to sokol_gfx_imgui.h. If memory management should be overridden, both the
+     alloc and free function must be provided (e.g. it's not valid to
+     override one function but not the other).
+/
extern(C) struct Allocator {
    extern(C) void* function(size_t, void*) alloc_fn = null;
    extern(C) void function(void*, void*) free_fn = null;
    void* user_data = null;
}
/++
+ sgimgui_desc_t
+ 
+     Initialization options for sgimgui_init().
+/
extern(C) struct Desc {
    Allocator allocator = {};
}
extern(C) void sgimgui_setup(const Desc* desc) @system @nogc nothrow pure;
void setup(scope ref Desc desc) @trusted @nogc nothrow pure {
    sgimgui_setup(&desc);
}
extern(C) void sgimgui_shutdown() @system @nogc nothrow pure;
void shutdown() @trusted @nogc nothrow pure {
    sgimgui_shutdown();
}
extern(C) void sgimgui_draw() @system @nogc nothrow pure;
void draw() @trusted @nogc nothrow pure {
    sgimgui_draw();
}
extern(C) void sgimgui_draw_menu(const(char)* title) @system @nogc nothrow pure;
void drawMenu(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_menu(title);
}
extern(C) void sgimgui_draw_buffer_window_content() @system @nogc nothrow pure;
void drawBufferWindowContent() @trusted @nogc nothrow pure {
    sgimgui_draw_buffer_window_content();
}
extern(C) void sgimgui_draw_image_window_content() @system @nogc nothrow pure;
void drawImageWindowContent() @trusted @nogc nothrow pure {
    sgimgui_draw_image_window_content();
}
extern(C) void sgimgui_draw_sampler_window_content() @system @nogc nothrow pure;
void drawSamplerWindowContent() @trusted @nogc nothrow pure {
    sgimgui_draw_sampler_window_content();
}
extern(C) void sgimgui_draw_shader_window_content() @system @nogc nothrow pure;
void drawShaderWindowContent() @trusted @nogc nothrow pure {
    sgimgui_draw_shader_window_content();
}
extern(C) void sgimgui_draw_pipeline_window_content() @system @nogc nothrow pure;
void drawPipelineWindowContent() @trusted @nogc nothrow pure {
    sgimgui_draw_pipeline_window_content();
}
extern(C) void sgimgui_draw_view_window_content() @system @nogc nothrow pure;
void drawViewWindowContent() @trusted @nogc nothrow pure {
    sgimgui_draw_view_window_content();
}
extern(C) void sgimgui_draw_capture_window_content() @system @nogc nothrow pure;
void drawCaptureWindowContent() @trusted @nogc nothrow pure {
    sgimgui_draw_capture_window_content();
}
extern(C) void sgimgui_draw_capabilities_window_content() @system @nogc nothrow pure;
void drawCapabilitiesWindowContent() @trusted @nogc nothrow pure {
    sgimgui_draw_capabilities_window_content();
}
extern(C) void sgimgui_draw_frame_stats_window_content() @system @nogc nothrow pure;
void drawFrameStatsWindowContent() @trusted @nogc nothrow pure {
    sgimgui_draw_frame_stats_window_content();
}
extern(C) void sgimgui_draw_buffer_window(const(char)* title) @system @nogc nothrow pure;
void drawBufferWindow(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_buffer_window(title);
}
extern(C) void sgimgui_draw_image_window(const(char)* title) @system @nogc nothrow pure;
void drawImageWindow(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_image_window(title);
}
extern(C) void sgimgui_draw_sampler_window(const(char)* title) @system @nogc nothrow pure;
void drawSamplerWindow(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_sampler_window(title);
}
extern(C) void sgimgui_draw_shader_window(const(char)* title) @system @nogc nothrow pure;
void drawShaderWindow(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_shader_window(title);
}
extern(C) void sgimgui_draw_pipeline_window(const(char)* title) @system @nogc nothrow pure;
void drawPipelineWindow(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_pipeline_window(title);
}
extern(C) void sgimgui_draw_view_window(const(char)* title) @system @nogc nothrow pure;
void drawViewWindow(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_view_window(title);
}
extern(C) void sgimgui_draw_capture_window(const(char)* title) @system @nogc nothrow pure;
void drawCaptureWindow(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_capture_window(title);
}
extern(C) void sgimgui_draw_capabilities_window(const(char)* title) @system @nogc nothrow pure;
void drawCapabilitiesWindow(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_capabilities_window(title);
}
extern(C) void sgimgui_draw_frame_stats_window(const(char)* title) @system @nogc nothrow pure;
void drawFrameStatsWindow(const(char)* title) @trusted @nogc nothrow pure {
    sgimgui_draw_frame_stats_window(title);
}
extern(C) void sgimgui_draw_buffer_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawBufferMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sgimgui_draw_buffer_menu_item(label);
}
extern(C) void sgimgui_draw_image_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawImageMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sgimgui_draw_image_menu_item(label);
}
extern(C) void sgimgui_draw_sampler_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawSamplerMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sgimgui_draw_sampler_menu_item(label);
}
extern(C) void sgimgui_draw_shader_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawShaderMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sgimgui_draw_shader_menu_item(label);
}
extern(C) void sgimgui_draw_pipeline_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawPipelineMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sgimgui_draw_pipeline_menu_item(label);
}
extern(C) void sgimgui_draw_view_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawViewMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sgimgui_draw_view_menu_item(label);
}
extern(C) void sgimgui_draw_capture_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawCaptureMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sgimgui_draw_capture_menu_item(label);
}
extern(C) void sgimgui_draw_capabilities_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawCapabilitiesMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sgimgui_draw_capabilities_menu_item(label);
}
extern(C) void sgimgui_draw_frame_stats_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawFrameStatsMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sgimgui_draw_frame_stats_menu_item(label);
}

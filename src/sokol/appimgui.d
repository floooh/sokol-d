/++
+ Machine generated D bindings for Sokol library.
+ 
+     Source header: sokol_app_imgui.h
+     Module: sokol.appimgui
+ 
+     Do not edit manually; regenerate using gen_d.py.
+/
module sokol.appimgui;
import sapp = sokol.app;

extern(C) void sappimgui_setup() @system @nogc nothrow pure;
void setup() @trusted @nogc nothrow pure {
    sappimgui_setup();
}
extern(C) void sappimgui_shutdown() @system @nogc nothrow pure;
void shutdown() @trusted @nogc nothrow pure {
    sappimgui_shutdown();
}
extern(C) void sappimgui_track_frame() @system @nogc nothrow pure;
void trackFrame() @trusted @nogc nothrow pure {
    sappimgui_track_frame();
}
extern(C) void sappimgui_track_event(const sapp.Event* ev) @system @nogc nothrow pure;
void trackEvent(scope ref sapp.Event ev) @trusted @nogc nothrow pure {
    sappimgui_track_event(&ev);
}
extern(C) void sappimgui_draw() @system @nogc nothrow pure;
void draw() @trusted @nogc nothrow pure {
    sappimgui_draw();
}
extern(C) void sappimgui_draw_menu(const(char)* title) @system @nogc nothrow pure;
void drawMenu(const(char)* title) @trusted @nogc nothrow pure {
    sappimgui_draw_menu(title);
}
extern(C) void sappimgui_draw_hud_window_content() @system @nogc nothrow pure;
void drawHudWindowContent() @trusted @nogc nothrow pure {
    sappimgui_draw_hud_window_content();
}
extern(C) void sappimgui_draw_publicstate_window_content() @system @nogc nothrow pure;
void drawPublicstateWindowContent() @trusted @nogc nothrow pure {
    sappimgui_draw_publicstate_window_content();
}
extern(C) void sappimgui_draw_event_window_content() @system @nogc nothrow pure;
void drawEventWindowContent() @trusted @nogc nothrow pure {
    sappimgui_draw_event_window_content();
}
extern(C) void sappimgui_draw_hud_window(const(char)* title) @system @nogc nothrow pure;
void drawHudWindow(const(char)* title) @trusted @nogc nothrow pure {
    sappimgui_draw_hud_window(title);
}
extern(C) void sappimgui_draw_publicstate_window(const(char)* title) @system @nogc nothrow pure;
void drawPublicstateWindow(const(char)* title) @trusted @nogc nothrow pure {
    sappimgui_draw_publicstate_window(title);
}
extern(C) void sappimgui_draw_event_window(const(char)* title) @system @nogc nothrow pure;
void drawEventWindow(const(char)* title) @trusted @nogc nothrow pure {
    sappimgui_draw_event_window(title);
}
extern(C) void sappimgui_draw_hud_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawHudMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sappimgui_draw_hud_menu_item(label);
}
extern(C) void sappimgui_draw_publicstate_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawPublicstateMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sappimgui_draw_publicstate_menu_item(label);
}
extern(C) void sappimgui_draw_event_menu_item(const(char)* label) @system @nogc nothrow pure;
void drawEventMenuItem(const(char)* label) @trusted @nogc nothrow pure {
    sappimgui_draw_event_menu_item(label);
}

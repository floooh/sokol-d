/++
+ Machine generated D bindings for Sokol library.
+ 
+     Source header: sokol_letterbox.h
+     Module: sokol.letterbox
+ 
+     Do not edit manually; regenerate using gen_d.py.
+/
module sokol.letterbox;

/++
+ Defines a 'safe border' in pixels. Used as nested struct
+     in slbx_letterbox_desc.
+/
extern(C) struct Border {
    int left = 0;
    int right = 0;
    int top = 0;
    int bottom = 0;
}
/++
+ Anchor the content to a side. The default is to center the content.
+     Used in slbx_letterbox_desc.
+/
enum Anchor {
    Center = 0,
    Top,
    Bottom,
    Left,
    Right,
}
/++
+ The content letterbox description. Used as input to the
+     slbx_letterbox() function.
+/
extern(C) struct LetterboxDesc {
    float content_aspect_ratio = 0.0f;
    Anchor anchor = Anchor.Center;
    Border border = {};
}
/++
+ The resulting viewport. Return value of slbx_letterbox()
+/
extern(C) struct Viewport {
    int x = 0;
    int y = 0;
    int width = 0;
    int height = 0;
}
/++
+ compute viewport for 'letterboxing' fixed-aspect content in a variable-aspect framebuffer
+/
extern(C) Viewport slbx_letterbox(int width, int height, const LetterboxDesc* desc) @system @nogc nothrow pure;
Viewport letterbox(int width, int height, scope ref LetterboxDesc desc) @trusted @nogc nothrow pure {
    return slbx_letterbox(width, height, &desc);
}

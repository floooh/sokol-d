// machine generated, do not edit

module sokol.shape;
import sg = sokol.gfx;

// helper function to convert a C string to a D string
string cStrToDString(const(char*) c_str)
{
    import std.conv : to;

    return c_str.to!string;
}
// helper function to convert "anything" to a Range struct

Range asRange(T)(T val)
{
    static if (isPointer!T)
    {
        return Range(val, __traits(classInstanceSize, T));
    }
    else static if (is(T == struct))
    {
        return Range(val.tupleof);
    }
    else
    {
        static assert(0, "Cannot convert to range");
    }
}

struct Range
{
    const(void)* ptr;
    size_t size;
}

struct Mat4
{
    float[4][4] m;
}

struct Vertex
{
    float x;
    float y;
    float z;
    uint normal;
    ushort u;
    ushort v;
    uint color;
}

struct ElementRange
{
    uint base_element;
    uint num_elements;
}

struct SizesItem
{
    uint num;
    uint size;
}

struct Sizes
{
    SizesItem vertices;
    SizesItem indices;
}

struct BufferItem
{
    Range buffer;
    size_t data_size;
    size_t shape_offset;
}

struct Buffer
{
    bool valid;
    BufferItem vertices;
    BufferItem indices;
}

struct Plane
{
    float width;
    float depth;
    ushort tiles;
    uint color;
    bool random_colors;
    bool merge;
    Mat4 transform;
}

struct Box
{
    float width;
    float height;
    float depth;
    ushort tiles;
    uint color;
    bool random_colors;
    bool merge;
    Mat4 transform;
}

struct Sphere
{
    float radius;
    ushort slices;
    ushort stacks;
    uint color;
    bool random_colors;
    bool merge;
    Mat4 transform;
}

struct Cylinder
{
    float radius;
    float height;
    ushort slices;
    ushort stacks;
    uint color;
    bool random_colors;
    bool merge;
    Mat4 transform;
}

struct Torus
{
    float radius;
    float ring_radius;
    ushort sides;
    ushort rings;
    uint color;
    bool random_colors;
    bool merge;
    Mat4 transform;
}

extern (C) Buffer sshape_build_plane(const Buffer*, const Plane*);
Buffer buildPlane(Buffer buf, Plane params)
{
    return sshape_build_plane(&buf, &params);
}

extern (C) Buffer sshape_build_box(const Buffer*, const Box*);
Buffer buildBox(Buffer buf, Box params)
{
    return sshape_build_box(&buf, &params);
}

extern (C) Buffer sshape_build_sphere(const Buffer*, const Sphere*);
Buffer buildSphere(Buffer buf, Sphere params)
{
    return sshape_build_sphere(&buf, &params);
}

extern (C) Buffer sshape_build_cylinder(const Buffer*, const Cylinder*);
Buffer buildCylinder(Buffer buf, Cylinder params)
{
    return sshape_build_cylinder(&buf, &params);
}

extern (C) Buffer sshape_build_torus(const Buffer*, const Torus*);
Buffer buildTorus(Buffer buf, Torus params)
{
    return sshape_build_torus(&buf, &params);
}

extern (C) Sizes sshape_plane_sizes(uint);
Sizes planeSizes(uint tiles)
{
    return sshape_plane_sizes(tiles);
}

extern (C) Sizes sshape_box_sizes(uint);
Sizes boxSizes(uint tiles)
{
    return sshape_box_sizes(tiles);
}

extern (C) Sizes sshape_sphere_sizes(uint, uint);
Sizes sphereSizes(uint slices, uint stacks)
{
    return sshape_sphere_sizes(slices, stacks);
}

extern (C) Sizes sshape_cylinder_sizes(uint, uint);
Sizes cylinderSizes(uint slices, uint stacks)
{
    return sshape_cylinder_sizes(slices, stacks);
}

extern (C) Sizes sshape_torus_sizes(uint, uint);
Sizes torusSizes(uint sides, uint rings)
{
    return sshape_torus_sizes(sides, rings);
}

extern (C) ElementRange sshape_element_range(const Buffer*);
ElementRange elementRange(Buffer buf)
{
    return sshape_element_range(&buf);
}

extern (C) sg.BufferDesc sshape_vertex_buffer_desc(const Buffer*);
sg.BufferDesc vertexBufferDesc(Buffer buf)
{
    return sshape_vertex_buffer_desc(&buf);
}

extern (C) sg.BufferDesc sshape_index_buffer_desc(const Buffer*);
sg.BufferDesc indexBufferDesc(Buffer buf)
{
    return sshape_index_buffer_desc(&buf);
}

extern (C) sg.VertexBufferLayoutState sshape_vertex_buffer_layout_state();
sg.VertexBufferLayoutState vertexBufferLayoutState()
{
    return sshape_vertex_buffer_layout_state();
}

extern (C) sg.VertexAttrState sshape_position_vertex_attr_state();
sg.VertexAttrState positionVertexAttrState()
{
    return sshape_position_vertex_attr_state();
}

extern (C) sg.VertexAttrState sshape_normal_vertex_attr_state();
sg.VertexAttrState normalVertexAttrState()
{
    return sshape_normal_vertex_attr_state();
}

extern (C) sg.VertexAttrState sshape_texcoord_vertex_attr_state();
sg.VertexAttrState texcoordVertexAttrState()
{
    return sshape_texcoord_vertex_attr_state();
}

extern (C) sg.VertexAttrState sshape_color_vertex_attr_state();
sg.VertexAttrState colorVertexAttrState()
{
    return sshape_color_vertex_attr_state();
}

extern (C) uint sshape_color_4f(float, float, float, float);
uint color4f(float r, float g, float b, float a)
{
    return sshape_color_4f(r, g, b, a);
}

extern (C) uint sshape_color_3f(float, float, float);
uint color3f(float r, float g, float b)
{
    return sshape_color_3f(r, g, b);
}

extern (C) uint sshape_color_4b(ubyte, ubyte, ubyte, ubyte);
uint color4b(ubyte r, ubyte g, ubyte b, ubyte a)
{
    return sshape_color_4b(r, g, b, a);
}

extern (C) uint sshape_color_3b(ubyte, ubyte, ubyte);
uint color3b(ubyte r, ubyte g, ubyte b)
{
    return sshape_color_3b(r, g, b);
}

extern (C) Mat4 sshape_mat4(const float*);
Mat4 mat4(const float* m)
{
    return sshape_mat4(m);
}

extern (C) Mat4 sshape_mat4_transpose(const float*);
Mat4 mat4Transpose(const float* m)
{
    return sshape_mat4_transpose(m);
}

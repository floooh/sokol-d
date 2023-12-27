// machine generated, do not edit

module sokol.gfx;

// helper function to convert a C string to a D string
string cStrTod(const(char*) c_str) {
    import std.conv: to;
    return c_str.to!string;
}
// helper function to convert "anything" to a Range struct

Range asRange(T)(T val) {
    static if (isPointer!T) {
       return Range(val, __traits(classInstanceSize, T));
    } else static if (is(T == struct)) {
       return Range(val.tupleof);
    } else {
       static assert(0, "Cannot convert to range");
    }
}

struct Buffer {
    uint id;
}
struct Image {
    uint id;
}
struct Sampler {
    uint id;
}
struct Shader {
    uint id;
}
struct Pipeline {
    uint id;
}
struct Pass {
    uint id;
}
struct Context {
    uint id;
}
struct Range {
    const(void)* ptr;
    size_t size;
}
enum invalid_id = 0;
enum num_shader_stages = 2;
enum num_inflight_frames = 2;
enum max_color_attachments = 4;
enum max_vertex_buffers = 8;
enum max_shaderstage_images = 12;
enum max_shaderstage_samplers = 8;
enum max_shaderstage_imagesamplerpairs = 12;
enum max_shaderstage_ubs = 4;
enum max_ub_members = 16;
enum max_vertex_attributes = 16;
enum max_mipmaps = 16;
enum max_texturearray_layers = 128;
struct Color {
    float r;
    float g;
    float b;
    float a;
}
enum Backend {
    GLCORE33,
    GLES3,
    D3D11,
    METAL_IOS,
    METAL_MACOS,
    METAL_SIMULATOR,
    WGPU,
    DUMMY,
}
enum PixelFormat {
    DEFAULT,
    NONE,
    R8,
    R8SN,
    R8UI,
    R8SI,
    R16,
    R16SN,
    R16UI,
    R16SI,
    R16F,
    RG8,
    RG8SN,
    RG8UI,
    RG8SI,
    R32UI,
    R32SI,
    R32F,
    RG16,
    RG16SN,
    RG16UI,
    RG16SI,
    RG16F,
    RGBA8,
    SRGB8A8,
    RGBA8SN,
    RGBA8UI,
    RGBA8SI,
    BGRA8,
    RGB10A2,
    RG11B10F,
    RG32UI,
    RG32SI,
    RG32F,
    RGBA16,
    RGBA16SN,
    RGBA16UI,
    RGBA16SI,
    RGBA16F,
    RGBA32UI,
    RGBA32SI,
    RGBA32F,
    DEPTH,
    DEPTH_STENCIL,
    BC1_RGBA,
    BC2_RGBA,
    BC3_RGBA,
    BC4_R,
    BC4_RSN,
    BC5_RG,
    BC5_RGSN,
    BC6H_RGBF,
    BC6H_RGBUF,
    BC7_RGBA,
    PVRTC_RGB_2BPP,
    PVRTC_RGB_4BPP,
    PVRTC_RGBA_2BPP,
    PVRTC_RGBA_4BPP,
    ETC2_RGB8,
    ETC2_RGB8A1,
    ETC2_RGBA8,
    ETC2_RG11,
    ETC2_RG11SN,
    RGB9E5,
    NUM,
}
struct PixelformatInfo {
    bool sample;
    bool filter;
    bool render;
    bool blend;
    bool msaa;
    bool depth;
}
struct Features {
    bool origin_top_left;
    bool image_clamp_to_border;
    bool mrt_independent_blend_state;
    bool mrt_independent_write_mask;
}
struct Limits {
    int max_image_size_2d;
    int max_image_size_cube;
    int max_image_size_3d;
    int max_image_size_array;
    int max_image_array_layers;
    int max_vertex_attrs;
    int gl_max_vertex_uniform_vectors;
    int gl_max_combined_texture_image_units;
}
enum ResourceState {
    INITIAL,
    ALLOC,
    VALID,
    FAILED,
    INVALID,
}
enum Usage {
    DEFAULT,
    IMMUTABLE,
    DYNAMIC,
    STREAM,
    NUM,
}
enum BufferType {
    DEFAULT,
    VERTEXBUFFER,
    INDEXBUFFER,
    NUM,
}
enum IndexType {
    DEFAULT,
    NONE,
    UINT16,
    UINT32,
    NUM,
}
enum ImageType {
    DEFAULT,
    _2D,
    CUBE,
    _3D,
    ARRAY,
    NUM,
}
enum ImageSampleType {
    DEFAULT,
    FLOAT,
    DEPTH,
    SINT,
    UINT,
    UNFILTERABLE_FLOAT,
    NUM,
}
enum SamplerType {
    DEFAULT,
    FILTERING,
    NONFILTERING,
    COMPARISON,
    NUM,
}
enum CubeFace {
    POS_X,
    NEG_X,
    POS_Y,
    NEG_Y,
    POS_Z,
    NEG_Z,
    NUM,
}
enum ShaderStage {
    VS,
    FS,
}
enum PrimitiveType {
    DEFAULT,
    POINTS,
    LINES,
    LINE_STRIP,
    TRIANGLES,
    TRIANGLE_STRIP,
    NUM,
}
enum Filter {
    DEFAULT,
    NONE,
    NEAREST,
    LINEAR,
    NUM,
}
enum Wrap {
    DEFAULT,
    REPEAT,
    CLAMP_TO_EDGE,
    CLAMP_TO_BORDER,
    MIRRORED_REPEAT,
    NUM,
}
enum BorderColor {
    DEFAULT,
    TRANSPARENT_BLACK,
    OPAQUE_BLACK,
    OPAQUE_WHITE,
    NUM,
}
enum VertexFormat {
    INVALID,
    FLOAT,
    FLOAT2,
    FLOAT3,
    FLOAT4,
    BYTE4,
    BYTE4N,
    UBYTE4,
    UBYTE4N,
    SHORT2,
    SHORT2N,
    USHORT2N,
    SHORT4,
    SHORT4N,
    USHORT4N,
    UINT10_N2,
    HALF2,
    HALF4,
    NUM,
}
enum VertexStep {
    DEFAULT,
    PER_VERTEX,
    PER_INSTANCE,
    NUM,
}
enum UniformType {
    INVALID,
    FLOAT,
    FLOAT2,
    FLOAT3,
    FLOAT4,
    INT,
    INT2,
    INT3,
    INT4,
    MAT4,
    NUM,
}
enum UniformLayout {
    DEFAULT,
    NATIVE,
    STD140,
    NUM,
}
enum CullMode {
    DEFAULT,
    NONE,
    FRONT,
    BACK,
    NUM,
}
enum FaceWinding {
    DEFAULT,
    CCW,
    CW,
    NUM,
}
enum CompareFunc {
    DEFAULT,
    NEVER,
    LESS,
    EQUAL,
    LESS_EQUAL,
    GREATER,
    NOT_EQUAL,
    GREATER_EQUAL,
    ALWAYS,
    NUM,
}
enum StencilOp {
    DEFAULT,
    KEEP,
    ZERO,
    REPLACE,
    INCR_CLAMP,
    DECR_CLAMP,
    INVERT,
    INCR_WRAP,
    DECR_WRAP,
    NUM,
}
enum BlendFactor {
    DEFAULT,
    ZERO,
    ONE,
    SRC_COLOR,
    ONE_MINUS_SRC_COLOR,
    SRC_ALPHA,
    ONE_MINUS_SRC_ALPHA,
    DST_COLOR,
    ONE_MINUS_DST_COLOR,
    DST_ALPHA,
    ONE_MINUS_DST_ALPHA,
    SRC_ALPHA_SATURATED,
    BLEND_COLOR,
    ONE_MINUS_BLEND_COLOR,
    BLEND_ALPHA,
    ONE_MINUS_BLEND_ALPHA,
    NUM,
}
enum BlendOp {
    DEFAULT,
    ADD,
    SUBTRACT,
    REVERSE_SUBTRACT,
    NUM,
}
enum ColorMask {
    DEFAULT = 0,
    NONE = 16,
    R = 1,
    G = 2,
    RG = 3,
    B = 4,
    RB = 5,
    GB = 6,
    RGB = 7,
    A = 8,
    RA = 9,
    GA = 10,
    RGA = 11,
    BA = 12,
    RBA = 13,
    GBA = 14,
    RGBA = 15,
}
enum LoadAction {
    DEFAULT,
    CLEAR,
    LOAD,
    DONTCARE,
}
enum StoreAction {
    DEFAULT,
    STORE,
    DONTCARE,
}
struct ColorAttachmentAction {
    LoadAction load_action;
    StoreAction store_action;
    Color clear_value;
}
struct DepthAttachmentAction {
    LoadAction load_action;
    StoreAction store_action;
    float clear_value;
}
struct StencilAttachmentAction {
    LoadAction load_action;
    StoreAction store_action;
    ubyte clear_value;
}
struct PassAction {
    uint _start_canary;
    ColorAttachmentAction[4] colors;
    DepthAttachmentAction depth;
    StencilAttachmentAction stencil;
    uint _end_canary;
}
struct StageBindings {
    Image[12] images;
    Sampler[8] samplers;
}
struct Bindings {
    uint _start_canary;
    Buffer[8] vertex_buffers;
    int[8] vertex_buffer_offsets;
    Buffer index_buffer;
    int index_buffer_offset;
    StageBindings vs;
    StageBindings fs;
    uint _end_canary;
}
struct BufferDesc {
    uint _start_canary;
    size_t size;
    BufferType type;
    Usage usage;
    Range data;
    const(char*) label;
    uint[2] gl_buffers;
    const(void)*[2] mtl_buffers;
    const(void)* d3d11_buffer;
    const(void)* wgpu_buffer;
    uint _end_canary;
}
struct ImageData {
    Range[6][16] subimage;
}
struct ImageDesc {
    uint _start_canary;
    ImageType type;
    bool render_target;
    int width;
    int height;
    int num_slices;
    int num_mipmaps;
    Usage usage;
    PixelFormat pixel_format;
    int sample_count;
    ImageData data;
    const(char*) label;
    uint[2] gl_textures;
    uint gl_texture_target;
    const(void)*[2] mtl_textures;
    const(void)* d3d11_texture;
    const(void)* d3d11_shader_resource_view;
    const(void)* wgpu_texture;
    const(void)* wgpu_texture_view;
    uint _end_canary;
}
struct SamplerDesc {
    uint _start_canary;
    Filter min_filter;
    Filter mag_filter;
    Filter mipmap_filter;
    Wrap wrap_u;
    Wrap wrap_v;
    Wrap wrap_w;
    float min_lod;
    float max_lod;
    BorderColor border_color;
    CompareFunc compare;
    uint max_anisotropy;
    const(char*) label;
    uint gl_sampler;
    const(void)* mtl_sampler;
    const(void)* d3d11_sampler;
    const(void)* wgpu_sampler;
    uint _end_canary;
}
struct ShaderAttrDesc {
    const(char*) name;
    const(char*) sem_name;
    int sem_index;
}
struct ShaderUniformDesc {
    const(char*) name;
    UniformType type;
    int array_count;
}
struct ShaderUniformBlockDesc {
    size_t size;
    UniformLayout layout;
    ShaderUniformDesc[16] uniforms;
}
struct ShaderImageDesc {
    bool used;
    bool multisampled;
    ImageType image_type;
    ImageSampleType sample_type;
}
struct ShaderSamplerDesc {
    bool used;
    SamplerType sampler_type;
}
struct ShaderImageSamplerPairDesc {
    bool used;
    int image_slot;
    int sampler_slot;
    const(char*) glsl_name;
}
struct ShaderStageDesc {
    const(char*) source;
    Range bytecode;
    const(char*) entry;
    const(char*) d3d11_target;
    ShaderUniformBlockDesc[4] uniform_blocks;
    ShaderImageDesc[12] images;
    ShaderSamplerDesc[8] samplers;
    ShaderImageSamplerPairDesc[12] image_sampler_pairs;
}
struct ShaderDesc {
    uint _start_canary;
    ShaderAttrDesc[16] attrs;
    ShaderStageDesc vs;
    ShaderStageDesc fs;
    const(char*) label;
    uint _end_canary;
}
struct VertexBufferLayoutState {
    int stride;
    VertexStep step_func;
    int step_rate;
}
struct VertexAttrState {
    int buffer_index;
    int offset;
    VertexFormat format;
}
struct VertexLayoutState {
    VertexBufferLayoutState[8] buffers;
    VertexAttrState[16] attrs;
}
struct StencilFaceState {
    CompareFunc compare;
    StencilOp fail_op;
    StencilOp depth_fail_op;
    StencilOp pass_op;
}
struct StencilState {
    bool enabled;
    StencilFaceState front;
    StencilFaceState back;
    ubyte read_mask;
    ubyte write_mask;
    ubyte _ref;
}
struct DepthState {
    PixelFormat pixel_format;
    CompareFunc compare;
    bool write_enabled;
    float bias;
    float bias_slope_scale;
    float bias_clamp;
}
struct BlendState {
    bool enabled;
    BlendFactor src_factor_rgb;
    BlendFactor dst_factor_rgb;
    BlendOp op_rgb;
    BlendFactor src_factor_alpha;
    BlendFactor dst_factor_alpha;
    BlendOp op_alpha;
}
struct ColorTargetState {
    PixelFormat pixel_format;
    ColorMask write_mask;
    BlendState blend;
}
struct PipelineDesc {
    uint _start_canary;
    Shader shader;
    VertexLayoutState layout;
    DepthState depth;
    StencilState stencil;
    int color_count;
    ColorTargetState[4] colors;
    PrimitiveType primitive_type;
    IndexType index_type;
    CullMode cull_mode;
    FaceWinding face_winding;
    int sample_count;
    Color blend_color;
    bool alpha_to_coverage_enabled;
    const(char*) label;
    uint _end_canary;
}
struct PassAttachmentDesc {
    Image image;
    int mip_level;
    int slice;
}
struct PassDesc {
    uint _start_canary;
    PassAttachmentDesc[4] color_attachments;
    PassAttachmentDesc[4] resolve_attachments;
    PassAttachmentDesc depth_stencil_attachment;
    const(char*) label;
    uint _end_canary;
}
struct TraceHooks {
    void* user_data;
    extern(C) void function(void*) reset_state_cache;
    extern(C) void function(const BufferDesc *, Buffer, void*) make_buffer;
    extern(C) void function(const ImageDesc *, Image, void*) make_image;
    extern(C) void function(const SamplerDesc *, Sampler, void*) make_sampler;
    extern(C) void function(const ShaderDesc *, Shader, void*) make_shader;
    extern(C) void function(const PipelineDesc *, Pipeline, void*) make_pipeline;
    extern(C) void function(const PassDesc *, Pass, void*) make_pass;
    extern(C) void function(Buffer, void*) destroy_buffer;
    extern(C) void function(Image, void*) destroy_image;
    extern(C) void function(Sampler, void*) destroy_sampler;
    extern(C) void function(Shader, void*) destroy_shader;
    extern(C) void function(Pipeline, void*) destroy_pipeline;
    extern(C) void function(Pass, void*) destroy_pass;
    extern(C) void function(Buffer, const Range *, void*) update_buffer;
    extern(C) void function(Image, const ImageData *, void*) update_image;
    extern(C) void function(Buffer, const Range *, int, void*) append_buffer;
    extern(C) void function(const PassAction *, int, int, void*) begin_default_pass;
    extern(C) void function(Pass, const PassAction *, void*) begin_pass;
    extern(C) void function(int, int, int, int, bool, void*) apply_viewport;
    extern(C) void function(int, int, int, int, bool, void*) apply_scissor_rect;
    extern(C) void function(Pipeline, void*) apply_pipeline;
    extern(C) void function(const Bindings *, void*) apply_bindings;
    extern(C) void function(ShaderStage, int, const Range *, void*) apply_uniforms;
    extern(C) void function(int, int, int, void*) draw;
    extern(C) void function(void*) end_pass;
    extern(C) void function(void*) commit;
    extern(C) void function(Buffer, void*) alloc_buffer;
    extern(C) void function(Image, void*) alloc_image;
    extern(C) void function(Sampler, void*) alloc_sampler;
    extern(C) void function(Shader, void*) alloc_shader;
    extern(C) void function(Pipeline, void*) alloc_pipeline;
    extern(C) void function(Pass, void*) alloc_pass;
    extern(C) void function(Buffer, void*) dealloc_buffer;
    extern(C) void function(Image, void*) dealloc_image;
    extern(C) void function(Sampler, void*) dealloc_sampler;
    extern(C) void function(Shader, void*) dealloc_shader;
    extern(C) void function(Pipeline, void*) dealloc_pipeline;
    extern(C) void function(Pass, void*) dealloc_pass;
    extern(C) void function(Buffer, const BufferDesc *, void*) init_buffer;
    extern(C) void function(Image, const ImageDesc *, void*) init_image;
    extern(C) void function(Sampler, const SamplerDesc *, void*) init_sampler;
    extern(C) void function(Shader, const ShaderDesc *, void*) init_shader;
    extern(C) void function(Pipeline, const PipelineDesc *, void*) init_pipeline;
    extern(C) void function(Pass, const PassDesc *, void*) init_pass;
    extern(C) void function(Buffer, void*) uninit_buffer;
    extern(C) void function(Image, void*) uninit_image;
    extern(C) void function(Sampler, void*) uninit_sampler;
    extern(C) void function(Shader, void*) uninit_shader;
    extern(C) void function(Pipeline, void*) uninit_pipeline;
    extern(C) void function(Pass, void*) uninit_pass;
    extern(C) void function(Buffer, void*) fail_buffer;
    extern(C) void function(Image, void*) fail_image;
    extern(C) void function(Sampler, void*) fail_sampler;
    extern(C) void function(Shader, void*) fail_shader;
    extern(C) void function(Pipeline, void*) fail_pipeline;
    extern(C) void function(Pass, void*) fail_pass;
    extern(C) void function(const(char*), void*) push_debug_group;
    extern(C) void function(void*) pop_debug_group;
}
struct SlotInfo {
    ResourceState state;
    uint res_id;
    uint ctx_id;
}
struct BufferInfo {
    SlotInfo slot;
    uint update_frame_index;
    uint append_frame_index;
    int append_pos;
    bool append_overflow;
    int num_slots;
    int active_slot;
}
struct ImageInfo {
    SlotInfo slot;
    uint upd_frame_index;
    int num_slots;
    int active_slot;
}
struct SamplerInfo {
    SlotInfo slot;
}
struct ShaderInfo {
    SlotInfo slot;
}
struct PipelineInfo {
    SlotInfo slot;
}
struct PassInfo {
    SlotInfo slot;
}
struct FrameStatsGl {
    uint num_bind_buffer;
    uint num_active_texture;
    uint num_bind_texture;
    uint num_bind_sampler;
    uint num_use_program;
    uint num_render_state;
    uint num_vertex_attrib_pointer;
    uint num_vertex_attrib_divisor;
    uint num_enable_vertex_attrib_array;
    uint num_disable_vertex_attrib_array;
    uint num_uniform;
}
struct FrameStatsD3d11Pass {
    uint num_om_set_render_targets;
    uint num_clear_render_target_view;
    uint num_clear_depth_stencil_view;
    uint num_resolve_subresource;
}
struct FrameStatsD3d11Pipeline {
    uint num_rs_set_state;
    uint num_om_set_depth_stencil_state;
    uint num_om_set_blend_state;
    uint num_ia_set_primitive_topology;
    uint num_ia_set_input_layout;
    uint num_vs_set_shader;
    uint num_vs_set_constant_buffers;
    uint num_ps_set_shader;
    uint num_ps_set_constant_buffers;
}
struct FrameStatsD3d11Bindings {
    uint num_ia_set_vertex_buffers;
    uint num_ia_set_index_buffer;
    uint num_vs_set_shader_resources;
    uint num_ps_set_shader_resources;
    uint num_vs_set_samplers;
    uint num_ps_set_samplers;
}
struct FrameStatsD3d11Uniforms {
    uint num_update_subresource;
}
struct FrameStatsD3d11Draw {
    uint num_draw_indexed_instanced;
    uint num_draw_indexed;
    uint num_draw_instanced;
    uint num_draw;
}
struct FrameStatsD3d11 {
    FrameStatsD3d11Pass pass;
    FrameStatsD3d11Pipeline pipeline;
    FrameStatsD3d11Bindings bindings;
    FrameStatsD3d11Uniforms uniforms;
    FrameStatsD3d11Draw draw;
    uint num_map;
    uint num_unmap;
}
struct FrameStatsMetalIdpool {
    uint num_added;
    uint num_released;
    uint num_garbage_collected;
}
struct FrameStatsMetalPipeline {
    uint num_set_blend_color;
    uint num_set_cull_mode;
    uint num_set_front_facing_winding;
    uint num_set_stencil_reference_value;
    uint num_set_depth_bias;
    uint num_set_render_pipeline_state;
    uint num_set_depth_stencil_state;
}
struct FrameStatsMetalBindings {
    uint num_set_vertex_buffer;
    uint num_set_vertex_texture;
    uint num_set_vertex_sampler_state;
    uint num_set_fragment_texture;
    uint num_set_fragment_sampler_state;
}
struct FrameStatsMetalUniforms {
    uint num_set_vertex_buffer_offset;
    uint num_set_fragment_buffer_offset;
}
struct FrameStatsMetal {
    FrameStatsMetalIdpool idpool;
    FrameStatsMetalPipeline pipeline;
    FrameStatsMetalBindings bindings;
    FrameStatsMetalUniforms uniforms;
}
struct FrameStatsWgpuUniforms {
    uint num_set_bindgroup;
    uint size_write_buffer;
}
struct FrameStatsWgpuBindings {
    uint num_set_vertex_buffer;
    uint num_skip_redundant_vertex_buffer;
    uint num_set_index_buffer;
    uint num_skip_redundant_index_buffer;
    uint num_create_bindgroup;
    uint num_discard_bindgroup;
    uint num_set_bindgroup;
    uint num_skip_redundant_bindgroup;
    uint num_bindgroup_cache_hits;
    uint num_bindgroup_cache_misses;
    uint num_bindgroup_cache_collisions;
    uint num_bindgroup_cache_hash_vs_key_mismatch;
}
struct FrameStatsWgpu {
    FrameStatsWgpuUniforms uniforms;
    FrameStatsWgpuBindings bindings;
}
struct FrameStats {
    uint frame_index;
    uint num_passes;
    uint num_apply_viewport;
    uint num_apply_scissor_rect;
    uint num_apply_pipeline;
    uint num_apply_bindings;
    uint num_apply_uniforms;
    uint num_draw;
    uint num_update_buffer;
    uint num_append_buffer;
    uint num_update_image;
    uint size_apply_uniforms;
    uint size_update_buffer;
    uint size_append_buffer;
    uint size_update_image;
    FrameStatsGl gl;
    FrameStatsD3d11 d3d11;
    FrameStatsMetal metal;
    FrameStatsWgpu wgpu;
}
enum LogItem {
    OK,
    MALLOC_FAILED,
    GL_TEXTURE_FORMAT_NOT_SUPPORTED,
    GL_3D_TEXTURES_NOT_SUPPORTED,
    GL_ARRAY_TEXTURES_NOT_SUPPORTED,
    GL_SHADER_COMPILATION_FAILED,
    GL_SHADER_LINKING_FAILED,
    GL_VERTEX_ATTRIBUTE_NOT_FOUND_IN_SHADER,
    GL_TEXTURE_NAME_NOT_FOUND_IN_SHADER,
    GL_FRAMEBUFFER_STATUS_UNDEFINED,
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_ATTACHMENT,
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MISSING_ATTACHMENT,
    GL_FRAMEBUFFER_STATUS_UNSUPPORTED,
    GL_FRAMEBUFFER_STATUS_INCOMPLETE_MULTISAMPLE,
    GL_FRAMEBUFFER_STATUS_UNKNOWN,
    D3D11_CREATE_BUFFER_FAILED,
    D3D11_CREATE_DEPTH_TEXTURE_UNSUPPORTED_PIXEL_FORMAT,
    D3D11_CREATE_DEPTH_TEXTURE_FAILED,
    D3D11_CREATE_2D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT,
    D3D11_CREATE_2D_TEXTURE_FAILED,
    D3D11_CREATE_2D_SRV_FAILED,
    D3D11_CREATE_3D_TEXTURE_UNSUPPORTED_PIXEL_FORMAT,
    D3D11_CREATE_3D_TEXTURE_FAILED,
    D3D11_CREATE_3D_SRV_FAILED,
    D3D11_CREATE_MSAA_TEXTURE_FAILED,
    D3D11_CREATE_SAMPLER_STATE_FAILED,
    D3D11_LOAD_D3DCOMPILER_47_DLL_FAILED,
    D3D11_SHADER_COMPILATION_FAILED,
    D3D11_SHADER_COMPILATION_OUTPUT,
    D3D11_CREATE_CONSTANT_BUFFER_FAILED,
    D3D11_CREATE_INPUT_LAYOUT_FAILED,
    D3D11_CREATE_RASTERIZER_STATE_FAILED,
    D3D11_CREATE_DEPTH_STENCIL_STATE_FAILED,
    D3D11_CREATE_BLEND_STATE_FAILED,
    D3D11_CREATE_RTV_FAILED,
    D3D11_CREATE_DSV_FAILED,
    D3D11_MAP_FOR_UPDATE_BUFFER_FAILED,
    D3D11_MAP_FOR_APPEND_BUFFER_FAILED,
    D3D11_MAP_FOR_UPDATE_IMAGE_FAILED,
    METAL_CREATE_BUFFER_FAILED,
    METAL_TEXTURE_FORMAT_NOT_SUPPORTED,
    METAL_CREATE_TEXTURE_FAILED,
    METAL_CREATE_SAMPLER_FAILED,
    METAL_SHADER_COMPILATION_FAILED,
    METAL_SHADER_CREATION_FAILED,
    METAL_SHADER_COMPILATION_OUTPUT,
    METAL_VERTEX_SHADER_ENTRY_NOT_FOUND,
    METAL_FRAGMENT_SHADER_ENTRY_NOT_FOUND,
    METAL_CREATE_RPS_FAILED,
    METAL_CREATE_RPS_OUTPUT,
    METAL_CREATE_DSS_FAILED,
    WGPU_BINDGROUPS_POOL_EXHAUSTED,
    WGPU_BINDGROUPSCACHE_SIZE_GREATER_ONE,
    WGPU_BINDGROUPSCACHE_SIZE_POW2,
    WGPU_CREATEBINDGROUP_FAILED,
    WGPU_CREATE_BUFFER_FAILED,
    WGPU_CREATE_TEXTURE_FAILED,
    WGPU_CREATE_TEXTURE_VIEW_FAILED,
    WGPU_CREATE_SAMPLER_FAILED,
    WGPU_CREATE_SHADER_MODULE_FAILED,
    WGPU_SHADER_TOO_MANY_IMAGES,
    WGPU_SHADER_TOO_MANY_SAMPLERS,
    WGPU_SHADER_CREATE_BINDGROUP_LAYOUT_FAILED,
    WGPU_CREATE_PIPELINE_LAYOUT_FAILED,
    WGPU_CREATE_RENDER_PIPELINE_FAILED,
    WGPU_PASS_CREATE_TEXTURE_VIEW_FAILED,
    UNINIT_BUFFER_ACTIVE_CONTEXT_MISMATCH,
    UNINIT_IMAGE_ACTIVE_CONTEXT_MISMATCH,
    UNINIT_SAMPLER_ACTIVE_CONTEXT_MISMATCH,
    UNINIT_SHADER_ACTIVE_CONTEXT_MISMATCH,
    UNINIT_PIPELINE_ACTIVE_CONTEXT_MISMATCH,
    UNINIT_PASS_ACTIVE_CONTEXT_MISMATCH,
    IDENTICAL_COMMIT_LISTENER,
    COMMIT_LISTENER_ARRAY_FULL,
    TRACE_HOOKS_NOT_ENABLED,
    DEALLOC_BUFFER_INVALID_STATE,
    DEALLOC_IMAGE_INVALID_STATE,
    DEALLOC_SAMPLER_INVALID_STATE,
    DEALLOC_SHADER_INVALID_STATE,
    DEALLOC_PIPELINE_INVALID_STATE,
    DEALLOC_PASS_INVALID_STATE,
    INIT_BUFFER_INVALID_STATE,
    INIT_IMAGE_INVALID_STATE,
    INIT_SAMPLER_INVALID_STATE,
    INIT_SHADER_INVALID_STATE,
    INIT_PIPELINE_INVALID_STATE,
    INIT_PASS_INVALID_STATE,
    UNINIT_BUFFER_INVALID_STATE,
    UNINIT_IMAGE_INVALID_STATE,
    UNINIT_SAMPLER_INVALID_STATE,
    UNINIT_SHADER_INVALID_STATE,
    UNINIT_PIPELINE_INVALID_STATE,
    UNINIT_PASS_INVALID_STATE,
    FAIL_BUFFER_INVALID_STATE,
    FAIL_IMAGE_INVALID_STATE,
    FAIL_SAMPLER_INVALID_STATE,
    FAIL_SHADER_INVALID_STATE,
    FAIL_PIPELINE_INVALID_STATE,
    FAIL_PASS_INVALID_STATE,
    BUFFER_POOL_EXHAUSTED,
    IMAGE_POOL_EXHAUSTED,
    SAMPLER_POOL_EXHAUSTED,
    SHADER_POOL_EXHAUSTED,
    PIPELINE_POOL_EXHAUSTED,
    PASS_POOL_EXHAUSTED,
    DRAW_WITHOUT_BINDINGS,
    VALIDATE_BUFFERDESC_CANARY,
    VALIDATE_BUFFERDESC_SIZE,
    VALIDATE_BUFFERDESC_DATA,
    VALIDATE_BUFFERDESC_DATA_SIZE,
    VALIDATE_BUFFERDESC_NO_DATA,
    VALIDATE_IMAGEDATA_NODATA,
    VALIDATE_IMAGEDATA_DATA_SIZE,
    VALIDATE_IMAGEDESC_CANARY,
    VALIDATE_IMAGEDESC_WIDTH,
    VALIDATE_IMAGEDESC_HEIGHT,
    VALIDATE_IMAGEDESC_RT_PIXELFORMAT,
    VALIDATE_IMAGEDESC_NONRT_PIXELFORMAT,
    VALIDATE_IMAGEDESC_MSAA_BUT_NO_RT,
    VALIDATE_IMAGEDESC_NO_MSAA_RT_SUPPORT,
    VALIDATE_IMAGEDESC_MSAA_NUM_MIPMAPS,
    VALIDATE_IMAGEDESC_MSAA_3D_IMAGE,
    VALIDATE_IMAGEDESC_DEPTH_3D_IMAGE,
    VALIDATE_IMAGEDESC_RT_IMMUTABLE,
    VALIDATE_IMAGEDESC_RT_NO_DATA,
    VALIDATE_IMAGEDESC_INJECTED_NO_DATA,
    VALIDATE_IMAGEDESC_DYNAMIC_NO_DATA,
    VALIDATE_IMAGEDESC_COMPRESSED_IMMUTABLE,
    VALIDATE_SAMPLERDESC_CANARY,
    VALIDATE_SAMPLERDESC_MINFILTER_NONE,
    VALIDATE_SAMPLERDESC_MAGFILTER_NONE,
    VALIDATE_SAMPLERDESC_ANISTROPIC_REQUIRES_LINEAR_FILTERING,
    VALIDATE_SHADERDESC_CANARY,
    VALIDATE_SHADERDESC_SOURCE,
    VALIDATE_SHADERDESC_BYTECODE,
    VALIDATE_SHADERDESC_SOURCE_OR_BYTECODE,
    VALIDATE_SHADERDESC_NO_BYTECODE_SIZE,
    VALIDATE_SHADERDESC_NO_CONT_UBS,
    VALIDATE_SHADERDESC_NO_CONT_UB_MEMBERS,
    VALIDATE_SHADERDESC_NO_UB_MEMBERS,
    VALIDATE_SHADERDESC_UB_MEMBER_NAME,
    VALIDATE_SHADERDESC_UB_SIZE_MISMATCH,
    VALIDATE_SHADERDESC_UB_ARRAY_COUNT,
    VALIDATE_SHADERDESC_UB_STD140_ARRAY_TYPE,
    VALIDATE_SHADERDESC_NO_CONT_IMAGES,
    VALIDATE_SHADERDESC_NO_CONT_SAMPLERS,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_IMAGE_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_SAMPLER_SLOT_OUT_OF_RANGE,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_NAME_REQUIRED_FOR_GL,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_HAS_NAME_BUT_NOT_USED,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_HAS_IMAGE_BUT_NOT_USED,
    VALIDATE_SHADERDESC_IMAGE_SAMPLER_PAIR_HAS_SAMPLER_BUT_NOT_USED,
    VALIDATE_SHADERDESC_NONFILTERING_SAMPLER_REQUIRED,
    VALIDATE_SHADERDESC_COMPARISON_SAMPLER_REQUIRED,
    VALIDATE_SHADERDESC_IMAGE_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS,
    VALIDATE_SHADERDESC_SAMPLER_NOT_REFERENCED_BY_IMAGE_SAMPLER_PAIRS,
    VALIDATE_SHADERDESC_NO_CONT_IMAGE_SAMPLER_PAIRS,
    VALIDATE_SHADERDESC_ATTR_SEMANTICS,
    VALIDATE_SHADERDESC_ATTR_STRING_TOO_LONG,
    VALIDATE_PIPELINEDESC_CANARY,
    VALIDATE_PIPELINEDESC_SHADER,
    VALIDATE_PIPELINEDESC_NO_ATTRS,
    VALIDATE_PIPELINEDESC_LAYOUT_STRIDE4,
    VALIDATE_PIPELINEDESC_ATTR_SEMANTICS,
    VALIDATE_PASSDESC_CANARY,
    VALIDATE_PASSDESC_NO_ATTACHMENTS,
    VALIDATE_PASSDESC_NO_CONT_COLOR_ATTS,
    VALIDATE_PASSDESC_IMAGE,
    VALIDATE_PASSDESC_MIPLEVEL,
    VALIDATE_PASSDESC_FACE,
    VALIDATE_PASSDESC_LAYER,
    VALIDATE_PASSDESC_SLICE,
    VALIDATE_PASSDESC_IMAGE_NO_RT,
    VALIDATE_PASSDESC_COLOR_INV_PIXELFORMAT,
    VALIDATE_PASSDESC_DEPTH_INV_PIXELFORMAT,
    VALIDATE_PASSDESC_IMAGE_SIZES,
    VALIDATE_PASSDESC_IMAGE_SAMPLE_COUNTS,
    VALIDATE_PASSDESC_RESOLVE_COLOR_IMAGE_MSAA,
    VALIDATE_PASSDESC_RESOLVE_IMAGE,
    VALIDATE_PASSDESC_RESOLVE_SAMPLE_COUNT,
    VALIDATE_PASSDESC_RESOLVE_MIPLEVEL,
    VALIDATE_PASSDESC_RESOLVE_FACE,
    VALIDATE_PASSDESC_RESOLVE_LAYER,
    VALIDATE_PASSDESC_RESOLVE_SLICE,
    VALIDATE_PASSDESC_RESOLVE_IMAGE_NO_RT,
    VALIDATE_PASSDESC_RESOLVE_IMAGE_SIZES,
    VALIDATE_PASSDESC_RESOLVE_IMAGE_FORMAT,
    VALIDATE_PASSDESC_DEPTH_IMAGE,
    VALIDATE_PASSDESC_DEPTH_MIPLEVEL,
    VALIDATE_PASSDESC_DEPTH_FACE,
    VALIDATE_PASSDESC_DEPTH_LAYER,
    VALIDATE_PASSDESC_DEPTH_SLICE,
    VALIDATE_PASSDESC_DEPTH_IMAGE_NO_RT,
    VALIDATE_PASSDESC_DEPTH_IMAGE_SIZES,
    VALIDATE_PASSDESC_DEPTH_IMAGE_SAMPLE_COUNT,
    VALIDATE_BEGINPASS_PASS,
    VALIDATE_BEGINPASS_COLOR_ATTACHMENT_IMAGE,
    VALIDATE_BEGINPASS_RESOLVE_ATTACHMENT_IMAGE,
    VALIDATE_BEGINPASS_DEPTHSTENCIL_ATTACHMENT_IMAGE,
    VALIDATE_APIP_PIPELINE_VALID_ID,
    VALIDATE_APIP_PIPELINE_EXISTS,
    VALIDATE_APIP_PIPELINE_VALID,
    VALIDATE_APIP_SHADER_EXISTS,
    VALIDATE_APIP_SHADER_VALID,
    VALIDATE_APIP_ATT_COUNT,
    VALIDATE_APIP_COLOR_FORMAT,
    VALIDATE_APIP_DEPTH_FORMAT,
    VALIDATE_APIP_SAMPLE_COUNT,
    VALIDATE_ABND_PIPELINE,
    VALIDATE_ABND_PIPELINE_EXISTS,
    VALIDATE_ABND_PIPELINE_VALID,
    VALIDATE_ABND_VBS,
    VALIDATE_ABND_VB_EXISTS,
    VALIDATE_ABND_VB_TYPE,
    VALIDATE_ABND_VB_OVERFLOW,
    VALIDATE_ABND_NO_IB,
    VALIDATE_ABND_IB,
    VALIDATE_ABND_IB_EXISTS,
    VALIDATE_ABND_IB_TYPE,
    VALIDATE_ABND_IB_OVERFLOW,
    VALIDATE_ABND_VS_EXPECTED_IMAGE_BINDING,
    VALIDATE_ABND_VS_IMG_EXISTS,
    VALIDATE_ABND_VS_IMAGE_TYPE_MISMATCH,
    VALIDATE_ABND_VS_IMAGE_MSAA,
    VALIDATE_ABND_VS_EXPECTED_FILTERABLE_IMAGE,
    VALIDATE_ABND_VS_EXPECTED_DEPTH_IMAGE,
    VALIDATE_ABND_VS_UNEXPECTED_IMAGE_BINDING,
    VALIDATE_ABND_VS_EXPECTED_SAMPLER_BINDING,
    VALIDATE_ABND_VS_UNEXPECTED_SAMPLER_COMPARE_NEVER,
    VALIDATE_ABND_VS_EXPECTED_SAMPLER_COMPARE_NEVER,
    VALIDATE_ABND_VS_EXPECTED_NONFILTERING_SAMPLER,
    VALIDATE_ABND_VS_UNEXPECTED_SAMPLER_BINDING,
    VALIDATE_ABND_VS_SMP_EXISTS,
    VALIDATE_ABND_FS_EXPECTED_IMAGE_BINDING,
    VALIDATE_ABND_FS_IMG_EXISTS,
    VALIDATE_ABND_FS_IMAGE_TYPE_MISMATCH,
    VALIDATE_ABND_FS_IMAGE_MSAA,
    VALIDATE_ABND_FS_EXPECTED_FILTERABLE_IMAGE,
    VALIDATE_ABND_FS_EXPECTED_DEPTH_IMAGE,
    VALIDATE_ABND_FS_UNEXPECTED_IMAGE_BINDING,
    VALIDATE_ABND_FS_EXPECTED_SAMPLER_BINDING,
    VALIDATE_ABND_FS_UNEXPECTED_SAMPLER_COMPARE_NEVER,
    VALIDATE_ABND_FS_EXPECTED_SAMPLER_COMPARE_NEVER,
    VALIDATE_ABND_FS_EXPECTED_NONFILTERING_SAMPLER,
    VALIDATE_ABND_FS_UNEXPECTED_SAMPLER_BINDING,
    VALIDATE_ABND_FS_SMP_EXISTS,
    VALIDATE_AUB_NO_PIPELINE,
    VALIDATE_AUB_NO_UB_AT_SLOT,
    VALIDATE_AUB_SIZE,
    VALIDATE_UPDATEBUF_USAGE,
    VALIDATE_UPDATEBUF_SIZE,
    VALIDATE_UPDATEBUF_ONCE,
    VALIDATE_UPDATEBUF_APPEND,
    VALIDATE_APPENDBUF_USAGE,
    VALIDATE_APPENDBUF_SIZE,
    VALIDATE_APPENDBUF_UPDATE,
    VALIDATE_UPDIMG_USAGE,
    VALIDATE_UPDIMG_ONCE,
    VALIDATION_FAILED,
}
struct MetalContextDesc {
    const(void)* device;
    extern(C) const(void)* function() renderpass_descriptor_cb;
    extern(C) const(void)* function(void*) renderpass_descriptor_userdata_cb;
    extern(C) const(void)* function() drawable_cb;
    extern(C) const(void)* function(void*) drawable_userdata_cb;
    void* user_data;
}
struct D3d11ContextDesc {
    const(void)* device;
    const(void)* device_context;
    extern(C) const(void)* function() render_target_view_cb;
    extern(C) const(void)* function(void*) render_target_view_userdata_cb;
    extern(C) const(void)* function() depth_stencil_view_cb;
    extern(C) const(void)* function(void*) depth_stencil_view_userdata_cb;
    void* user_data;
}
struct WgpuContextDesc {
    const(void)* device;
    extern(C) const(void)* function() render_view_cb;
    extern(C) const(void)* function(void*) render_view_userdata_cb;
    extern(C) const(void)* function() resolve_view_cb;
    extern(C) const(void)* function(void*) resolve_view_userdata_cb;
    extern(C) const(void)* function() depth_stencil_view_cb;
    extern(C) const(void)* function(void*) depth_stencil_view_userdata_cb;
    void* user_data;
}
struct GlContextDesc {
    extern(C) uint function() default_framebuffer_cb;
    extern(C) uint function(void*) default_framebuffer_userdata_cb;
    void* user_data;
}
struct ContextDesc {
    int color_format;
    int depth_format;
    int sample_count;
    MetalContextDesc metal;
    D3d11ContextDesc d3d11;
    WgpuContextDesc wgpu;
    GlContextDesc gl;
}
struct CommitListener {
    extern(C) void function(void*) func;
    void* user_data;
}
struct Allocator {
    extern(C) void* function(size_t, void*) alloc_fn;
    extern(C) void function(void*, void*) free_fn;
    void* user_data;
}
struct Logger {
    extern(C) void function(const(char*), uint, uint, const(char*), uint, const(char*), void*) func;
    void* user_data;
}
struct Desc {
    uint _start_canary;
    int buffer_pool_size;
    int image_pool_size;
    int sampler_pool_size;
    int shader_pool_size;
    int pipeline_pool_size;
    int pass_pool_size;
    int context_pool_size;
    int uniform_buffer_size;
    int max_commit_listeners;
    bool disable_validation;
    bool mtl_force_managed_storage_mode;
    bool wgpu_disable_bindgroups_cache;
    int wgpu_bindgroups_cache_size;
    Allocator allocator;
    Logger logger;
    ContextDesc context;
    uint _end_canary;
}
extern(C) void sg_setup(const Desc *) @system @nogc nothrow;
void setup(Desc desc) @trusted @nogc nothrow {
    sg_setup(&desc);
}
extern(C) void sg_shutdown() @system @nogc nothrow;
void shutdown() @trusted @nogc nothrow {
    sg_shutdown();
}
extern(C) bool sg_isvalid() @system @nogc nothrow;
bool isvalid() @trusted @nogc nothrow {
    return sg_isvalid();
}
extern(C) void sg_reset_state_cache() @system @nogc nothrow;
void resetStateCache() @trusted @nogc nothrow {
    sg_reset_state_cache();
}
extern(C) TraceHooks sg_install_trace_hooks(const TraceHooks *) @system @nogc nothrow;
TraceHooks installTraceHooks(TraceHooks trace_hooks) @trusted @nogc nothrow {
    return sg_install_trace_hooks(&trace_hooks);
}
extern(C) void sg_push_debug_group(const(char*)) @system @nogc nothrow;
void pushDebugGroup(scope const(char*) name) @trusted @nogc nothrow {
    sg_push_debug_group(name);
}
extern(C) void sg_pop_debug_group() @system @nogc nothrow;
void popDebugGroup() @trusted @nogc nothrow {
    sg_pop_debug_group();
}
extern(C) bool sg_add_commit_listener(CommitListener) @system @nogc nothrow;
bool addCommitListener(CommitListener listener) @trusted @nogc nothrow {
    return sg_add_commit_listener(listener);
}
extern(C) bool sg_remove_commit_listener(CommitListener) @system @nogc nothrow;
bool removeCommitListener(CommitListener listener) @trusted @nogc nothrow {
    return sg_remove_commit_listener(listener);
}
extern(C) Buffer sg_make_buffer(const BufferDesc *) @system @nogc nothrow;
Buffer makeBuffer(BufferDesc desc) @trusted @nogc nothrow {
    return sg_make_buffer(&desc);
}
extern(C) Image sg_make_image(const ImageDesc *) @system @nogc nothrow;
Image makeImage(ImageDesc desc) @trusted @nogc nothrow {
    return sg_make_image(&desc);
}
extern(C) Sampler sg_make_sampler(const SamplerDesc *) @system @nogc nothrow;
Sampler makeSampler(SamplerDesc desc) @trusted @nogc nothrow {
    return sg_make_sampler(&desc);
}
extern(C) Shader sg_make_shader(const ShaderDesc *) @system @nogc nothrow;
Shader makeShader(ShaderDesc desc) @trusted @nogc nothrow {
    return sg_make_shader(&desc);
}
extern(C) Pipeline sg_make_pipeline(const PipelineDesc *) @system @nogc nothrow;
Pipeline makePipeline(PipelineDesc desc) @trusted @nogc nothrow {
    return sg_make_pipeline(&desc);
}
extern(C) Pass sg_make_pass(const PassDesc *) @system @nogc nothrow;
Pass makePass(PassDesc desc) @trusted @nogc nothrow {
    return sg_make_pass(&desc);
}
extern(C) void sg_destroy_buffer(Buffer) @system @nogc nothrow;
void destroyBuffer(Buffer buf) @trusted @nogc nothrow {
    sg_destroy_buffer(buf);
}
extern(C) void sg_destroy_image(Image) @system @nogc nothrow;
void destroyImage(Image img) @trusted @nogc nothrow {
    sg_destroy_image(img);
}
extern(C) void sg_destroy_sampler(Sampler) @system @nogc nothrow;
void destroySampler(Sampler smp) @trusted @nogc nothrow {
    sg_destroy_sampler(smp);
}
extern(C) void sg_destroy_shader(Shader) @system @nogc nothrow;
void destroyShader(Shader shd) @trusted @nogc nothrow {
    sg_destroy_shader(shd);
}
extern(C) void sg_destroy_pipeline(Pipeline) @system @nogc nothrow;
void destroyPipeline(Pipeline pip) @trusted @nogc nothrow {
    sg_destroy_pipeline(pip);
}
extern(C) void sg_destroy_pass(Pass) @system @nogc nothrow;
void destroyPass(Pass pass) @trusted @nogc nothrow {
    sg_destroy_pass(pass);
}
extern(C) void sg_update_buffer(Buffer, const Range *) @system @nogc nothrow;
void updateBuffer(Buffer buf, Range data) @trusted @nogc nothrow {
    sg_update_buffer(buf, &data);
}
extern(C) void sg_update_image(Image, const ImageData *) @system @nogc nothrow;
void updateImage(Image img, ImageData data) @trusted @nogc nothrow {
    sg_update_image(img, &data);
}
extern(C) int sg_append_buffer(Buffer, const Range *) @system @nogc nothrow;
int appendBuffer(Buffer buf, Range data) @trusted @nogc nothrow {
    return sg_append_buffer(buf, &data);
}
extern(C) bool sg_query_buffer_overflow(Buffer) @system @nogc nothrow;
bool queryBufferOverflow(Buffer buf) @trusted @nogc nothrow {
    return sg_query_buffer_overflow(buf);
}
extern(C) bool sg_query_buffer_will_overflow(Buffer, size_t) @system @nogc nothrow;
bool queryBufferWillOverflow(Buffer buf, size_t size) @trusted @nogc nothrow {
    return sg_query_buffer_will_overflow(buf, size);
}
extern(C) void sg_begin_default_pass(const PassAction *, int, int) @system @nogc nothrow;
void beginDefaultPass(PassAction pass_action, int width, int height) @trusted @nogc nothrow {
    sg_begin_default_pass(&pass_action, width, height);
}
extern(C) void sg_begin_default_passf(const PassAction *, float, float) @system @nogc nothrow;
void beginDefaultPassf(PassAction pass_action, float width, float height) @trusted @nogc nothrow {
    sg_begin_default_passf(&pass_action, width, height);
}
extern(C) void sg_begin_pass(Pass, const PassAction *) @system @nogc nothrow;
void beginPass(Pass pass, PassAction pass_action) @trusted @nogc nothrow {
    sg_begin_pass(pass, &pass_action);
}
extern(C) void sg_apply_viewport(int, int, int, int, bool) @system @nogc nothrow;
void applyViewport(int x, int y, int width, int height, bool origin_top_left) @trusted @nogc nothrow {
    sg_apply_viewport(x, y, width, height, origin_top_left);
}
extern(C) void sg_apply_viewportf(float, float, float, float, bool) @system @nogc nothrow;
void applyViewportf(float x, float y, float width, float height, bool origin_top_left) @trusted @nogc nothrow {
    sg_apply_viewportf(x, y, width, height, origin_top_left);
}
extern(C) void sg_apply_scissor_rect(int, int, int, int, bool) @system @nogc nothrow;
void applyScissorRect(int x, int y, int width, int height, bool origin_top_left) @trusted @nogc nothrow {
    sg_apply_scissor_rect(x, y, width, height, origin_top_left);
}
extern(C) void sg_apply_scissor_rectf(float, float, float, float, bool) @system @nogc nothrow;
void applyScissorRectf(float x, float y, float width, float height, bool origin_top_left) @trusted @nogc nothrow {
    sg_apply_scissor_rectf(x, y, width, height, origin_top_left);
}
extern(C) void sg_apply_pipeline(Pipeline) @system @nogc nothrow;
void applyPipeline(Pipeline pip) @trusted @nogc nothrow {
    sg_apply_pipeline(pip);
}
extern(C) void sg_apply_bindings(const Bindings *) @system @nogc nothrow;
void applyBindings(Bindings bindings) @trusted @nogc nothrow {
    sg_apply_bindings(&bindings);
}
extern(C) void sg_apply_uniforms(ShaderStage, uint, const Range *) @system @nogc nothrow;
void applyUniforms(ShaderStage stage, uint ub_index, Range data) @trusted @nogc nothrow {
    sg_apply_uniforms(stage, ub_index, &data);
}
extern(C) void sg_draw(uint, uint, uint) @system @nogc nothrow;
void draw(uint base_element, uint num_elements, uint num_instances) @trusted @nogc nothrow {
    sg_draw(base_element, num_elements, num_instances);
}
extern(C) void sg_end_pass() @system @nogc nothrow;
void endPass() @trusted @nogc nothrow {
    sg_end_pass();
}
extern(C) void sg_commit() @system @nogc nothrow;
void commit() @trusted @nogc nothrow {
    sg_commit();
}
extern(C) Desc sg_query_desc() @system @nogc nothrow;
Desc queryDesc() @trusted @nogc nothrow {
    return sg_query_desc();
}
extern(C) Backend sg_query_backend() @system @nogc nothrow;
Backend queryBackend() @trusted @nogc nothrow {
    return sg_query_backend();
}
extern(C) Features sg_query_features() @system @nogc nothrow;
Features queryFeatures() @trusted @nogc nothrow {
    return sg_query_features();
}
extern(C) Limits sg_query_limits() @system @nogc nothrow;
Limits queryLimits() @trusted @nogc nothrow {
    return sg_query_limits();
}
extern(C) PixelformatInfo sg_query_pixelformat(PixelFormat) @system @nogc nothrow;
PixelformatInfo queryPixelformat(PixelFormat fmt) @trusted @nogc nothrow {
    return sg_query_pixelformat(fmt);
}
extern(C) ResourceState sg_query_buffer_state(Buffer) @system @nogc nothrow;
ResourceState queryBufferState(Buffer buf) @trusted @nogc nothrow {
    return sg_query_buffer_state(buf);
}
extern(C) ResourceState sg_query_image_state(Image) @system @nogc nothrow;
ResourceState queryImageState(Image img) @trusted @nogc nothrow {
    return sg_query_image_state(img);
}
extern(C) ResourceState sg_query_sampler_state(Sampler) @system @nogc nothrow;
ResourceState querySamplerState(Sampler smp) @trusted @nogc nothrow {
    return sg_query_sampler_state(smp);
}
extern(C) ResourceState sg_query_shader_state(Shader) @system @nogc nothrow;
ResourceState queryShaderState(Shader shd) @trusted @nogc nothrow {
    return sg_query_shader_state(shd);
}
extern(C) ResourceState sg_query_pipeline_state(Pipeline) @system @nogc nothrow;
ResourceState queryPipelineState(Pipeline pip) @trusted @nogc nothrow {
    return sg_query_pipeline_state(pip);
}
extern(C) ResourceState sg_query_pass_state(Pass) @system @nogc nothrow;
ResourceState queryPassState(Pass pass) @trusted @nogc nothrow {
    return sg_query_pass_state(pass);
}
extern(C) BufferInfo sg_query_buffer_info(Buffer) @system @nogc nothrow;
BufferInfo queryBufferInfo(Buffer buf) @trusted @nogc nothrow {
    return sg_query_buffer_info(buf);
}
extern(C) ImageInfo sg_query_image_info(Image) @system @nogc nothrow;
ImageInfo queryImageInfo(Image img) @trusted @nogc nothrow {
    return sg_query_image_info(img);
}
extern(C) SamplerInfo sg_query_sampler_info(Sampler) @system @nogc nothrow;
SamplerInfo querySamplerInfo(Sampler smp) @trusted @nogc nothrow {
    return sg_query_sampler_info(smp);
}
extern(C) ShaderInfo sg_query_shader_info(Shader) @system @nogc nothrow;
ShaderInfo queryShaderInfo(Shader shd) @trusted @nogc nothrow {
    return sg_query_shader_info(shd);
}
extern(C) PipelineInfo sg_query_pipeline_info(Pipeline) @system @nogc nothrow;
PipelineInfo queryPipelineInfo(Pipeline pip) @trusted @nogc nothrow {
    return sg_query_pipeline_info(pip);
}
extern(C) PassInfo sg_query_pass_info(Pass) @system @nogc nothrow;
PassInfo queryPassInfo(Pass pass) @trusted @nogc nothrow {
    return sg_query_pass_info(pass);
}
extern(C) BufferDesc sg_query_buffer_desc(Buffer) @system @nogc nothrow;
BufferDesc queryBufferDesc(Buffer buf) @trusted @nogc nothrow {
    return sg_query_buffer_desc(buf);
}
extern(C) ImageDesc sg_query_image_desc(Image) @system @nogc nothrow;
ImageDesc queryImageDesc(Image img) @trusted @nogc nothrow {
    return sg_query_image_desc(img);
}
extern(C) SamplerDesc sg_query_sampler_desc(Sampler) @system @nogc nothrow;
SamplerDesc querySamplerDesc(Sampler smp) @trusted @nogc nothrow {
    return sg_query_sampler_desc(smp);
}
extern(C) ShaderDesc sg_query_shader_desc(Shader) @system @nogc nothrow;
ShaderDesc queryShaderDesc(Shader shd) @trusted @nogc nothrow {
    return sg_query_shader_desc(shd);
}
extern(C) PipelineDesc sg_query_pipeline_desc(Pipeline) @system @nogc nothrow;
PipelineDesc queryPipelineDesc(Pipeline pip) @trusted @nogc nothrow {
    return sg_query_pipeline_desc(pip);
}
extern(C) PassDesc sg_query_pass_desc(Pass) @system @nogc nothrow;
PassDesc queryPassDesc(Pass pass) @trusted @nogc nothrow {
    return sg_query_pass_desc(pass);
}
extern(C) BufferDesc sg_query_buffer_defaults(const BufferDesc *) @system @nogc nothrow;
BufferDesc queryBufferDefaults(BufferDesc desc) @trusted @nogc nothrow {
    return sg_query_buffer_defaults(&desc);
}
extern(C) ImageDesc sg_query_image_defaults(const ImageDesc *) @system @nogc nothrow;
ImageDesc queryImageDefaults(ImageDesc desc) @trusted @nogc nothrow {
    return sg_query_image_defaults(&desc);
}
extern(C) SamplerDesc sg_query_sampler_defaults(const SamplerDesc *) @system @nogc nothrow;
SamplerDesc querySamplerDefaults(SamplerDesc desc) @trusted @nogc nothrow {
    return sg_query_sampler_defaults(&desc);
}
extern(C) ShaderDesc sg_query_shader_defaults(const ShaderDesc *) @system @nogc nothrow;
ShaderDesc queryShaderDefaults(ShaderDesc desc) @trusted @nogc nothrow {
    return sg_query_shader_defaults(&desc);
}
extern(C) PipelineDesc sg_query_pipeline_defaults(const PipelineDesc *) @system @nogc nothrow;
PipelineDesc queryPipelineDefaults(PipelineDesc desc) @trusted @nogc nothrow {
    return sg_query_pipeline_defaults(&desc);
}
extern(C) PassDesc sg_query_pass_defaults(const PassDesc *) @system @nogc nothrow;
PassDesc queryPassDefaults(PassDesc desc) @trusted @nogc nothrow {
    return sg_query_pass_defaults(&desc);
}
extern(C) Buffer sg_alloc_buffer() @system @nogc nothrow;
Buffer allocBuffer() @trusted @nogc nothrow {
    return sg_alloc_buffer();
}
extern(C) Image sg_alloc_image() @system @nogc nothrow;
Image allocImage() @trusted @nogc nothrow {
    return sg_alloc_image();
}
extern(C) Sampler sg_alloc_sampler() @system @nogc nothrow;
Sampler allocSampler() @trusted @nogc nothrow {
    return sg_alloc_sampler();
}
extern(C) Shader sg_alloc_shader() @system @nogc nothrow;
Shader allocShader() @trusted @nogc nothrow {
    return sg_alloc_shader();
}
extern(C) Pipeline sg_alloc_pipeline() @system @nogc nothrow;
Pipeline allocPipeline() @trusted @nogc nothrow {
    return sg_alloc_pipeline();
}
extern(C) Pass sg_alloc_pass() @system @nogc nothrow;
Pass allocPass() @trusted @nogc nothrow {
    return sg_alloc_pass();
}
extern(C) void sg_dealloc_buffer(Buffer) @system @nogc nothrow;
void deallocBuffer(Buffer buf) @trusted @nogc nothrow {
    sg_dealloc_buffer(buf);
}
extern(C) void sg_dealloc_image(Image) @system @nogc nothrow;
void deallocImage(Image img) @trusted @nogc nothrow {
    sg_dealloc_image(img);
}
extern(C) void sg_dealloc_sampler(Sampler) @system @nogc nothrow;
void deallocSampler(Sampler smp) @trusted @nogc nothrow {
    sg_dealloc_sampler(smp);
}
extern(C) void sg_dealloc_shader(Shader) @system @nogc nothrow;
void deallocShader(Shader shd) @trusted @nogc nothrow {
    sg_dealloc_shader(shd);
}
extern(C) void sg_dealloc_pipeline(Pipeline) @system @nogc nothrow;
void deallocPipeline(Pipeline pip) @trusted @nogc nothrow {
    sg_dealloc_pipeline(pip);
}
extern(C) void sg_dealloc_pass(Pass) @system @nogc nothrow;
void deallocPass(Pass pass) @trusted @nogc nothrow {
    sg_dealloc_pass(pass);
}
extern(C) void sg_init_buffer(Buffer, const BufferDesc *) @system @nogc nothrow;
void initBuffer(Buffer buf, BufferDesc desc) @trusted @nogc nothrow {
    sg_init_buffer(buf, &desc);
}
extern(C) void sg_init_image(Image, const ImageDesc *) @system @nogc nothrow;
void initImage(Image img, ImageDesc desc) @trusted @nogc nothrow {
    sg_init_image(img, &desc);
}
extern(C) void sg_init_sampler(Sampler, const SamplerDesc *) @system @nogc nothrow;
void initSampler(Sampler smg, SamplerDesc desc) @trusted @nogc nothrow {
    sg_init_sampler(smg, &desc);
}
extern(C) void sg_init_shader(Shader, const ShaderDesc *) @system @nogc nothrow;
void initShader(Shader shd, ShaderDesc desc) @trusted @nogc nothrow {
    sg_init_shader(shd, &desc);
}
extern(C) void sg_init_pipeline(Pipeline, const PipelineDesc *) @system @nogc nothrow;
void initPipeline(Pipeline pip, PipelineDesc desc) @trusted @nogc nothrow {
    sg_init_pipeline(pip, &desc);
}
extern(C) void sg_init_pass(Pass, const PassDesc *) @system @nogc nothrow;
void initPass(Pass pass, PassDesc desc) @trusted @nogc nothrow {
    sg_init_pass(pass, &desc);
}
extern(C) void sg_uninit_buffer(Buffer) @system @nogc nothrow;
void uninitBuffer(Buffer buf) @trusted @nogc nothrow {
    sg_uninit_buffer(buf);
}
extern(C) void sg_uninit_image(Image) @system @nogc nothrow;
void uninitImage(Image img) @trusted @nogc nothrow {
    sg_uninit_image(img);
}
extern(C) void sg_uninit_sampler(Sampler) @system @nogc nothrow;
void uninitSampler(Sampler smp) @trusted @nogc nothrow {
    sg_uninit_sampler(smp);
}
extern(C) void sg_uninit_shader(Shader) @system @nogc nothrow;
void uninitShader(Shader shd) @trusted @nogc nothrow {
    sg_uninit_shader(shd);
}
extern(C) void sg_uninit_pipeline(Pipeline) @system @nogc nothrow;
void uninitPipeline(Pipeline pip) @trusted @nogc nothrow {
    sg_uninit_pipeline(pip);
}
extern(C) void sg_uninit_pass(Pass) @system @nogc nothrow;
void uninitPass(Pass pass) @trusted @nogc nothrow {
    sg_uninit_pass(pass);
}
extern(C) void sg_fail_buffer(Buffer) @system @nogc nothrow;
void failBuffer(Buffer buf) @trusted @nogc nothrow {
    sg_fail_buffer(buf);
}
extern(C) void sg_fail_image(Image) @system @nogc nothrow;
void failImage(Image img) @trusted @nogc nothrow {
    sg_fail_image(img);
}
extern(C) void sg_fail_sampler(Sampler) @system @nogc nothrow;
void failSampler(Sampler smp) @trusted @nogc nothrow {
    sg_fail_sampler(smp);
}
extern(C) void sg_fail_shader(Shader) @system @nogc nothrow;
void failShader(Shader shd) @trusted @nogc nothrow {
    sg_fail_shader(shd);
}
extern(C) void sg_fail_pipeline(Pipeline) @system @nogc nothrow;
void failPipeline(Pipeline pip) @trusted @nogc nothrow {
    sg_fail_pipeline(pip);
}
extern(C) void sg_fail_pass(Pass) @system @nogc nothrow;
void failPass(Pass pass) @trusted @nogc nothrow {
    sg_fail_pass(pass);
}
extern(C) void sg_enable_frame_stats() @system @nogc nothrow;
void enableFrameStats() @trusted @nogc nothrow {
    sg_enable_frame_stats();
}
extern(C) void sg_disable_frame_stats() @system @nogc nothrow;
void disableFrameStats() @trusted @nogc nothrow {
    sg_disable_frame_stats();
}
extern(C) bool sg_frame_stats_enabled() @system @nogc nothrow;
bool frameStatsEnabled() @trusted @nogc nothrow {
    return sg_frame_stats_enabled();
}
extern(C) FrameStats sg_query_frame_stats() @system @nogc nothrow;
FrameStats queryFrameStats() @trusted @nogc nothrow {
    return sg_query_frame_stats();
}
extern(C) Context sg_setup_context() @system @nogc nothrow;
Context setupContext() @trusted @nogc nothrow {
    return sg_setup_context();
}
extern(C) void sg_activate_context(Context) @system @nogc nothrow;
void activateContext(Context ctx_id) @trusted @nogc nothrow {
    sg_activate_context(ctx_id);
}
extern(C) void sg_discard_context(Context) @system @nogc nothrow;
void discardContext(Context ctx_id) @trusted @nogc nothrow {
    sg_discard_context(ctx_id);
}
struct D3d11BufferInfo {
    const(void)* buf;
}
struct D3d11ImageInfo {
    const(void)* tex2d;
    const(void)* tex3d;
    const(void)* res;
    const(void)* srv;
}
struct D3d11SamplerInfo {
    const(void)* smp;
}
struct D3d11ShaderInfo {
    const(void)*[4] vs_cbufs;
    const(void)*[4] fs_cbufs;
    const(void)* vs;
    const(void)* fs;
}
struct D3d11PipelineInfo {
    const(void)* il;
    const(void)* rs;
    const(void)* dss;
    const(void)* bs;
}
struct D3d11PassInfo {
    const(void)*[4] color_rtv;
    const(void)*[4] resolve_rtv;
    const(void)* dsv;
}
struct MtlBufferInfo {
    const(void)*[2] buf;
    int active_slot;
}
struct MtlImageInfo {
    const(void)*[2] tex;
    int active_slot;
}
struct MtlSamplerInfo {
    const(void)* smp;
}
struct MtlShaderInfo {
    const(void)* vs_lib;
    const(void)* fs_lib;
    const(void)* vs_func;
    const(void)* fs_func;
}
struct MtlPipelineInfo {
    const(void)* rps;
    const(void)* dss;
}
struct WgpuBufferInfo {
    const(void)* buf;
}
struct WgpuImageInfo {
    const(void)* tex;
    const(void)* view;
}
struct WgpuSamplerInfo {
    const(void)* smp;
}
struct WgpuShaderInfo {
    const(void)* vs_mod;
    const(void)* fs_mod;
    const(void)* bgl;
}
struct WgpuPipelineInfo {
    const(void)* pip;
}
struct WgpuPassInfo {
    const(void)*[4] color_view;
    const(void)*[4] resolve_view;
    const(void)* ds_view;
}
struct GlBufferInfo {
    uint[2] buf;
    int active_slot;
}
struct GlImageInfo {
    uint[2] tex;
    uint tex_target;
    uint msaa_render_buffer;
    int active_slot;
}
struct GlSamplerInfo {
    uint smp;
}
struct GlShaderInfo {
    uint prog;
}
struct GlPassInfo {
    uint frame_buffer;
    uint[4] msaa_resolve_framebuffer;
}
extern(C) const(void)* sg_d3d11_device() @system @nogc nothrow;
const(void)* d3d11Device() @trusted @nogc nothrow {
    return sg_d3d11_device();
}
extern(C) const(void)* sg_d3d11_device_context() @system @nogc nothrow;
const(void)* d3d11DeviceContext() @trusted @nogc nothrow {
    return sg_d3d11_device_context();
}
extern(C) D3d11BufferInfo sg_d3d11_query_buffer_info(Buffer) @system @nogc nothrow;
D3d11BufferInfo d3d11QueryBufferInfo(Buffer buf) @trusted @nogc nothrow {
    return sg_d3d11_query_buffer_info(buf);
}
extern(C) D3d11ImageInfo sg_d3d11_query_image_info(Image) @system @nogc nothrow;
D3d11ImageInfo d3d11QueryImageInfo(Image img) @trusted @nogc nothrow {
    return sg_d3d11_query_image_info(img);
}
extern(C) D3d11SamplerInfo sg_d3d11_query_sampler_info(Sampler) @system @nogc nothrow;
D3d11SamplerInfo d3d11QuerySamplerInfo(Sampler smp) @trusted @nogc nothrow {
    return sg_d3d11_query_sampler_info(smp);
}
extern(C) D3d11ShaderInfo sg_d3d11_query_shader_info(Shader) @system @nogc nothrow;
D3d11ShaderInfo d3d11QueryShaderInfo(Shader shd) @trusted @nogc nothrow {
    return sg_d3d11_query_shader_info(shd);
}
extern(C) D3d11PipelineInfo sg_d3d11_query_pipeline_info(Pipeline) @system @nogc nothrow;
D3d11PipelineInfo d3d11QueryPipelineInfo(Pipeline pip) @trusted @nogc nothrow {
    return sg_d3d11_query_pipeline_info(pip);
}
extern(C) D3d11PassInfo sg_d3d11_query_pass_info(Pass) @system @nogc nothrow;
D3d11PassInfo d3d11QueryPassInfo(Pass pass) @trusted @nogc nothrow {
    return sg_d3d11_query_pass_info(pass);
}
extern(C) const(void)* sg_mtl_device() @system @nogc nothrow;
const(void)* mtlDevice() @trusted @nogc nothrow {
    return sg_mtl_device();
}
extern(C) const(void)* sg_mtl_render_command_encoder() @system @nogc nothrow;
const(void)* mtlRenderCommandEncoder() @trusted @nogc nothrow {
    return sg_mtl_render_command_encoder();
}
extern(C) MtlBufferInfo sg_mtl_query_buffer_info(Buffer) @system @nogc nothrow;
MtlBufferInfo mtlQueryBufferInfo(Buffer buf) @trusted @nogc nothrow {
    return sg_mtl_query_buffer_info(buf);
}
extern(C) MtlImageInfo sg_mtl_query_image_info(Image) @system @nogc nothrow;
MtlImageInfo mtlQueryImageInfo(Image img) @trusted @nogc nothrow {
    return sg_mtl_query_image_info(img);
}
extern(C) MtlSamplerInfo sg_mtl_query_sampler_info(Sampler) @system @nogc nothrow;
MtlSamplerInfo mtlQuerySamplerInfo(Sampler smp) @trusted @nogc nothrow {
    return sg_mtl_query_sampler_info(smp);
}
extern(C) MtlShaderInfo sg_mtl_query_shader_info(Shader) @system @nogc nothrow;
MtlShaderInfo mtlQueryShaderInfo(Shader shd) @trusted @nogc nothrow {
    return sg_mtl_query_shader_info(shd);
}
extern(C) MtlPipelineInfo sg_mtl_query_pipeline_info(Pipeline) @system @nogc nothrow;
MtlPipelineInfo mtlQueryPipelineInfo(Pipeline pip) @trusted @nogc nothrow {
    return sg_mtl_query_pipeline_info(pip);
}
extern(C) const(void)* sg_wgpu_device() @system @nogc nothrow;
const(void)* wgpuDevice() @trusted @nogc nothrow {
    return sg_wgpu_device();
}
extern(C) const(void)* sg_wgpu_queue() @system @nogc nothrow;
const(void)* wgpuQueue() @trusted @nogc nothrow {
    return sg_wgpu_queue();
}
extern(C) const(void)* sg_wgpu_command_encoder() @system @nogc nothrow;
const(void)* wgpuCommandEncoder() @trusted @nogc nothrow {
    return sg_wgpu_command_encoder();
}
extern(C) const(void)* sg_wgpu_render_pass_encoder() @system @nogc nothrow;
const(void)* wgpuRenderPassEncoder() @trusted @nogc nothrow {
    return sg_wgpu_render_pass_encoder();
}
extern(C) WgpuBufferInfo sg_wgpu_query_buffer_info(Buffer) @system @nogc nothrow;
WgpuBufferInfo wgpuQueryBufferInfo(Buffer buf) @trusted @nogc nothrow {
    return sg_wgpu_query_buffer_info(buf);
}
extern(C) WgpuImageInfo sg_wgpu_query_image_info(Image) @system @nogc nothrow;
WgpuImageInfo wgpuQueryImageInfo(Image img) @trusted @nogc nothrow {
    return sg_wgpu_query_image_info(img);
}
extern(C) WgpuSamplerInfo sg_wgpu_query_sampler_info(Sampler) @system @nogc nothrow;
WgpuSamplerInfo wgpuQuerySamplerInfo(Sampler smp) @trusted @nogc nothrow {
    return sg_wgpu_query_sampler_info(smp);
}
extern(C) WgpuShaderInfo sg_wgpu_query_shader_info(Shader) @system @nogc nothrow;
WgpuShaderInfo wgpuQueryShaderInfo(Shader shd) @trusted @nogc nothrow {
    return sg_wgpu_query_shader_info(shd);
}
extern(C) WgpuPipelineInfo sg_wgpu_query_pipeline_info(Pipeline) @system @nogc nothrow;
WgpuPipelineInfo wgpuQueryPipelineInfo(Pipeline pip) @trusted @nogc nothrow {
    return sg_wgpu_query_pipeline_info(pip);
}
extern(C) WgpuPassInfo sg_wgpu_query_pass_info(Pass) @system @nogc nothrow;
WgpuPassInfo wgpuQueryPassInfo(Pass pass) @trusted @nogc nothrow {
    return sg_wgpu_query_pass_info(pass);
}
extern(C) GlBufferInfo sg_gl_query_buffer_info(Buffer) @system @nogc nothrow;
GlBufferInfo glQueryBufferInfo(Buffer buf) @trusted @nogc nothrow {
    return sg_gl_query_buffer_info(buf);
}
extern(C) GlImageInfo sg_gl_query_image_info(Image) @system @nogc nothrow;
GlImageInfo glQueryImageInfo(Image img) @trusted @nogc nothrow {
    return sg_gl_query_image_info(img);
}
extern(C) GlSamplerInfo sg_gl_query_sampler_info(Sampler) @system @nogc nothrow;
GlSamplerInfo glQuerySamplerInfo(Sampler smp) @trusted @nogc nothrow {
    return sg_gl_query_sampler_info(smp);
}
extern(C) GlShaderInfo sg_gl_query_shader_info(Shader) @system @nogc nothrow;
GlShaderInfo glQueryShaderInfo(Shader shd) @trusted @nogc nothrow {
    return sg_gl_query_shader_info(shd);
}
extern(C) GlPassInfo sg_gl_query_pass_info(Pass) @system @nogc nothrow;
GlPassInfo glQueryPassInfo(Pass pass) @trusted @nogc nothrow {
    return sg_gl_query_pass_info(pass);
}

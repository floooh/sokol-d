// machine generated, do not edit

module sokol.audio;

// helper function to convert a C string to a D string
string cStrTod(const(char*) c_str) {
    import std.conv: to;
    return c_str.to!string;
}
enum LogItem {
    OK,
    MALLOC_FAILED,
    ALSA_SND_PCM_OPEN_FAILED,
    ALSA_FLOAT_SAMPLES_NOT_SUPPORTED,
    ALSA_REQUESTED_BUFFER_SIZE_NOT_SUPPORTED,
    ALSA_REQUESTED_CHANNEL_COUNT_NOT_SUPPORTED,
    ALSA_SND_PCM_HW_PARAMS_SET_RATE_NEAR_FAILED,
    ALSA_SND_PCM_HW_PARAMS_FAILED,
    ALSA_PTHREAD_CREATE_FAILED,
    WASAPI_CREATE_EVENT_FAILED,
    WASAPI_CREATE_DEVICE_ENUMERATOR_FAILED,
    WASAPI_GET_DEFAULT_AUDIO_ENDPOINT_FAILED,
    WASAPI_DEVICE_ACTIVATE_FAILED,
    WASAPI_AUDIO_CLIENT_INITIALIZE_FAILED,
    WASAPI_AUDIO_CLIENT_GET_BUFFER_SIZE_FAILED,
    WASAPI_AUDIO_CLIENT_GET_SERVICE_FAILED,
    WASAPI_AUDIO_CLIENT_SET_EVENT_HANDLE_FAILED,
    WASAPI_CREATE_THREAD_FAILED,
    AAUDIO_STREAMBUILDER_OPEN_STREAM_FAILED,
    AAUDIO_PTHREAD_CREATE_FAILED,
    AAUDIO_RESTARTING_STREAM_AFTER_ERROR,
    USING_AAUDIO_BACKEND,
    AAUDIO_CREATE_STREAMBUILDER_FAILED,
    USING_SLES_BACKEND,
    SLES_CREATE_ENGINE_FAILED,
    SLES_ENGINE_GET_ENGINE_INTERFACE_FAILED,
    SLES_CREATE_OUTPUT_MIX_FAILED,
    SLES_MIXER_GET_VOLUME_INTERFACE_FAILED,
    SLES_ENGINE_CREATE_AUDIO_PLAYER_FAILED,
    SLES_PLAYER_GET_PLAY_INTERFACE_FAILED,
    SLES_PLAYER_GET_VOLUME_INTERFACE_FAILED,
    SLES_PLAYER_GET_BUFFERQUEUE_INTERFACE_FAILED,
    COREAUDIO_NEW_OUTPUT_FAILED,
    COREAUDIO_ALLOCATE_BUFFER_FAILED,
    COREAUDIO_START_FAILED,
    BACKEND_BUFFER_SIZE_ISNT_MULTIPLE_OF_PACKET_SIZE,
}
struct Logger {
    extern(C) void function(const(char*), uint, uint, const(char*), uint, const(char*), void*) func;
    void* user_data;
}
struct Allocator {
    extern(C) void* function(size_t, void*) alloc_fn;
    extern(C) void function(void*, void*) free_fn;
    void* user_data;
}
struct Desc {
    int sample_rate;
    int num_channels;
    int buffer_frames;
    int packet_frames;
    int num_packets;
    extern(C) void function(float *, int, int) stream_cb;
    extern(C) void function(float *, int, int, void*) stream_userdata_cb;
    void* user_data;
    Allocator allocator;
    Logger logger;
}
extern(C) void saudio_setup(const Desc *) @system @nogc nothrow;
void setup(Desc desc) @trusted @nogc nothrow {
    saudio_setup(&desc);
}
extern(C) void saudio_shutdown() @system @nogc nothrow;
void shutdown() @trusted @nogc nothrow {
    saudio_shutdown();
}
extern(C) bool saudio_isvalid() @system @nogc nothrow;
bool isvalid() @trusted @nogc nothrow {
    return saudio_isvalid();
}
extern(C) void* saudio_userdata() @system @nogc nothrow;
void* userdata() @trusted @nogc nothrow {
    return saudio_userdata();
}
extern(C) Desc saudio_query_desc() @system @nogc nothrow;
Desc queryDesc() @trusted @nogc nothrow {
    return saudio_query_desc();
}
extern(C) int saudio_sample_rate() @system @nogc nothrow;
int sampleRate() @trusted @nogc nothrow {
    return saudio_sample_rate();
}
extern(C) int saudio_buffer_frames() @system @nogc nothrow;
int bufferFrames() @trusted @nogc nothrow {
    return saudio_buffer_frames();
}
extern(C) int saudio_channels() @system @nogc nothrow;
int channels() @trusted @nogc nothrow {
    return saudio_channels();
}
extern(C) bool saudio_suspended() @system @nogc nothrow;
bool suspended() @trusted @nogc nothrow {
    return saudio_suspended();
}
extern(C) int saudio_expect() @system @nogc nothrow;
int expect() @trusted @nogc nothrow {
    return saudio_expect();
}
extern(C) int saudio_push(const float *, int) @system @nogc nothrow;
int push(const float * frames, int num_frames) @trusted @nogc nothrow {
    return saudio_push(frames, num_frames);
}

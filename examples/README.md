#### Available examples:

> [!TIP]
> For WebAssembly builds (WebGL2/WebGPU), add `--arch wasm32-unknown-emscripten` flag (requires LDC2)

>[!NOTE]
> `dub` by default builds & runs the application.
> For build-only, use `dub build` instead.

Available examples:
- blend
- box3d
- bufferoffsets
- clear
- cube
- debugtext
- droptest
- framebuffer
- imgui
- instancing
- instancingcompute
- letterbox
- nuklear
- saudio
- sglcontext
- sglpoints
- triangle

Build command format:
```console
dub :[example] -c [native|vulkan|wasm|wgpu] -b [debug|release|release-nobounds|release-betterc]
```

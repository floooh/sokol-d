//------------------------------------------------------------------------------
//  package.d
//
//  Box3D physics engine bindings for D via ImportC, following the same
//  approach as the nuklear and imgui bindings. The C shim in c/box3dc.c is
//  compiled by the D compiler as an ImportC module, importing the vendored
//  Box3D headers in vendor/box3d/include.
//------------------------------------------------------------------------------
module box3d;

/// Box3D bindings for D (@system)
public import box3d.c.box3dc;
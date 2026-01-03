# engine.zig — Native Zig helpers

## Overview
This file (`engine.zig`) provides small native helpers exported from Zig for use by other languages (for example, C# via `DllImport`). It includes a vectorized summation function and a simple print helper.

## Exports
- `vectorizedSum16(ptr: [*]const f32, len: usize) callconv(.c) f32` — Exposed with `export` and uses an 8-wide SIMD vector (`@Vector(8, f32)`) to accelerate summation of a contiguous `f32` slice.
- `printAnotherMessage(writer: anytype)` — A simple public helper to print a message via a provided writer.

## Build
Build a dynamic library (DLL) with Zig from the project root:

```bash
zig build-lib src/engine.zig -dynamic -O ReleaseFast
```

Example (PowerShell):

```powershell
E:\path\to\zig.exe build-lib .\src\engine.zig -dynamic -O ReleaseFast
```

The produced dynamic library will be named similar to `engine.dll` on Windows. Place it next to your executable or ensure it's on the `PATH`.

## C# usage example
Import and call `vectorizedSum16` from C#:

```csharp
using System;
using System.Runtime.InteropServices;

class Native {
    [DllImport("engine", CallingConvention = CallingConvention.Cdecl)]
    public static extern float vectorizedSum16([In] float[] ptr, UIntPtr len);
}

class Program {
    static void Main() {
        float[] data = new float[] { 1f, 2f, 3f, 4f, 5f };
        float sum = Native.vectorizedSum16(data, (UIntPtr)data.Length);
        Console.WriteLine($"Sum = {sum}");
    }
}
```

Notes:
- Use `CallingConvention.Cdecl` to match `callconv(.c)` in Zig.
- Ensure the DLL is discoverable by the runtime (same folder or on `PATH`).
- When passing arrays from managed code, pin or otherwise ensure the memory is stable while Zig accesses it.

## Tips
- Adjust optimization flags or target triples if building for other platforms.
- If you need different symbol names or conventions, update the `export` and `callconv` accordingly in `engine.zig`.

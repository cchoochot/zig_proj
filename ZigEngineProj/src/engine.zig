const std = @import("std");

// We export the function so the C# DLLImport can find it
export fn vectorizedSum16(ptr: [*]const f32, len: usize) callconv(.c) f32 {
    const data = ptr[0..len]; // Turn the raw pointer back into a safe Zig slice
    const factor = 8;
    const Vec8 = @Vector(factor, f32);

    var v_sum: Vec8 = @splat(0.0);
    var i: usize = 0;

    while (i + factor <= data.len) : (i += factor) {
        const vector: Vec8 = data[i..][0..factor].*;
        v_sum += vector;
    }

    var total: f32 = @reduce(.Add, v_sum);
    while (i < data.len) : (i += 1) {
        total += data[i];
    }
    return total;
}

pub fn printAnotherMessage(writer: anytype) !void {
    try writer.print("This is another message from Zig!\n", .{});
}

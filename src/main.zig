const std = @import("std");
const detachVsJoin = @import("DetachVsJoin.zig").main;
const forLoopElse = @import("ForLoopElse.zig").main;
const window = @import("Windows/Windows.zig").main;

pub fn main() !void {
    // try detachVsJoin();
    // forLoopElse();

    window();
    // std.debug.print("Result: {}\n", .{result});
}

const detachVsJoin = @import("DetachVsJoin.zig").main;
const forLoopElse = @import("ForLoopElse.zig").main;

pub fn main() !void {
    // try detachVsJoin();
    forLoopElse();
}

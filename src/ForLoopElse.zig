const std = @import("std");

pub fn main() void {
    const n_loops: u32 = 1_000_000_000;

    const s1 = std.time.nanoTimestamp();
    const out = loop1(n_loops);
    const e1 = std.time.nanoTimestamp();
    const t1 = e1 - s1;

    const s2 = std.time.nanoTimestamp();
    const out2 = loop2(n_loops);
    const e2 = std.time.nanoTimestamp();
    const t2 = e2 - s2;

    std.debug.print("Out: {}-{}\n", .{ out, out2 });
    const ans: u32 = if (t1 < t2) 1 else 2;
    std.debug.print("{} Won!\n", .{ans});

    const ans2 = @as(f128, @floatFromInt(t1 - t2)) / @as(f128, @floatFromInt(t2)) * 100;
    std.debug.print("Time Diff: {:.2}!\n", .{ans2});
    // difference of 3-6% performance
}

fn loop1(n_loops: u32) u32 {
    var sol: u32 = 0;
    for (0..n_loops) |i| {
        sol +%= if (i < n_loops - 1) @truncate(i) else 2;
    }
    return sol;
}

fn loop2(n_loops: u32) u32 {
    var sol: u32 = 0;
    for (0..n_loops - 1) |i| {
        sol +%= @truncate(i);
    } else sol +%= 2;
    return sol;
}

const std = @import("std");
const N_THREADS: u8 = 12;
const N_ITERS: u16 = 500;

// Joining Threads has greater overhead than detach + vectorized bools to signal when a thread completes

pub fn main() !void {
    const tj1 = try timer(joins);
    const td1 = try timer(detachs);

    std.debug.print("T-Join: {}\n", .{tj1});
    std.debug.print("T-Detach: {}\n", .{td1});

    const td2 = try timer(detachs);
    const tj2 = try timer(joins);

    std.debug.print("T-Detach: {}\n", .{td2});
    std.debug.print("T-Join: {}\n", .{tj2});
}

fn joins() !void {
    var threads: [12]std.Thread = undefined;

    inline for (0..12) |i| {
        threads[i] = try std.Thread.spawn(.{}, fibJoin, .{});
    }

    defer inline for (0..12) |i| threads[i].join();
}

fn fib(n: u64) u64 {
    var a: u64 = 0;
    var b: u64 = 1;
    for (0..n) |_| {
        const c = b;
        b +%= a;
        a = c;
    }
    return b;
}

fn fibJoin() void {
    _ = fib(N_ITERS);
}

fn detachs() !void {
    var threads: [N_THREADS]std.Thread = undefined;
    var is_complete = [_]bool{false} ** N_THREADS;
    const trues: @Vector(N_THREADS, bool) = @splat(true);

    inline for (0..N_THREADS) |i| {
        threads[i] = try std.Thread.spawn(.{}, fibDetach, .{&is_complete[i]});
    }

    defer inline for (0..N_THREADS) |i| threads[i].detach();

    while (true) {
        const v = @as(@Vector(N_THREADS, bool), is_complete);
        if (@reduce(.And, v == trues)) break;
    }
}

fn fibDetach(is_complete: *bool) void {
    _ = fib(N_ITERS);
    is_complete.* = true;
}

fn timer(fn1: anytype) !i128 {
    const t1 = std.time.nanoTimestamp();
    for (0..1_000) |_| {
        _ = try fn1();
    }
    const t2 = std.time.nanoTimestamp();
    return @divFloor((t2 - t1), 1_000);
}

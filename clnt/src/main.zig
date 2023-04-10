const std = @import("std");

const zmq = @cImport({
    @cInclude("zmq.h");
});

pub fn main() anyerror!void {
    std.log.info("Zmq Client Hello", .{});
    const ctx = zmq.zmq_ctx_new();
    const requester = zmq.zmq_socket(ctx, zmq.ZMQ_REQ);
    _ = zmq.zmq_connect(requester, "tcp://localhost:5555");
    while (true) {
        var buffer: [10:0]u8 = undefined;
        _ = zmq.zmq_send(requester, "hello", 5, 0);
        _ = zmq.zmq_recv(requester, @ptrCast(*anyopaque, &buffer), 10, 0);
        std.debug.print("{s}", .{buffer});
    }
}

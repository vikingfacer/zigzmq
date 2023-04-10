const std = @import("std");

const zmq = @cImport({
    @cInclude("zmq.h");
});

const binderr = error{
    CouldNotBind,
};

pub fn main() anyerror!void {
    std.log.info("server Hello", .{});
    const ctx = zmq.zmq_ctx_new();
    const responder = zmq.zmq_socket(ctx, zmq.ZMQ_REP);
    if (0 != zmq.zmq_bind(responder, "tcp://*:5555")) {
        return binderr.CouldNotBind;
    }
    while (true) {
        var buffer: [10:0]u8 = undefined;
        _ = zmq.zmq_recv(responder, &buffer, 10, 0);
        std.debug.print("{s}", .{buffer});
        _ = zmq.zmq_send(responder, "World", 5, 0);
    }
}

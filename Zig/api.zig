const std = @import("std");
const net = std.net;
const rand = std.rand;

const PORT = 8106;
const imagenes = [_][]const u8{
    "https://picsum.photos/800/600?random=2700",
    "https://picsum.photos/800/600?random=2701",
    "https://picsum.photos/800/600?random=2702",
    "https://picsum.photos/800/600?random=2703",
    "https://picsum.photos/800/600?random=2704",
};

pub fn main() !void {
    var server = try net.Address.parseIp("127.0.0.1", PORT);
    var listener = try server.listen(.{});
    defer listener.deinit();

    std.debug.print("API en Zig escuchando en http://localhost:{d}\n", .{PORT});

    var prng = std.rand.DefaultPrng.init(@intCast(std.time.timestamp()));
    const random = prng.random();

    while (true) {
        var client = try listener.accept();
        defer client.stream.close();

        var buffer: [4096]u8 = undefined;
        _ = try client.stream.read(&buffer);

        const idx = random.uintLessThan(usize, imagenes.len);
        const imagen = imagenes[idx];

        const response = try std.fmt.bufPrint(&buffer,
            "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n\r\n{{\"imagen_url\":\"{s}\",\"estado\":\"ok\"}}",
            .{imagen}
        );

        _ = try client.stream.write(response);
    }
}

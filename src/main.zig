const std = @import("std");
const zorg = @import("zorg");
const Actor = zorg.Actor;
const Engine = zorg.Engine;
const Message = zorg.Message;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var engine = Engine.init(allocator);

    try engine.addActor(Actor.init(allocator));
    const actor = &engine.actors.items[engine.actors.items.len - 1];

    const script = [_]Message{ .Increment, .Increment, .Print, .Increment, .Print };
    for (script) |msg| {
        try actor.send(msg);
    }

    actor.run();

    while (engine.actors.items.len > 0) {
        var actor2 = engine.actors.pop().?;
        actor2.deinit();
    }
    engine.deinit();
}

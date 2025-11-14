const std = @import("std");
const zorg = @import("zorg");
const Actor = zorg.Actor;

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var counter_actor = Actor.init(arena.allocator());
    defer counter_actor.deinit();

    try counter_actor.send(.Increment);
    try counter_actor.send(.Increment);
    try counter_actor.send(.Print);

    counter_actor.run();
}

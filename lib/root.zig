const std = @import("std");

pub const Message = union(enum) {
    Increment: void,
    Print: void,
};

const Inbox = std.ArrayList(Message);

pub const Actor = struct {
    allocator: std.mem.Allocator,
    counter: u32,
    inbox: Inbox,

    pub fn init(allocator: std.mem.Allocator) Actor {
        return .{
            .allocator = allocator,
            .counter = 0,
            .inbox = Inbox.empty,
        };
    }

    pub fn deinit(self: *Actor) void {
        self.inbox.deinit(self.allocator);
    }

    pub fn send(self: *Actor, msg: Message) !void {
        try self.inbox.append(self.allocator, msg);
    }

    pub fn run(self: *Actor) void {
        while (self.inbox.items.len > 0) {
            const msg = self.inbox.orderedRemove(0);
            self.handle(msg);
        }
    }

    fn handle(self: *Actor, msg: Message) void {
        switch (msg) {
            .Increment => self.counter += 1,
            .Print => std.debug.print("This is my counter: {d}\n", .{self.counter}),
        }
    }
};

pub const Engine = struct {
    actors: std.ArrayList(Actor),
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) Engine {
        return .{
            .allocator = allocator,
            .actors = std.ArrayList(Actor).empty,
        };
    }

    pub fn deinit(self: *Engine) void {
        self.actors.deinit(self.allocator);
    }

    pub fn addActor(self: *Engine, actor: Actor) !void {
        try self.actors.append(self.allocator, actor);
    }

    pub fn removeActor(self: *Engine) void {
        self.actors.pop();
    }
};

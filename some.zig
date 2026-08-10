const std = @import("std");
const Io = std.Io; 
const D = @embedFile("README.md");

pub fn main(init: std.process.Init) !void {
    try Io.File.stdout().writeStreamingAll(init.io, D);
} 

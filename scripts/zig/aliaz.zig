const std = @import("std");
const print = std.debug.print;

const regex = @import("regex");

const TEAL = "\x1b[38;2;78;201;176m";
const GREEN = "\x1b[0;32m";
const PINK = "\x1b[38;5;213m";
const YELLOW = "\x1b[0;33m";
const NC = "\x1b[0m";

const pattern: []const u8 = "^\\s*alias\\s+(\\S+)=['\"]([^'\"]*)['\"](\\s+(#.*))?$";
const Alias = struct {
    name: []const u8,
    command: []const u8,
    description: ?[]const u8,
};

const Shell = enum { bash, zsh, fish };
const ShellConfig = struct {
    shell: Shell,
    locations: []const []const u8,
};
const SHELL_CONFIGS = [_]ShellConfig{
    .{
        .shell = .bash,
        .locations = &[_][]const u8{
            "~/.bashrc",
            "~/.bash_aliases",
        },
    },
    .{
        .shell = .zsh,
        .locations = &[_][]const u8{
            "~/.zshrc",
            "~/.aliases",
        },
    },
    .{
        .shell = .fish,
        .locations = &[_][]const u8{
            "~/.config/fish/conf.d/aliases.fish",
            "~/.config/fish/config.fish",
        },
    },
};

pub fn getShell(allocator: std.mem.Allocator) !?ShellConfig {
    const shell_env = std.process.getEnvVarOwned(allocator, "SHELL") catch |err| {
        print("Could not get SHELL: {}\n", .{err});
        return null;
    };
    defer allocator.free(shell_env);

    for (SHELL_CONFIGS) |config| {
        if (std.mem.indexOf(u8, shell_env, @tagName(config.shell)) != null) {
            return config;
        }
    }
    return null;
}

pub fn expandHomePath(allocator: std.mem.Allocator, path: []const u8) ![]u8 {
    if (path.len > 0 and path[0] == '~') {
        const home = std.process.getEnvVarOwned(allocator, "HOME") catch |err| {
            print("Could not get HOME: {}\n", .{err});
            return error.HomeNotFound;
        };
        return std.fmt.allocPrint(allocator, "{s}{s}", .{ home, path[1..] });
    }

    return allocator.dupe(u8, path);
}

pub fn checkValidFile(path: []const u8) !?std.fs.File {
    std.fs.accessAbsolute(path, .{}) catch |err| {
        if (err == error.FileNotFound) {
            return null;
        }
        return err;
    };
    const file = try std.fs.openFileAbsolute(path, .{});
    const metadata = try file.stat();
    if (metadata.size == 0) {
        file.close();
        return null;
    }

    return file;
}

pub fn returnColor(allocator: std.mem.Allocator, color: []const u8, text: []const u8) ![]const u8 {
    return std.fmt.allocPrint(allocator, "{s}{s}{s}", .{ color, text, NC });
}

pub fn formatAndPrintAliases(allocator: std.mem.Allocator, aliases: std.ArrayList(Alias)) !void {
    var max_name_len: usize = 0;
    var max_cmd_len: usize = 0;
    for (aliases.items) |alias| {
        max_name_len = @max(max_name_len, alias.name.len + 1);
        max_cmd_len = @max(max_cmd_len, alias.command.len + 1);
    }

    for (aliases.items) |alias| {
        const name = try returnColor(allocator, TEAL, alias.name);
        const command = try returnColor(allocator, GREEN, alias.command);

        const name_padding = try allocator.alloc(u8, max_name_len - alias.name.len);
        @memset(name_padding, ' ');
        const cmd_padding = try allocator.alloc(u8, max_cmd_len - alias.command.len);
        @memset(cmd_padding, ' ');

        if (alias.description) |desc| {
            var comment_text: []const u8 = "";
            if (desc.len > 0) {
                const hash_pos = std.mem.indexOf(u8, desc, "#") orelse 0;
                if (hash_pos + 1 < desc.len) {
                    comment_text = std.mem.trim(u8, desc[hash_pos + 1 ..], " \t");
                }
            }

            const comment = try returnColor(allocator, YELLOW, comment_text);
            const hash = try returnColor(allocator, PINK, "#");
            print("{s}{s}{s}{s}{s} {s}\n", .{ name, name_padding, command, cmd_padding, hash, comment });
        } else {
            print("{s}{s}{s}\n", .{ name, name_padding, command });
        }
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const args = try std.process.argsAlloc(allocator);
    const filter = if (args.len > 1) args[1] else null;
    const shell = try getShell(allocator) orelse {
        print("Could not get shell\n", .{});
        return;
    };

    var aliases = std.ArrayList(Alias).init(allocator);
    var aliases_file: ?std.fs.File = null;

    for (shell.locations) |loc| {
        const expanded_path = try expandHomePath(allocator, loc);
        const maybe_file = try checkValidFile(expanded_path) orelse {
            print("File does not exist or is empty\n", .{});
            continue;
        };

        aliases_file = maybe_file;
        break;
    }

    if (aliases_file == null) return;
    defer aliases_file.?.close();

    var re = try regex.Regex.compile(allocator, pattern);
    defer re.deinit();

    var buf_reader = std.io.bufferedReader(aliases_file.?.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (try re.captures(line)) |caps_const| {
            var caps = caps_const;

            const name = caps.sliceAt(1) orelse continue;
            if (filter != null and std.mem.indexOf(u8, name, filter.?) == null) continue;
            const cmd = caps.sliceAt(2) orelse continue;
            var comment: ?[]const u8 = null;

            if (caps.len() > 4) {
                if (caps.boundsAt(4)) |bounds| {
                    if (bounds.lower < line.len and bounds.upper <= line.len) {
                        comment = try allocator.dupe(u8, caps.sliceAt(4) orelse "");
                    }
                }
            }

            try aliases.append(Alias{
                .name = try allocator.dupe(u8, name),
                .command = try allocator.dupe(u8, cmd),
                .description = comment,
            });
        }
    }

    if (aliases.items.len != 0) {
        std.mem.sort(Alias, aliases.items, {}, struct {
            fn lessThan(_: void, a: Alias, b: Alias) bool {
                return std.mem.lessThan(u8, a.name, b.name);
            }
        }.lessThan);
        try formatAndPrintAliases(allocator, aliases);
    }
}

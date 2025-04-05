#!/usr/bin/env python3
import os, re, sys

TEAL = '\033[38;2;78;201;176m'
GREEN = '\033[0;32m'
PINK = '\033[38;5;213m'
YELLOW = '\033[0;33m'
NC = '\033[0m'

def extract(file_path, filter=None):
    lines = []

    with open(file_path, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            match = re.match(r'^\s*alias\s+([^=]+)=(.+?)(\s+#\s*(.*))?$', line)
            if match:
                name = match.group(1).strip()
                command = match.group(2).strip()
                description = match.group(4) or ""
                command = re.sub(r'^[\'"]|[\'"]$', '', command)

                if filter and filter.lower() not in name.lower():
                    continue

                lines.append((name, command, description))

    return sorted(lines)

def display(aliases):
    max_name_len = max(len(name) for name, _, _ in aliases) if aliases else 4
    max_cmd_len = min(80, max(len(cmd[:80]) for _, cmd, _ in aliases) if aliases else 7)

    for name, command, description in aliases:
        if len(command) > max_cmd_len:
            command = command[:max_cmd_len-3] + "..."

        desc_output = ""
        if description:
            desc_output = f"  {PINK}#{NC} {YELLOW}{description}{NC}"

        print(f"{TEAL}{name:<{max_name_len}}  {NC}{GREEN}{command:<{max_cmd_len}}{desc_output}{NC}")

def main():
    filter = sys.argv[1] if len(sys.argv) > 1 else None
    aliases = extract(os.path.join(os.path.expanduser("~"), ".config/fish/conf.d/aliases.fish"), filter)
    display(aliases)

if __name__ == "__main__":
    main()

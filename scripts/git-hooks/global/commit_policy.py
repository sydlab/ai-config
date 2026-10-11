"""Commit message policy shared by the global hooks.

Usage:
  commit_policy.py check FILE|-    exit 1 and explain on stderr if the message violates policy
  commit_policy.py strip SRC DST   write SRC to DST without trailers and tool footers
"""

import re
import sys

MAX_SUBJECT = 120

KNOWN_TRAILER = re.compile(
    r"(?i)^(Co-authored-by|Signed-off-by|Made-with|Helped-by|Reviewed-by|"
    r"Acked-by|Reported-by|Refers-to|See-also|Thanks-to|"
    r"Fixes|Closes|Resolves)\b",
)
BANNED = re.compile(
    r"(?i)\b(cursor|composer|claude|copilot|made-with)\b|co-authored-by",
)
CONVENTIONAL = re.compile(r"^[a-z][a-z0-9-]*(\([^)]+\))?:\s+\S")
GENERATED = re.compile(r'^(Merge |Revert "|(fixup|squash|amend)! )')
SCISSORS = "# ------------------------ >8 ------------------------"


def fail(reason, line=None):
    print(f"commit policy: {reason}", file=sys.stderr)
    if line is not None:
        print(f"  > {line}", file=sys.stderr)
    return 1


def message_lines(text):
    """Non-blank lines git would keep: comments and anything below the scissors line are dropped."""
    lines = []
    for line in text.splitlines():
        if line.startswith(SCISSORS):
            break
        if line.startswith("#") or not line.strip():
            continue
        lines.append(line)
    return lines


def check(text):
    lines = message_lines(text)
    if not lines:
        return fail("empty commit message")

    for i, line in enumerate(lines, start=1):
        if i > 1 and KNOWN_TRAILER.match(line.strip()):
            return fail(f"line {i}: git trailers are not allowed", line)
        if BANNED.search(line):
            return fail(f"line {i}: Cursor/agent references are not allowed", line)

    subject = lines[0]
    if GENERATED.match(subject):
        return 0
    if len(subject) > MAX_SUBJECT:
        return fail(f"subject exceeds {MAX_SUBJECT} characters ({len(subject)})", subject)
    if not CONVENTIONAL.match(subject):
        return fail("subject should look like: type: summary  or  type(scope): summary", subject)
    return 0


def strip(text):
    """Drop trailers and banned lines. The first line is kept so check() can reject it with a reason."""
    body = []
    for i, line in enumerate(text.splitlines()):
        if i > 0 and (KNOWN_TRAILER.match(line.strip()) or BANNED.search(line)):
            continue
        body.append(line.rstrip())

    while body and not body[-1].strip():
        body.pop()

    return "\n".join(body) + "\n" if body else ""


def read(path):
    if path == "-":
        return sys.stdin.buffer.read().decode("utf-8", errors="replace")
    with open(path, encoding="utf-8", errors="replace") as f:
        return f.read()


def main(argv):
    if len(argv) == 2 and argv[0] == "check":
        return check(read(argv[1]))
    if len(argv) == 3 and argv[0] == "strip":
        with open(argv[2], "w", encoding="utf-8") as f:
            f.write(strip(read(argv[1])))
        return 0
    print(__doc__, file=sys.stderr)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

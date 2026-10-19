#!/usr/bin/env python3
"""Download all comments of a YouTube video and write them to ./<datetime>_<title>.txt.

Each comment is one line, `author: content`. Replies are indented below their parent.
"""

import argparse
import json
import re
import subprocess
import sys
import tempfile
from datetime import datetime
from pathlib import Path

INDENT = "  "
# Matches yt-dlp lines like "Downloading comment API JSON page 3 (60/~41171)".
PROGRESS_RE = re.compile(r"\((\d+)/~(\d+)\)")


def fetch_info(url):
    """Run yt-dlp and show comment download progress on stderr.

    yt-dlp prints progress only when it does not dump JSON to stdout,
    so the info JSON goes to a temporary file instead.
    """
    with tempfile.TemporaryDirectory() as tmp:
        process = subprocess.Popen(
            [
                "yt-dlp",
                "--skip-download",
                "--write-comments",
                "--no-playlist",
                "--js-runtimes",
                "node",
                "--newline",
                "--output",
                str(Path(tmp) / "video"),
                url,
            ],
            stdout=subprocess.PIPE,
            text=True,
        )
        for line in process.stdout:
            match = PROGRESS_RE.search(line)
            if match:
                show_progress(int(match[1]), int(match[2]))
        process.wait()
        print(file=sys.stderr)
        if process.returncode != 0:
            sys.exit(process.returncode)
        return json.loads((Path(tmp) / "video.info.json").read_text(encoding="utf-8"))


def show_progress(done, total, width=30):
    total = max(total, done, 1)
    filled = width * done // total
    bar = "#" * filled + "-" * (width - filled)
    print(f"\r[{bar}] {done}/~{total} comments", end="", file=sys.stderr, flush=True)


def build_tree(comments):
    """Convert the flat yt-dlp comment list into nested author/content/replies nodes."""
    nodes = {
        c["id"]: {"author": c.get("author") or "", "content": c.get("text") or "", "replies": []}
        for c in comments
    }
    roots = []
    for c in comments:
        parent = nodes.get(c.get("parent"))
        if parent:
            parent["replies"].append(nodes[c["id"]])
        else:
            roots.append((c.get("like_count") or 0, nodes[c["id"]]))
    # Top-level comments: most likes first. Replies keep their initial order.
    roots.sort(key=lambda pair: pair[0], reverse=True)
    return [node for _, node in roots]


def one_line(text):
    """Collapse line breaks and other whitespace so that a comment stays on one line."""
    return " ".join(text.split())


def encode_comments(comments, depth, lines):
    for c in comments:
        lines.append(f"{INDENT * depth}{one_line(c['author'])}: {one_line(c['content'])}")
        encode_comments(c["replies"], depth + 1, lines)


def to_text(title, url, comments):
    lines = [f"title: {one_line(title)}", f"url: {url}", ""]
    encode_comments(comments, 0, lines)
    return "\n".join(lines) + "\n"


def safe_filename(title):
    name = re.sub(r'[/\\:*?"<>|\x00-\x1f]', "_", title).strip(" .")
    return name or "comments"


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("url", help="URL or ID of the YouTube video")
    target = parser.add_mutually_exclusive_group()
    target.add_argument(
        "-d", "--dir", type=Path, default=Path("."),
        help="directory for the auto-named output file (default: current directory)",
    )
    target.add_argument(
        "-o", "--output", type=Path,
        help="exact output file path; use '-' to write to stdout",
    )
    args = parser.parse_args()

    info = fetch_info(args.url)
    title = info.get("title") or info["id"]
    raw_comments = info.get("comments") or []
    comments = build_tree(raw_comments)

    text = to_text(title, info.get("webpage_url") or args.url, comments)

    if args.output == Path("-"):
        sys.stdout.write(text)
        return
    if args.output:
        path = args.output
    else:
        stamp = datetime.now().strftime("%Y-%m-%d_%H-%M")
        path = args.dir / f"{stamp}_{safe_filename(title)}.txt"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    print(f"Wrote {len(raw_comments)} comments to {path}", file=sys.stderr)


if __name__ == "__main__":
    main()

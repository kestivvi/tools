# kestivvi-tools

My tools:

- `skills/`: agent skills, installable with the [`skills`](https://skills.sh) CLI.
- `scripts/`: Python scripts. `yt_comments.py` downloads all comments of a YouTube video (needs `yt-dlp` and `node`).
- `claude-code/`: Claude Code config. `statusline.sh` shows model, tokens and rate limits.

## Skills

```bash
npx skills add kestivvi/tools --list          # see what's here
npx skills add kestivvi/tools --skill tutor4
npx skills add kestivvi/tools --all -a claude-code
```

## Local development

Symlink a skill from this repo into Claude Code, so edits apply at once:

```bash
ln -s "$PWD/skills/tutor4" ~/.claude/skills/tutor4
```

Run the command from the repo root. Replace `tutor4` with the skill name.

To unlink, remove only the symlink. Do not use `-r` or a trailing slash, because they can delete the files in the repo:

```bash
rm ~/.claude/skills/tutor4
```

## Status line

In `~/.claude/settings.json`:

```json
"statusLine": {
  "type": "command",
  "command": "bash /path/to/kestivvi-tools/claude-code/statusline.sh"
}
```

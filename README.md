# kestivvi-skills

Agent skills, installable with the [`skills`](https://skills.sh) CLI.

```bash
npx skills add kestivvi/skills --list          # see what's here
npx skills add kestivvi/skills --skill tutor4
npx skills add kestivvi/skills --all -a claude-code
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

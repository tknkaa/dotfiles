{ ... }:

{
  # Claude Code skills, versioned in this repo and deployed to ~/.claude/skills
  # so they're available in every project, not just this one.
  home.file.".claude/skills/herdr/SKILL.md".source = ./skills/herdr/SKILL.md;
}

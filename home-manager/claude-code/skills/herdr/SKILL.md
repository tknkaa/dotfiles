---
name: herdr
description: Use when driving herdr (https://herdr.dev), the tmux-style, agent-aware terminal multiplexer this machine's Claude Code sessions run inside of. Covers the `herdr` CLI for listing/inspecting workspaces, tabs, and panes; spawning new agent panes; splitting/focusing/closing panes; sending text or commands to another pane or agent; reading pane output; waiting on an agent's status; and desktop notifications. Trigger on "herdr", "split pane", "new tab", "spawn an agent", "send this to the other pane", "read what's in that pane", "wait until that agent is idle/done/blocked", "terminal workspace", or pane/tab/workspace ids shaped like `wB:pP`.
---

# herdr

herdr runs inside WezTerm and owns both tab and pane control, tmux-style.
Everything is driven through the `herdr` CLI (a thin client over a local
socket API), which is why it works even from inside a pane it's managing.

## Hierarchy and ids

`workspace -> tab -> pane`. Ids look like `wB` (workspace), `wB:tA` (tab),
`wB:pP` (pane). A `terminal_id` (`term_...`) also identifies a pane/agent.
Ids are per-session — always look them up, never hardcode them.

## Orienting yourself

```
herdr status                    # client/server health
herdr workspace list            # workspaces in this session
herdr tab list                  # tabs, optionally --workspace <id>
herdr pane list                 # panes: id, cwd, agent, agent_status
herdr agent list                # agents (claude/codex/...) + status: idle|working|blocked|unknown
herdr pane current --current    # details of the pane you're running in
```

Add `--json` where supported for structured output.

## Targets

Most `agent`/`pane` subcommands take a target that accepts a terminal id, a
pane id, or a unique agent name/label. Pull real values from `herdr pane
list` / `herdr agent list` rather than guessing.

## Spawning and arranging panes

```
herdr pane split --direction right|down [--cwd PATH] [--ratio 0.4] [--focus]
herdr agent start <name> --cwd PATH [--split right|down] -- <argv...>   # new pane running argv
herdr tab create [--cwd PATH] [--label TEXT]
herdr workspace create [--cwd PATH] [--label TEXT]
herdr pane focus --direction left|right|up|down
herdr pane close <pane_id>
```

## Talking to another pane or agent

Two different primitives — pick deliberately:

- `herdr agent send <target> <text>` / `herdr pane send-text <pane_id> <text>`
  — literal text, **no** trailing Enter.
- `herdr pane run <pane_id> <command>` — types the command **and presses
  Enter**, i.e. actually executes it.

Use `run` to make something happen in another pane. Use `send`/`send-text`
when composing input the other side will submit itself (e.g. injecting into
a REPL prompt without submitting it yet).

## Reading pane output

```
herdr agent read <target> [--source visible|recent|recent-unwrapped] [--lines N]
herdr pane read <pane_id> [--source visible|recent|recent-unwrapped] [--lines N]
```

## Waiting on another agent

Prefer these over polling `pane read` in a loop:

```
herdr agent wait <target> --status idle|working|blocked|unknown [--timeout MS]
herdr wait agent-status <pane_id> --status idle|working|blocked|done|unknown [--timeout MS]
herdr wait output <pane_id> --match TEXT [--regex] [--timeout MS]
```

## Notifications

```
herdr notification show "<title>" [--body TEXT] [--sound none|done|request]
```

## Worktrees

```
herdr worktree create [--branch NAME] [--base REF] [--label TEXT]  # new git worktree + wired-up pane
herdr worktree list [--workspace ID | --cwd PATH]
herdr worktree remove --workspace ID
```

## Config

herdr's own `config.toml` (keybindings, theme, notifications) is versioned
in this dotfiles repo at `home-manager/herdr/config.toml` — see that repo's
`README.md` for how to edit and apply it. This skill is about driving
herdr, not configuring it.

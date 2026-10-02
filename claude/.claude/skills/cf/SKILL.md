---
name: cf
description: Use when working with Cloudflare through the `cf` CLI (npm package `cf`, "The Cloudflare CLI"). Covers authentication/profiles, discovering commands with `cf cli search`, and running Workers, D1, R2, DNS, cache, and other Cloudflare operations. Trigger on "cf", "cloudflare", "workers", "wrangler", "D1", "R2", "deploy to Cloudflare", "DNS record", "purge cache".
---

# cf (Cloudflare CLI)

Installed globally via npm (`cf`, currently a 1.0 beta). It exposes the whole
Cloudflare API as `cf <product> <resource> <action>`.

## Discover commands — don't browse `--help`

Use intent search first; it returns five JSON matches:

```sh
cf cli search "list workers"
```

- Keep queries anonymous: describe the action and resource type only. Never
  put names, emails, domains, account/resource IDs, or tokens in the query.
- Pick the best match instead of repeating similar searches.
- Then run `<command> --help` for flags.
- For the underlying API request shape, replace the leading `cf` with
  `cf schema` (e.g. `cf schema workers list`).

## Auth

```sh
cf auth login              # browser login
cf auth whoami             # check current user/status
cf auth list               # list profiles
cf auth create <name>      # create/re-auth a named profile
cf auth activate <name> [dir]   # bind a profile to a directory
cf auth logout
```

Use `--profile <name>` on any command to override the profile.
`CLOUDFLARE_ZONE_ID` or `-z/--zone <id|domain>` selects the zone.

## Common commands

```sh
cf dev                 # run the project's dev server (--local for local simulations)
cf build               # build the project
cf deploy              # deploy the project
cf workers list
cf d1 --help
cf dns --help
cf cache --help
cf complete zsh        # shell completions
```

## Global flags

`-q/--quiet`, `-z/--zone`, `--profile`, `-m/--mode`, `--local`,
`--persist-to <dir>` (local state, default `~/.config/cloudflare/state`).

## Guidelines

- Check `cf auth whoami` before mutating operations.
- Confirm with the user before destructive or production-affecting commands
  (deploy, delete, DNS changes, cache purge).
- Prefer read-only `list`/`get` commands to inspect state before changing it.

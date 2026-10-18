# myconfig

Reproducible macOS setup for terminal-first, agent-assisted development: iOS, Android and
Flutter, Python, Go, Rust, Node, Kubernetes and Terraform, with coding agents (Claude Code,
Codex, pi) running safely in parallel and reachable from anywhere over Tailscale.

Everything is idempotent: re-run it whenever you like. **No personal data lives in this
repository**; it is asked for once and kept on the machine.

## Bootstrap a new Mac

This is my setup. To use it, fork the repository and trim the `Brewfile` (it includes my apps
and games) and `claude/plugins.txt` to taste; everything personal is asked at first run.

```sh
xcode-select --install          # Command Line Tools
git clone https://github.com/<you>/myconfig ~/myconfig   # any path works
cd ~/myconfig
make install                    # Homebrew, Brewfile, dotfiles, toolchains, Claude Code + plugins
                                # (asks for your password once, to install Homebrew)
```

On first run, chezmoi asks for your name, personal and work emails and the directory that holds
work repositories, and stores the answers in `~/.config/chezmoi/chezmoi.toml`.

Then, in order (these need an Apple ID, sudo or a GUI):

1. **Password-protected installs.** `make brew` in a terminal, for casks shipped as `.pkg`, and
   `mas install 937984704` (Amphetamine) if it failed.
2. **Xcode.** `xcodes install <version> --experimental-unxip` (Apple ID + 2FA). Name the
   version; `--latest` can pick a release candidate.
3. **System setup.** `make system` (sudo): selects the newest Xcode, accepts its license,
   downloads the iOS platform, installs Rosetta, creates the `test` DNS domain for containers,
   and limits Remote Login to public keys. Add `MACHINE_NAME=<name>` to rename the Mac (also
   rename it in the Tailscale admin console). Then re-run `make install` to create the Colima
   VM, which needs Rosetta for amd64 images.
4. **Android.** Accept the SDK licenses once:
   `sdkmanager --sdk_root="$HOME/Library/Android/sdk" --licenses`, then re-run `make install`.
   It installs the SDK for Flutter's target API level and a `pixel_api36` emulator.
5. **SSH keys.** Open Secretive and create this Mac's keys in the Secure Enclave. Add the public
   keys to GitHub and your servers. One key set per device; keys are never copied.
6. **GitHub CLI.** `gh auth login --insecure-storage`, so agents can use `gh` inside the sandbox.
7. **Remote access.** System Settings → General → Sharing → Remote Login. Put each device's
   public key in `~/.ssh/authorized_keys` (one per line, `chmod 600`).
8. **macOS preferences.** `make defaults`: Finder, Dock, keyboard and trackpad (tap to click,
   drag lock, press-and-hold accents kept).

## What you get

| Area | Tools |
|---|---|
| Terminal | Ghostty, zsh + zinit, Starship, Atuin, zoxide, fzf, eza, bat, ripgrep, lazygit, yazi |
| Agent sessions | herdr (agent-aware multiplexer inside Ghostty), pulpo (background agents), mosh |
| Coding agents | Claude Code (native installer), Codex, pi; Claude plugins in `claude/plugins.txt` (language servers globally, Flutter/Terraform/security plugins per repository) |
| Node, Go, Java | `mise` (honors `.nvmrc`, `.go-version`, `mise.toml`) |
| Python | `uv` |
| Rust | `rustup` |
| Flutter | `fvm` (per-project `.fvmrc`, global stable), Xcode, Android Studio, CocoaPods |
| Containers | Colima (VM with 4 CPUs, 8 GB, sharing only `~/Code`, started at login) + Docker CLI, Compose and Buildx; Apple `container` + `container-compose` (defaults in `~/.config/container/config.toml`) |
| Kubernetes | kubectl + kubecolor, k9s, kubectx/kubens, stern, helm |
| Infrastructure | `tenv` (Terraform/OpenTofu per `.terraform-version`), gcloud, Cloudflare `cf` |
| Security | Secretive, Bitwarden, Little Snitch, Tailscale |

## Agentic development

- **Rules and skills.** Shared by Claude Code, Codex and pi; see
  [Agent rules and skills](#agent-rules-and-skills).
- **One agent per worktree.** `cw <name>` runs `claude --worktree <name>`.
- **herdr inside Ghostty.** Run `herdr` and start agents in its panes. Each pane shows whether
  its agent is working, blocked or idle (`herdr integration install claude`, also `codex` and
  `pi`). `ctrl+b q` detaches; the agents keep running.
- **Ghostty.** Splits with `cmd+d` / `cmd+shift+d`, move with `cmd+alt+h/j/k/l`, zoom with
  `cmd+shift+enter`. Long commands that finish in an unfocused pane send a notification.
  `` cmd+` `` toggles a system-wide quick terminal.
- **From your phone.** Termius with Mosh enabled → `mosh <mac>` over Tailscale. Every SSH or
  Mosh login opens `agents`, a picker of the running herdr agents (blocked ones first): pick one
  to attach to it, `ctrl+b q` to detach and come back to the list (the agent keeps running), Esc
  for a plain shell. Local terminals and
  herdr's own panes skip it. An attached phone sets that agent's width, so closing Termius
  without detaching leaves it narrow on the desktop: Mosh sessions end after 30 minutes without
  the phone, and `unphone` on the Mac ends them after one. Inside herdr, `prefix+a` / `prefix+shift+a` step through agents,
  `prefix+o` jumps to the one that notified you, `prefix+z` zooms a pane and `prefix+b` hides the
  sidebar (the prefix is `ctrl+b`).
- **Background agents.** [pulpo](https://github.com/darioblanco/pulpo) runs agents as durable
  tmux sessions you can attach to: `pulpo spawn <name> --workdir . -- claude`.
- **Usage.** `ccusage` (or `pulpo usage --scan`) reports token use and cost per agent and repo.
- **Claude limits.** Every Claude Code session's status line shows model, context use and how
  much of the 5-hour and weekly plan limits is left. A SwiftBar menu-bar item (`✻ 94%`, plus
  `⏸2` when herdr agents are blocked on you) shows the same numbers outside Claude Code and
  lists agents that need you, each a click away from focus in herdr; open SwiftBar once and enable "Launch at login". The
  numbers update while a Claude Code session runs; nothing leaves the Mac.

### Subscriptions, not API keys

Claude Code is restricted to claude.ai logins (`forceLoginMethod`) and Codex to ChatGPT logins
(`forced_login_method`), and the shell warns if `ANTHROPIC_API_KEY` or `OPENAI_API_KEY` is
exported, since either would switch the agent to pay-per-token billing. Agents run in
interactive sessions, in auto mode by default, not headless.

### Keeping the Mac awake

Use **Amphetamine** so you decide each time: turn off "Allow system sleep when display is
closed", keep "Lock screen after inactivity" on, and start a session before closing the lid.
`make awake` / `make sleep` toggle sleep system-wide instead. Don't leave it awake in a closed
bag.

## Agent rules and skills

[`home/dot_agents/AGENTS.md`](home/dot_agents/AGENTS.md) is a short set of personal engineering
rules loaded into every session. It holds only what the agents don't do by default and the
settings, sandbox and hooks can't enforce. Claude Code also loads
[`home/dot_claude/rules/sandbox.md`](home/dot_claude/rules/sandbox.md), which tells it how to run
credentialed tools under this repo's sandbox.

Claude Code also loads each repository's `AGENTS.md` next to the `CLAUDE.md` files
(`instructionFiles: claude-md-and-agents-md`). By default it reads `AGENTS.md` only when no
`CLAUDE.md` exists in the repository or any folder above it, so a workspace `CLAUDE.md` above
the checkouts would hide every repository's `AGENTS.md`.

[`home/dot_agents/skills/`](home/dot_agents/skills) holds skills for occasional procedures. Only
each skill's one-line description is in context until a task needs it.

| Skill | Use it for |
|---|---|
| [`plan-architecture`](home/dot_agents/skills/plan-architecture/SKILL.md) | A one-page design plan before a new feature, module or interface: boundaries, data flow, failure modes, security, test strategy, steps |
| [`systematic-debugging`](home/dot_agents/skills/systematic-debugging/SKILL.md) | Root cause before fixes: reproduce, locate, one hypothesis at a time; stop after three failed fixes |
| [`dependency-check`](home/dot_agents/skills/dependency-check/SKILL.md) | Whether a library is healthy and safe: maintenance, adoption, license, advisories, supply-chain risks |
| [`test-suite`](home/dot_agents/skills/test-suite/SKILL.md) | Setting up enforced coverage for a repository, or auditing how trustworthy a test suite is (including mutation testing) |
| [`team-practices`](home/dot_agents/skills/team-practices/SKILL.md) | How a team works (review, delivery, ownership, AI judgement, atmosphere), assessed as a system, never as individuals |
| [`tech-due-diligence`](home/dot_agents/skills/tech-due-diligence/SKILL.md) | An evidence-based technical due diligence report; uses the skills above, the `claude-security` scan, and the `code-modernization` plugin enabled only for the DD directory |

Code review uses the tools' native commands (`/code-review` in Claude Code, `/review` in Codex)
rather than a skill.

### Use them without the rest of this repository

They work with any agent that reads `AGENTS.md` and [Agent Skills](https://agentskills.io).
They are written in the first person ("wait for my OK"), so read them and adapt them to how you
work. To try them (this replaces any existing `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md`):

```sh
git clone https://github.com/darioblanco/myconfig
mkdir -p ~/.agents && cp -R myconfig/home/dot_agents/. ~/.agents/
ln -sf ~/.agents/AGENTS.md ~/.claude/CLAUDE.md      # Claude Code
ln -sf ~/.agents/AGENTS.md ~/.codex/AGENTS.md       # Codex (reads ~/.agents/skills natively)
mkdir -p ~/.claude/skills && ln -sf ~/.agents/skills/*/ ~/.claude/skills/
```

### Where the rules come from

The design, testing and API lines are distilled from projects whose engineering is worth copying.
Only what changes an agent's default behaviour is kept:

| Project | Lesson kept |
|---|---|
| [SQLite](https://sqlite.org/testing.html) | Test the failure paths (errors, partial writes, malformed input), fuzz parsers, and start every bug fix with a test |
| [Linux kernel](https://docs.kernel.org/process/submitting-patches.html) | Never break userspace (APIs change only additively); get the data structures right and the special cases disappear; every commit builds on its own and says why |
| [LLVM](https://llvm.org/docs/CodingStandards.html) | Layering: dependencies point one way, libraries with narrow interfaces |
| [Go standard library](https://pkg.go.dev/net/http/httptest) | Test protocol clients against a real local server instead of mocking them |
| [Tokio](https://tokio.rs/) and [Swift concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/) | Structured concurrency: timeouts, cancellation, no orphaned tasks, bounded queues |
| [ScyllaDB](https://www.scylladb.com/) | Measure before optimising, and choose data structures for the access pattern |
| [Google's API Improvement Proposals](https://google.aip.dev/) and [Stripe's API](https://docs.stripe.com/api) | APIs: resources and standard methods, cursor pagination, idempotency keys on retried writes, one error shape ([RFC 9457](https://www.rfc-editor.org/rfc/rfc9457)) |

How the agents are run and instructed owes a lot to people who write openly about working with
them:

| Person | What shaped this setup |
|---|---|
| [Mitchell Hashimoto](https://mitchellh.com/writing/my-ai-adoption-journey) | Short, specific rules, with a line added each time an agent repeats a mistake; reproduce your own work with an agent before trusting it |
| [Armin Ronacher](https://lucumr.pocoo.org/2025/6/12/agentic-coding/) | Plain command-line tools and Makefile targets over MCP servers; an agent with full permissions needs an environment you can afford to lose |
| [Simon Willison](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/) | Red/green TDD with agents, and the lethal trifecta (private data, untrusted content, a way out) behind the sandbox's credential and network limits |
| [Kent Beck](https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes) | Tests first, and agents kept to small, verified steps |
| [Jesse Vincent](https://github.com/obra/dotfiles) and [Peter Steinberger](https://github.com/steipete/agent-scripts) | Root cause before fixes, and no compatibility shims nobody asked for |

## Security

Coding agents run as you, read untrusted content (READMEs, issues, web pages, dependencies) and
can reach the network. The setup removes what they could leak and limits where data can go.

- **No keys on disk.** SSH keys live in the Secure Enclave (Secretive), one set per device.
  Remote Login accepts public keys only.
- **No long-lived cloud keys.** Prefer `gcloud auth login` and service-account impersonation
  over downloaded key files. Kubernetes uses the GKE auth plugin (short-lived tokens).
- **Claude Code sandbox** (`home/dot_claude/modify_settings.json`, merged into
  `~/.claude/settings.json` without touching other keys):
  - shell commands can't read credential paths (`~/.ssh`, `~/.config/gcloud`, `~/.kube`, `gh`,
    shell history, keychains); Claude's file tools are also denied those paths and `.env` files;
  - outbound traffic is limited to package registries and GitHub; in auto mode any other host
    needs the classifier's approval per command;
  - destructive infrastructure commands (`terraform apply`, `kubectl delete`, `helm upgrade`,
    force pushes…) always ask, even in auto mode;
  - `gh` works inside the sandbox, including in pipes: its token is stored in its own config
    (`gh auth login --insecure-storage`) instead of the Keychain, which the sandbox blocks, and
    `enableWeakerNetworkIsolation` lets Go tools verify TLS. Trade-off: sandboxed commands can
    read that token, so the gist, key-upload and `gh api` write rules are what limit its misuse;
  - tools that can't run sandboxed (`gh`, `gcloud`, `terraform`, `kubectl`, git network
    commands, Apple `container`, Docker and Colima) are excluded and go through the normal
    permission flow, with deny or ask rules for their exfiltration paths (gists, `gh api`
    writes, volume mounts, `docker cp`/`push`/`login`, custom kubeconfigs, `ext::` remotes);
  - Colima shares only `~/Code` with containers, so a compose file can't mount `~/.ssh` or other
    credentials. Accepted risk: containers' own network traffic doesn't go through the sandbox
    proxy, and `docker build` can read any folder given as its build context;
  - CI fails if the policy loses a rule recorded in `claude/policy-baseline.json`, so weakening
    it takes a deliberate two-file change.
  - Accepted risk: package caches are writable from the sandbox so builds work, which means a
    sandboxed command could tamper with a cached dependency.
  - Accepted risk: agents can read Claude Code's own session transcripts and memory
    (`~/.claude/projects`), so they can pick up past sessions' memory and context, including
    anything pasted into an earlier session.
- **No AI attribution.** Claude Code's attribution is off, and a global git commit-msg hook
  strips AI co-author trailers in every repository.
- **Supply chain.** pnpm refuses versions younger than a day and blocks dependency install
  scripts until approved (its defaults); package caches stay writable from the sandbox so
  installs work there; this repo's GitHub Actions are pinned to commit SHAs and updated by
  Dependabot after a 7-day cooldown; the agent rules require verifying package names, since
  agents hallucinate them.
- **Codex** keeps its own default sandbox. **pi** has none: use it for trusted work only.
- **Little Snitch** alerts on new outbound connections from any process.

Use `/sandbox` inside Claude Code to inspect or adjust the policy for a session.

To use the policy without the rest of this repository, read
[`home/dot_claude/modify_settings.json`](home/dot_claude/modify_settings.json) first (the
excluded commands and allowed domains fit my tools), then merge it into your settings; it keeps
every key you already have:

```sh
tmp=$(mktemp) && sh modify_settings.json < ~/.claude/settings.json > "$tmp" && mv "$tmp" ~/.claude/settings.json
```

Add [`home/dot_claude/rules/sandbox.md`](home/dot_claude/rules/sandbox.md) to `~/.claude/rules/`
so agents know how to run the excluded tools.

## Layout

| Path | What |
|---|---|
| `Brewfile` | CLI tools, apps, fonts, Mac App Store apps |
| `bootstrap.sh` | Homebrew, Brewfile, dotfiles, toolchains, Claude Code and plugins |
| `home/` | chezmoi source for `$HOME`: zsh, git, ssh, Ghostty, Starship, mise, Atuin, lazygit, container, Docker, Claude Code |
| `home/dot_agents/` | Personal agent rules and skills, shared by Claude Code, Codex and pi |
| `claude/plugins.txt` | Claude Code plugins (kept small: each one costs context) |
| `macos/system.sh` | One-time sudo setup: Xcode, Rosetta, container DNS, SSH server, machine name |
| `macos/defaults.sh` | Finder, Dock, keyboard and trackpad |
| `AGENTS.md` | How coding agents should change this repo |

## Maintenance

```sh
make update     # upgrade Homebrew packages, mise tools, Rust and Python
make diff       # preview dotfile changes
make apply      # apply dotfiles
make lint       # what CI runs: shell, workflows, Claude policy
make check      # lint plus Ghostty config and skills validation
make help       # every target
```

Edit dotfiles here, not in `$HOME`. If you changed one in place, `chezmoi re-add <file>` copies it
back.

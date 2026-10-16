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
   downloads the iOS platform, creates the `test` DNS domain for containers, and limits Remote
   Login to public keys. Add `MACHINE_NAME=<name>` to rename the Mac (also rename it in the
   Tailscale admin console).
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
| Containers | Apple `container` + `container-compose`, defaults in `~/.config/container/config.toml` |
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
- **From your phone.** Termius with Mosh enabled → `mosh <mac>` over Tailscale → `herdr`.
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
interactive sessions (auto mode included), not headless.

### Keeping the Mac awake

Use **Amphetamine** so you decide each time: turn off "Allow system sleep when display is
closed", keep "Lock screen after inactivity" on, and start a session before closing the lid.
`make awake` / `make sleep` toggle sleep system-wide instead. Don't leave it awake in a closed
bag.

## Agent rules and skills

[`home/dot_agents/AGENTS.md`](home/dot_agents/AGENTS.md) is a short set of personal engineering
rules loaded into every session. It holds only what the agents don't do by default and the
settings, sandbox and hooks can't enforce.

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

The rules borrow from published practice: short and specific, a line added each time an agent
repeats a mistake ([Mitchell Hashimoto](https://mitchellh.com/writing/my-ai-adoption-journey)),
root cause first and no compatibility shims ([Jesse Vincent](https://github.com/obra/dotfiles),
[Peter Steinberger](https://github.com/steipete/agent-scripts)), and red/green TDD
([Simon Willison](https://simonwillison.net/guides/agentic-engineering-patterns/red-green-tdd/),
[Kent Beck](https://newsletter.kentbeck.com/p/augmented-coding-beyond-the-vibes)).

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
  - tools that can't run sandboxed (`gh`, `gcloud`, `terraform`, `kubectl`, `pnpm install`,
    git network commands, Apple `container`) are excluded and go through the normal permission
    flow, with deny or ask rules for their exfiltration paths (gists, `gh api` writes, volume
    mounts, custom kubeconfigs, `ext::` remotes);
  - CI fails if the policy loses a rule recorded in `claude/policy-baseline.json`, so weakening
    it takes a deliberate two-file change.
  - Accepted risk: package caches are writable from the sandbox so builds work, which means a
    sandboxed command could tamper with a cached dependency.
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

## Layout

| Path | What |
|---|---|
| `Brewfile` | CLI tools, apps, fonts, Mac App Store apps |
| `bootstrap.sh` | Homebrew, Brewfile, dotfiles, toolchains, Claude Code and plugins |
| `home/` | chezmoi source for `$HOME`: zsh, git, ssh, Ghostty, Starship, mise, Atuin, lazygit, container, Claude Code |
| `home/dot_agents/` | Personal agent rules and skills, shared by Claude Code, Codex and pi |
| `claude/plugins.txt` | Claude Code plugins (kept small: each one costs context) |
| `macos/system.sh` | One-time sudo setup: Xcode, container DNS, SSH server, machine name |
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

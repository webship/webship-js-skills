# webship-js Skills

AI-assistant skills for automated website testing with
[webship-js](https://webship.co/docs/webship-js/2.0.x) — a BDD testing
framework built on **Playwright** + **Cucumber-js**.

Works with **Claude Code**, **GitHub Copilot**, **Gemini CLI**, and
**Codex CLI**. Same Gherkin knowledge, multiple front ends.

## Skills

| Skill               | Slash command         | Purpose                                                        |
|---------------------|-----------------------|----------------------------------------------------------------|
| Init project        | `/webship-js-init`    | Scaffold a new webship-js project (Node.js or DDEV).           |
| Create tests        | `/webship-js-create`  | Author `.feature` files for a page (desktop + mobile).         |
| Run tests           | `/webship-js-run`     | Run the suite, generate HTML report, analyze failures.         |
| Step reference      | `/webship-js-steps`   | Look up any Given/When/Then step definition.                   |

## Install

### Claude Code

```bash
git clone https://github.com/webship/webship-js-skills.git
cd webship-js-skills
bash install.sh                            # globally: ~/.claude/skills/
bash install.sh --project /path/to/proj    # project: <proj>/.claude/skills/
```

Each skill lives at
`.claude/skills/<name>/SKILL.md` and is invoked via its slash command.

### GitHub Copilot

```bash
bash install.sh --copilot                    # globally: ~/.config/github-copilot/
bash install.sh --copilot --project /path    # project: <proj>/.github/
```

Installs:
- `.github/copilot-instructions.md` — codebase-wide guidance.
- `.github/prompts/webship-js-*.prompt.md` — one file per skill, invokable
  as a Copilot prompt.

### Gemini CLI

```bash
bash install.sh --gemini                     # globally: ~/.gemini/
bash install.sh --gemini --project /path     # project: <proj>/.gemini/
```

Installs:
- `.gemini/GEMINI.md` — context loaded on start.
- `.gemini/commands/webship-js/<name>.toml` — one TOML command per skill,
  invokable as `/webship-js:<name>`.

### Codex CLI

```bash
bash install.sh --codex                      # globally: ~/.codex/
bash install.sh --codex --project /path      # project: <proj>/AGENTS.md + .codex/prompts/
```

Installs:
- `AGENTS.md` at the target root — loaded automatically by Codex CLI and
  by any tool that honors the [AGENTS.md convention](https://agents.md).
- `.codex/prompts/webship-js-<name>.md` — custom prompt per skill.

### All assistants at once

```bash
bash install.sh --all                        # globally to every supported tool
bash install.sh --all --project /path        # all project-scoped files
```

## Usage

### Claude Code

```
/webship-js-init --ddev
/webship-js-create /contact
/webship-js-run @desktop
/webship-js-steps form
```

### Copilot

```
@workspace /webship-js-init https://example.com
@workspace /webship-js-create /contact
```

### Gemini

```
/webship-js:init https://example.com
/webship-js:create /contact
/webship-js:run @desktop
/webship-js:steps
```

### Codex

```
codex "use webship-js-init for https://example.com"
codex "use webship-js-create for /contact"
```

## Typical workflow

```bash
# 1. Scaffold
/webship-js-init https://example.com
# or for DDEV:
/webship-js-init --ddev

# 2. Author tests for a page
/webship-js-create /contact

# 3. Run + analyze
/webship-js-run
# or with a tag filter:
/webship-js-run "@desktop and @validation"

# 4. Look up step syntax
/webship-js-steps form
```

## Requirements

- Node.js >= 20.0 (webship-js `engines` requirement).
- One of: Claude Code, GitHub Copilot, Gemini CLI, or Codex CLI.

## webship-js version

Built for **webship-js 2.0.x**. Step regex may change between minor
releases — the skills load the installed `node_modules/webship-js/` source
as the authoritative reference.

## License

MIT

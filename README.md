# Webship-js Skills for Claude Code

Claude Code skills for automated website testing with
[webship-js](https://webship.co/docs/webship-js/2.0.x) (Playwright + Cucumber-js).

## Available Skills

| Skill | Command | Description |
|-------|---------|-------------|
| Setup | `/webship-js-setup` | Initialize a new webship-js test project |
| Test | `/webship-js-test` | Create & run BDD tests for a page |
| Report | `/webship-js-report` | Generate & analyze HTML test reports |
| Steps | `/webship-js-steps` | Quick reference for all step definitions |

## Installation

### Quick Install

```bash
git clone https://github.com/webship/webship-js-skills.git
cp -r webship-js-skills/.claude/skills/* ~/.claude/skills/
```

### Project-Level Install

```bash
cp -r webship-js-skills/.claude/skills/* /path/to/project/.claude/skills/
```

### Install Script

```bash
git clone https://github.com/webship/webship-js-skills.git
cd webship-js-skills
bash install.sh            # Install globally
bash install.sh --project /path/to/project  # Install to project
```

## Usage

In Claude Code, invoke skills with slash commands:

```
/webship-js-setup https://example.com
```

```
/webship-js-test /contact
```

```
/webship-js-report @desktop
```

```
/webship-js-steps form
```

## Workflow Example

```bash
# 1. Set up project
/webship-js-setup https://example.com

# 2. Create tests for the contact page
/webship-js-test /contact

# 3. Run tests and get report
/webship-js-report

# 4. Look up step syntax
/webship-js-steps api
```

## Requirements

- [Claude Code](https://claude.com/claude-code) CLI
- Node.js >= 20.0

## License

MIT

---
name: webship-js-init
description: Initialize a webship-js test project for a target website (plain Node.js or inside a DDEV project). Scaffolds cucumber.js, playwright.config.ts, tsconfig.json, and the tests/ tree. Idempotent — preserves existing files.
---

# /webship-js-init — Initialize a webship-js test project

Scaffold a [webship-js 2.0.x](https://webship.co/docs/webship-js/2.0.x) project
for automated website testing.

## Arguments

- `$ARGUMENTS` — target website URL (e.g. `https://example.com`) or `--ddev`
  to install the [`ddev-webship-js`](https://github.com/webship/ddev-webship-js)
  add-on in the current DDEV project.

## Context loading (read before writing any file)

### 1. Official docs

Fetch:

- https://webship.co/docs/webship-js/2.0.x
- https://webship.co/docs/webship-js/2.0.x/install-webship-js
- https://webship.co/docs/webship-js/2.0.x/global-settings
- https://webship.co/docs/webship-js/2.0.x/commands

### 2. Local webship-js package (if present)

If `node_modules/webship-js/` exists, read:

- `node_modules/webship-js/bin/init-webship.js` — the source of truth for
  what `npx init-webship-js` writes.
- `node_modules/webship-js/cucumber.js` — default cucumber config.
- `node_modules/webship-js/playwright.config.ts` — default playwright config.
- `node_modules/webship-js/package.json` — scripts + dependency versions.

If missing, fetch the same files from
`https://github.com/webship/webship-js/tree/2.0.x`.

### 3. Existing project files (if re-running)

- `cucumber.js` — current config (do not overwrite without consent).
- `playwright.config.ts` — current browser config.
- `tests/features/*.feature` — user-authored features.
- `tests/step-definitions/*.js` — user custom steps.
- `package.json` — existing scripts/deps to merge, not clobber.

## Instructions

### Path A — plain Node.js project

1. Create a project dir if none exists. Name it after the target site
   (e.g. `test-example-com`) unless the user provided one.

2. Install webship-js and scaffold:

   ```bash
   cd <project-dir>
   npm install --no-save webship-js
   npx init-webship-js                 # idempotent, keeps existing files
   # npx init-webship-js --force       # only if user explicitly asked
   # npx init-webship-js --skip-browsers  # skip playwright browser install
   ```

   `init-webship-js` writes: `cucumber.js`, `playwright.config.ts`,
   `tsconfig.json`, `tests/features/check-homepage.feature`,
   `tests/step-definitions/custom.js`, READMEs under `tests/`, and
   merges `test`, `test:chromium`, `test:firefox`, `test:webkit`,
   `generate-reports` into `package.json` scripts.

3. Point `launchUrl` at the target site. Prefer env var over editing:

   ```bash
   LAUNCH_URL=https://example.com npm test
   ```

   Or edit `cucumber.js`:

   ```js
   worldParameters: {
     launchUrl: process.env.LAUNCH_URL || 'https://example.com',
     ...
   }
   ```

4. Smoke-test:

   ```bash
   LAUNCH_URL=https://example.com npm run test:chromium
   ```

### Path B — DDEV project (`$ARGUMENTS` is `--ddev`)

1. From the DDEV project root:

   ```bash
   ddev add-on get webship/ddev-webship-js
   ddev restart
   ```

   The add-on:
   - Adds a Playwright+browsers layer to the web container.
   - On post-start runs `npm install --no-save webship-js` then
     `init-webship-js --skip-browsers` to scaffold (preserves existing
     files, merges into existing `package.json`).
   - Sets `LAUNCH_URL=${DDEV_PRIMARY_URL}` inside the container.
   - Replaces the default webship-js sample feature with a DDEV-universal
     one that passes on any project (only while still default).

2. Run tests inside the container:

   ```bash
   ddev npm run test:chromium
   ddev npm run test:firefox
   ddev npm run test:webkit
   ```

3. Re-scaffold if needed:

   ```bash
   ddev exec npx init-webship-js          # idempotent
   ddev exec npx init-webship-js --force  # overwrite defaults
   ```

## What gets scaffolded

```
<project>/
├── cucumber.js
├── playwright.config.ts
├── tsconfig.json
├── package.json                  # scripts merged in
├── screenshots/                  # auto-created on failure
└── tests/
    ├── features/
    │   ├── check-homepage.feature
    │   └── README.md
    ├── step-definitions/
    │   ├── custom.js
    │   └── README.md
    ├── selectors/
    └── reports/
        └── README.md
```

## Requirements

- Node.js >= 20.0 (enforced by webship-js `engines`).
- On Linux: `npx playwright install --with-deps chromium` the first time
  (skip in DDEV — the Dockerfile handles it).

## Verify

1. `cucumber.js` `require:` includes both
   `node_modules/webship-js/tests/step-definitions/**/*.js` and
   `tests/step-definitions/**/*.js`.
2. `package.json` has `test`, `test:chromium`, `test:firefox`,
   `test:webkit`, `generate-reports` scripts.
3. `tests/features/check-homepage.feature` exists and runs green:
   `LAUNCH_URL=<url> npm run test:chromium`.

Report the project path, target URL, and next-step command.

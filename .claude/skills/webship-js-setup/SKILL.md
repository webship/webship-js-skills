---
name: webship-js-setup
description: Set up a new webship-js test project for a target website. Creates project structure, installs dependencies, and configures cucumber.js and playwright.config.ts.
---

# /webship-js-setup — Initialize a webship-js Test Project

Set up a new webship-js 2.0 test project for automated website testing.

## Arguments

- `$ARGUMENTS` — The target website URL (e.g., `https://example.com`)

## Context Loading (MUST do before proceeding)

Before setting up the project, load the full webship-js context:

### 1. Read the official documentation
Fetch and read ALL of the following pages:
- https://webship.co/docs/webship-js/2.0.x
- https://webship.co/docs/webship-js/2.0.x/install-webship-js
- https://webship.co/docs/webship-js/2.0.x/global-settings
- https://webship.co/docs/webship-js/2.0.x/step-definitions
- https://webship.co/docs/webship-js/2.0.x/api-step-definitions
- https://webship.co/docs/webship-js/2.0.x/assertions
- https://webship.co/docs/webship-js/2.0.x/commands

### 2. Read webship-js source code
Read the source code from local `node_modules/webship-js/` if it exists, otherwise fetch from https://github.com/webship/webship-js (branch `2.0.x`):

**Configuration files (read these for correct setup):**
- `node_modules/webship-js/cucumber.js` — default Cucumber config
- `node_modules/webship-js/playwright.config.ts` — default Playwright config
- `node_modules/webship-js/package.json` — dependencies and scripts
- `node_modules/webship-js/generate-reports.js` — report generator

**Step definition source code (read ALL to understand available steps):**
- `node_modules/webship-js/tests/step-definitions/webship.js` — all UI step definitions
- `node_modules/webship-js/tests/step-definitions/webship-api.js` — all API step definitions

**Example .feature files (read for patterns and conventions):**
- `node_modules/webship-js/tests/features/*.feature` — all 49 example feature files

**Example HTML test pages:**
- `node_modules/webship-js/examples/*.html` — all 30 example HTML pages

### 3. Read existing project files
If a project directory already exists, read:
- `cucumber.js` — current configuration
- `playwright.config.ts` — current Playwright config
- `tests/features/*.feature` — existing feature files
- `tests/step-definitions/*.js` — existing custom step definitions

## Instructions

1. If no project directory exists, create one based on the site name (e.g., `test-example-com`).

2. Initialize the project:
   ```bash
   cd <project-dir>
   npm init -y
   npm add webship-js
   bash <(wget -O - https://raw.githubusercontent.com/webship/wbash/v1/webship-js/v2/template.sh)
   ```

3. Update `cucumber.js` — set `launchUrl` to the target URL:
   ```javascript
   worldParameters: {
     launchUrl: process.env.LAUNCH_URL || '<TARGET_URL>',
     minWaitTime: {
       page: 3000,
       before_scenario: 0,
       after_scenario: 0,
       before_step: 0,
       after_step: 0,
     },
   },
   ```

4. Ensure `playwright.config.ts` has proper settings:
   - `headless: true`
   - `slowMo: 300`
   - `viewport: { width: 1600, height: 1200 }`
   - `--incognito` in args for fresh context per scenario

5. Create directories:
   ```
   tests/features/
   tests/step-definitions/
   tests/reports/
   tests/assets/
   ```

6. Create `tests/step-definitions/custom.js` with boilerplate:
   ```javascript
   const { Given, When, Then } = require('@cucumber/cucumber');
   const assert = require('assert');
   // Add your custom step definitions here.
   ```

7. Report success with project path and next steps.

## Notes

- Node.js >= 20.0 is required
- The `require` paths in cucumber.js MUST include both webship-js built-in steps AND custom steps:
  ```javascript
  require: [
    'node_modules/webship-js/tests/step-definitions/**/*.js',
    'tests/step-definitions/**/*.js',
  ],
  ```

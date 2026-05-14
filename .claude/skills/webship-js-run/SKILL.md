---
name: webship-js-run
description: Run the webship-js suite (tag- or file-filtered, headed/fast, with optional video + JS-error reporting when supported), generate the HTML report, and summarize results with pass/fail + root-cause analysis of any failures.
---

# /webship-js-run — Run tests, generate report, analyze failures

Run the webship-js suite, produce the HTML report, and summarize results.

## Arguments

- `$ARGUMENTS` — optional tag filter (e.g. `@desktop`, `@smoke`,
  `"@desktop and @validation"`) or a single `.feature` path.

## Context loading

### 1. Docs

- https://webship.co/docs/webship-js/2.0.x
- https://webship.co/docs/webship-js/2.0.x/assertions
- https://webship.co/docs/webship-js/2.0.x/commands
- https://webship.co/docs/webship-js/2.0.x/global-settings

### 2. Local webship-js source (needed to explain failures)

Recent webship-js is modular — read whichever step file owns the failing
step. List the installed catalog first:

```bash
ls node_modules/webship-js/tests/step-definitions/*.steps.js
# a11y action api assertion auth clock cookie debug dialog element field
# file-download form iframe input javascript keyboard link metatag modal
# navigation network path response responsive rest screenshot scroll
# selectors storage table video wait web-first xml yaml
```

Plus `node_modules/webship-js/bin/generate-reports.js` — report generator.

### 3. Current project

- `cucumber.js` — `launchUrl`, `minWaitTime`, selectors.
- `playwright.config.ts` — browser settings.
- `tests/features/*.feature` — features under test.
- `tests/step-definitions/*.js` — custom steps.
- Existing `tests/reports/cucumber_report.json` (if already run).

## Instructions

### 1. Verify install

```bash
node -v                    # >= 20
ls node_modules/webship-js # webship-js installed
cat cucumber.js            # launchUrl set
```

DDEV: prefix each with `ddev exec`.

### 2. Run the suite

Plain Node.js:

```bash
# all tests
npm test
# tag filter (from $ARGUMENTS)
npx cucumber-js --config cucumber.js --tags "$ARGUMENTS"
# single file
npx cucumber-js --config cucumber.js tests/features/<file>.feature
# per-browser
npm run test:chromium
npm run test:firefox
npm run test:webkit
# watch the browser (HEADLESS=false + 800ms slow-mo)
npm run test:headed
# fastest run (SLOW_MO=0)
npm run test:fast
# combine env vars
HEADLESS=false SLOW_MO=500 BROWSER=firefox npm test
# colored CI logs (cucumber-js v10+)
FORCE_COLOR=1 npm test
# record video
WEBSHIP_VIDEO=on npm test               # every scenario
WEBSHIP_VIDEO=on-failure npm test       # only failures
WEBSHIP_VIDEO=tag npm test              # only @video-tagged scenarios
# JS-error reporter
WEBSHIP_JS_ERROR_MODE=fail npm test     # fail any scenario with JS errors
WEBSHIP_JS_ERROR_LEVELS=error,warning npm test
```

DDEV:

```bash
ddev npm run test:chromium
ddev exec npx cucumber-js --config cucumber.js --tags "$ARGUMENTS"
```

### 3. Report

HTML is auto-generated after every run unless `WEBSHIP_REPORT_DISABLE=1`.
Regenerate manually from the JSON:

```bash
npm run generate-reports
# or
npx generate-reports
```

Paths:

- `tests/reports/cucumber_report.json` — raw Cucumber output.
- `tests/reports/cucumber_report.html` — HTML dashboard.
- `screenshots/` — failure screenshots (prefix `failed_`).
- `videos/` — per-scenario recordings when `WEBSHIP_VIDEO != off`.

### 4. Summarize

Read `tests/reports/cucumber_report.json` and produce:

```
## Test results

| Metric       | Count |
|--------------|-------|
| Scenarios    | X     |
| Passed       | X     |
| Failed       | X     |
| Skipped      | X     |
| Steps        | X     |
| Duration     | Xs    |

### Failures
- **Feature / Scenario** — "name"
  - **Step**: `When I press "Submit"`
  - **Error**: `Timed out waiting for ...`
  - **Screenshot**: `screenshots/failed_<...>.png`
  - **Root cause**: AJAX race — step clicks but does not wait
  - **Fix**: add `And I wait for AJAX to finish` after `I press`

### Reports
- HTML: `tests/reports/cucumber_report.html`
- JSON: `tests/reports/cucumber_report.json`
```

### 5. Root-cause checklist for failures

- **Timeout on text/element.** Missing AJAX wait after `I press` /
  `I click` / form submit. Fix: chain `And I wait for AJAX to finish` —
  or convert the assertion to web-first
  (`Then "<sel>" should be visible within 5 seconds`).
- **Wrong element matched.** Register a named selector and use the
  positional form (`When I click login button`).
- **Text seen by curl but not by test.** Likely auto-dismissed message —
  lower `minWaitTime.page`.
- **Selector lookup failed.** Check `tests/selectors/*.json` is listed in
  `worldParameters.selectors.files`.
- **Iframe content invisible.** Did the test
  `When I switch to the iframe "<sel>"`? Default scope is the root
  document.
- **HTTP 403/429.** Target site has rate limit / flood control — add a
  custom step accepting either outcome.
- **a11y false positive.** Use
  `Then the page should pass an accessibility audit excluding ".third-party"`
  to scope around external embeds.
- **JS-error noise.** Set `WEBSHIP_JS_ERROR_IGNORE` regex or tag with
  `@js-warn` / `@js-off`.
- **Playwright browser missing.** `npx playwright install --with-deps chromium`
  (or `ddev exec` same).
- **`function timed out`.** Cucumber's outer timeout fires before
  Playwright's — bump `timeout` in `cucumber.js`.

Cross-reference each failing step against its regex in the matching
`tests/step-definitions/<category>.steps.js` to confirm phrasing is valid
on the installed version. If `friendly()` / `humanize()` error filtering is
present, the test output already explains the root cause — surface it
verbatim before adding analysis.

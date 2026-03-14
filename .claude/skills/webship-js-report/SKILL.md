---
name: webship-js-report
description: Generate and analyze webship-js test reports. Runs tests, creates HTML report, and provides a summary of results with pass/fail details.
---

# /webship-js-report — Generate & Analyze Test Report

Run the webship-js test suite and generate an HTML report with analysis.

## Arguments

- `$ARGUMENTS` — Optional: specific tags to run (e.g., `@desktop`, `@validation`)

## Context Loading (MUST do before proceeding)

Before running tests and analyzing reports, load the full webship-js context:

### 1. Read the official documentation
Fetch and read the following pages:
- https://webship.co/docs/webship-js/2.0.x
- https://webship.co/docs/webship-js/2.0.x/step-definitions
- https://webship.co/docs/webship-js/2.0.x/api-step-definitions
- https://webship.co/docs/webship-js/2.0.x/assertions
- https://webship.co/docs/webship-js/2.0.x/commands
- https://webship.co/docs/webship-js/2.0.x/global-settings

### 2. Read webship-js source code
Read the source code from local `node_modules/webship-js/` if it exists, otherwise fetch from https://github.com/webship/webship-js (branch `2.0.x`):

**Step definition source code (needed to understand failures):**
- `node_modules/webship-js/tests/step-definitions/webship.js` — all UI step definitions
- `node_modules/webship-js/tests/step-definitions/webship-api.js` — all API step definitions

**Example .feature files (needed to compare patterns):**
- `node_modules/webship-js/tests/features/*.feature` — all 49 example feature files

**Configuration and reporting:**
- `node_modules/webship-js/cucumber.js` — default Cucumber config
- `node_modules/webship-js/generate-reports.js` — report generator source

### 3. Read existing project files
Read ALL of these from the current project:
- `cucumber.js` — current configuration and launchUrl
- `playwright.config.ts` — browser settings
- `tests/features/*.feature` — all feature files being tested
- `tests/step-definitions/*.js` — custom step definitions
- `tests/reports/*.json` — any existing report data

### 4. Use loaded context for failure analysis
When analyzing failures, cross-reference:
- The failing step definition in `webship.js` or `webship-api.js` source code
- The step's usage pattern in the example `.feature` files
- The documentation for that step category
This ensures accurate root cause analysis and fix suggestions.

## Instructions

1. Verify the project has webship-js installed and configured.

2. Run the test suite:
   ```bash
   # Run all tests
   npm test

   # Or run specific tags
   npx cucumber-js --tags "$ARGUMENTS"
   ```

3. Generate the HTML report:
   ```bash
   node generate-reports.js
   ```

4. Read and analyze the JSON report:
   ```bash
   cat tests/reports/cucumber_report.json
   ```

5. Provide a summary including:
   - Total scenarios and steps
   - Passed / Failed / Skipped counts
   - Duration
   - Any failure details with root cause analysis
   - The report file path: `tests/reports/cucumber_report.html`

6. If there are failures, analyze each one:
   - Read the error message and stack trace
   - Look up the failing step in the webship-js source code to understand its implementation
   - Identify if it's a timing issue (add AJAX wait), selector issue, or actual bug
   - Suggest fixes with correct step syntax from the source code

## Report Format

```
## Test Results

| Metric | Count |
|--------|-------|
| Scenarios | X |
| Passed | X |
| Failed | X |
| Steps | X |
| Duration | Xs |

### Failures (if any)
- **Scenario**: "name" — **Error**: description — **Fix**: suggestion

### Report File
HTML: tests/reports/cucumber_report.html
JSON: tests/reports/cucumber_report.json
```

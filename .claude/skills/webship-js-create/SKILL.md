---
name: webship-js-create
description: Create webship-js BDD tests for a website page. Explores the page, authors .feature files with desktop+mobile scenarios, registers named selectors, handles AJAX timing, and runs the new suite.
---

# /webship-js-create — Author tests for a page

Create comprehensive BDD test scenarios for a website page using
[webship-js 2.0.x](https://webship.co/docs/webship-js/2.0.x).

## Arguments

- `$ARGUMENTS` — page path to test (e.g. `/contact`, `/login`, `/about`).
  If the project is DDEV-based, the `LAUNCH_URL` resolves to the DDEV primary
  URL inside the container.

## Prerequisites

- Project scaffolded (run `/webship-js-setup` first).
- `cucumber.js` has `launchUrl` set (or `LAUNCH_URL` env var is used).

## Context loading (read before writing any file)

### 1. Official docs

- https://webship.co/docs/webship-js/2.0.x
- https://webship.co/docs/webship-js/2.0.x/step-definitions
- https://webship.co/docs/webship-js/2.0.x/api-step-definitions
- https://webship.co/docs/webship-js/2.0.x/assertions
- https://webship.co/docs/webship-js/2.0.x/global-settings

### 2. Local webship-js source (source of truth for step phrasing)

- `node_modules/webship-js/tests/step-definitions/webship.js` — UI steps.
- `node_modules/webship-js/tests/step-definitions/webship-api.js` — API steps.
- `node_modules/webship-js/tests/step-definitions/webship-selectors.js` —
  named-selector registry + relative-position + viewport breakpoints.
- `node_modules/webship-js/tests/step-definitions/webship-screenshot.js` —
  screenshot steps.
- `node_modules/webship-js/tests/features/*.feature` — reference for natural
  Gherkin phrasing and category naming.

If not installed locally, fetch from
`https://github.com/webship/webship-js/tree/2.0.x`.

### 3. Current project

- `cucumber.js` — `launchUrl`, `minWaitTime`, registered selectors.
- `playwright.config.ts` — browser + viewport.
- `tests/features/*.feature` — avoid duplicates.
- `tests/step-definitions/*.js` — existing custom steps.
- `tests/selectors/*.json` — selector files referenced by `selectors.files`.

Only use steps that exist in the loaded source — regexes may differ between
minor releases.

## Instructions

### Phase 1 — explore the page

1. Read `cucumber.js` to get `launchUrl` (or use `LAUNCH_URL`).
2. Fetch the page HTML (`curl -sL <url>`) or use the Playwright MCP
   (`browser_navigate` + `browser_snapshot`). Identify:
   - Headings and content landmarks.
   - Forms (inputs, selects, checkboxes, radios, submit buttons).
   - Links (internal, external, `mailto:`, `tel:`).
   - Navigation, modals, AJAX-driven sections.
3. Note named regions you'll reuse across scenarios — those become named
   selectors in `cucumber.js` `worldParameters.selectors.css` or via
   `Given I define css selectors:` inside the feature.

### Phase 2 — create feature files

Name files `<page-slug>--<category>.feature` under `tests/features/`:

- `--page-load.feature` — page loads, key content visible (desktop + mobile).
- `--form-empty-submit.feature` — empty form shows required errors.
- `--form-invalid-<field>.feature` — invalid input shows validation.
- `--form-valid-<variant>.feature` — submit with required-only, then all fields.
- `--links.feature` — key links exist with correct `href`.

Tag scenarios: `@desktop`, `@mobile`, `@validation`, `@submission`,
`@links`, `@smoke`.

### Phase 3 — write scenarios

Use steps verified against `webship.js` / `webship-api.js` /
`webship-selectors.js` / `webship-screenshot.js`.

Viewport control (use the breakpoint registry, not raw pixel sizes):

```gherkin
Given I am viewing the site on a "xl" screen     # desktop
Given I am viewing the site on a "xs" screen     # mobile phone
```

Breakpoints ship with sensible defaults: `xs`, `sm`, `md`, `lg`, `xl`
(default), `xxl`, `xxxl`.

Example — contact form validation:

```gherkin
Feature: Contact form validation
  As an anonymous user
  I want errors shown on invalid submissions
  So that I know what to fix

  @desktop @validation
  Scenario: Empty form shows errors on desktop
    Given I am viewing the site on a "xl" screen
    Given I am on "/contact"
    When I press "Submit"
    And I wait for AJAX to finish
    Then I should see "Name field is required"

  @mobile @validation
  Scenario: Empty form shows errors on mobile
    Given I am viewing the site on a "xs" screen
    Given I am on "/contact"
    When I press "Submit"
    And I wait for AJAX to finish
    Then I should see "Name field is required"
```

Example — valid submission with data table:

```gherkin
@desktop @submission
Scenario: Valid submission with all fields
  Given I am on "/contact"
  When I fill in the following:
    | Full name | Rajab Natshah       |
    | Email     | r@example.com       |
    | Subject   | Hello               |
    | Message   | Greetings from test |
  And I check "Accept terms"
  And I press "Submit"
  And I wait for AJAX to finish
  Then I should see "Thanks for your message"
  And I should be on "/contact/thanks"
```

Example — link attribute assertion:

```gherkin
@desktop @links
Scenario: Email link uses mailto
  Given I am on "/contact"
  Then the "Email us" link should contain "mailto:hello@example.com"
```

### Phase 4 — handle edge cases

- **AJAX / form submit.** `When I press "Submit"` only clicks. Always chain
  `And I wait for AJAX to finish` or `And I wait until the page is loaded`
  before asserting on the result.
- **Auto-dismissing messages.** If the site fades status messages (e.g.
  Drupal), lower `worldParameters.minWaitTime.page` from `3000` to `500` so
  the assertion runs before the message disappears.
- **Rate limiting / flood control.** Write a custom step in
  `tests/step-definitions/custom.js` that accepts either outcome (e.g. polls
  for success message OR rate-limit text).
- **HTML attributes.** `Then the response should contain` checks text, not
  attributes. Use the link-by-attribute form for hrefs:
  `Then the "contact" link should contain "mailto:" by its "href" attribute`.
- **Duplicate text.** Scope assertions with named selectors:
  `Then I should see "Saved" in the "success message" element`.

### Phase 5 — run

Plain Node.js:

```bash
# all tests
npm test
# single file
npx cucumber-js --config cucumber.js tests/features/contact--form-empty-submit.feature
# tag filter
npx cucumber-js --config cucumber.js --tags "@desktop and @validation"
# different browser
BROWSER=firefox npm test
```

DDEV:

```bash
ddev npm run test:chromium
ddev exec npx cucumber-js --config cucumber.js tests/features/contact--form-empty-submit.feature
```

### Phase 6 — report

An HTML report is auto-generated after each run. Regenerate manually:

```bash
npm run generate-reports
# or
npx generate-reports
```

Report paths:

- `tests/reports/cucumber_report.json`
- `tests/reports/cucumber_report.html`

Summarize to the user: total scenarios, pass/fail counts, any failures with
root cause + suggested fix.

## Custom step pattern

```js
// tests/step-definitions/custom.js
const { Given, When, Then } = require('@cucumber/cucumber');

When('I wait for rate limit or success', async function () {
  await this.page.waitForFunction(() => {
    const body = document.body.innerText;
    return /Thanks|too many requests/i.test(body);
  }, { timeout: 30000 });
});
```

World object: `this.page`, `this.context`, `this.playwrightBrowser`,
`this.launchUrl`, `this.minWaitTime`, `this.assetsFolder`.

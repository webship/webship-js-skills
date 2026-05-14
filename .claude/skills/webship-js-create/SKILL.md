---
name: webship-js-create
description: Author webship-js BDD tests for a website page. Explores the page, writes .feature files with desktop+mobile scenarios, registers named selectors, picks the right step category from the installed catalog (UI, web-first, API/REST, a11y, iframe, clock, network, cookies, storage, video, XML/YAML), handles AJAX timing, and runs the new suite.
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

Recent webship-js is modular — one `<category>.steps.js` per category in
`node_modules/webship-js/tests/step-definitions/`. List what's installed
first (`ls node_modules/webship-js/tests/step-definitions/`), then read the
files relevant to the page under test:

- `navigation.steps.js`, `path.steps.js`, `action.steps.js` — go-to / back /
  pointer / drag / tap.
- `form.steps.js`, `input.steps.js`, `field.steps.js` — fill / select /
  check / radio / multi-value / color / WYSIWYG / datetime.
- `wait.steps.js` — AJAX, network-idle, element appear/disappear, eventual.
- `assertion.steps.js`, `element.steps.js`, `link.steps.js` — visible-text,
  element existence, link href.
- `web-first.steps.js` — auto-wait assertions
  (`"<sel>" should be visible/contain text/have value within N seconds`).
- `modal.steps.js`, `dialog.steps.js` — in-page modals + browser
  alert/confirm/prompt.
- `iframe.steps.js` — switch / click / fill inside iframe.
- `selectors.steps.js` — named-selector registry, relative position,
  viewport breakpoints, focus/selection.
- `responsive.steps.js` — explicit viewport sizing.
- `keyboard.steps.js` — key + chord presses.
- `screenshot.steps.js`, `video.steps.js` — capture.
- `cookie.steps.js`, `storage.steps.js` — cookies + local/session storage.
- `network.steps.js` — mock URL responses, offline/online, request
  recording.
- `clock.steps.js` — system time + advance.
- `auth.steps.js` — basic-auth + save/restore Playwright auth state.
- `api.steps.js`, `rest.steps.js`, `response.steps.js` — HTTP requests +
  headers + JSON.
- `xml.steps.js`, `yaml.steps.js` — XML/YAML response assertions +
  JSON-Schema match.
- `a11y.steps.js` — axe-core audit + structural checks.
- `table.steps.js` — row/column/sort/contents.
- `file-download.steps.js` — verify downloaded files + zip contents.
- `metatag.steps.js` — `<meta>` attribute assertions.
- `javascript.steps.js` — JS-error capture.
- `debug.steps.js` — `print current URL`, `print last response`.

Plus `node_modules/webship-js/tests/features/*.feature` for real usage
samples. If not installed locally, fetch the same files from
https://github.com/webship/webship-js/tree/2.0.x.

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
- `--a11y.feature` — axe-core audit + structural a11y checks.
- `--mobile.feature` — mobile-only viewport coverage.

Tag scenarios:

| Tag             | Use                                              |
|-----------------|--------------------------------------------------|
| `@desktop`      | Desktop viewport (pair with `xl` screen).        |
| `@mobile`       | Mobile viewport (pair with `xs` screen).         |
| `@smoke`        | Minimum-viable run.                              |
| `@validation`   | Empty / invalid form submits.                    |
| `@submission`   | Valid form submits.                              |
| `@links`        | Link / href checks.                              |
| `@a11y`         | Accessibility audits.                            |
| `@video`        | Force-record this scenario.                      |
| `@no-video`     | Suppress recording.                              |
| `@js-fail`      | Fail if JS error captured during scenario.       |
| `@js-warn`      | Warn only (default).                             |
| `@js-off`       | Suppress JS-error capture.                       |

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

Example — web-first assertion (auto-waits, less flaky than explicit waits):

```gherkin
@desktop @submission
Scenario: Submit shows success without explicit wait
  Given I am on "/contact"
  When I fill in "email" with "user@example.com"
  And I press "Submit"
  Then ".success-message" should be visible within 5 seconds
  And ".success-message" should contain text "Thanks for your message"
```

Example — accessibility audit:

```gherkin
@desktop @a11y
Scenario: Contact page meets WCAG AA
  Given I am on "/contact"
  Then the page should have a title
  And the page should declare a language
  And every form field should have an accessible label
  And the page should pass an accessibility audit at level "AA"
```

Example — network-mocked SPA:

```gherkin
@desktop
Scenario: Dashboard renders user list from mocked API
  Given the URL "/api/users" returns the JSON:
    """
    [{ "id": 1, "name": "Rajab" }]
    """
  Given I am on "/dashboard"
  Then "h1" should have text "Welcome, Rajab" within 5 seconds
```

### Phase 4 — handle edge cases

- **Prefer web-first.** When in doubt, use
  `Then "<selector>" should be visible/contain text/have value within N seconds`
  (`web-first.steps.js`). Auto-waits, way less flaky than chaining
  `wait for AJAX to finish`.
- **AJAX / form submit.** `When I press "Submit"` only clicks. Chain
  `And I wait for AJAX to finish`, `And I wait until the page is loaded`,
  or a web-first assertion before asserting on the result.
- **Auto-dismissing messages.** Lower `worldParameters.minWaitTime.page`
  from `3000` to `500` so assertions run before the message fades.
- **Rate limiting / flood control.** Write a custom step in
  `tests/step-definitions/custom.js` that polls for either outcome
  (success OR rate-limit text).
- **HTML attributes.** `the response should contain` checks **text**, not
  attributes. Use either the link-by-attribute form
  (`Then the "contact" link should contain "mailto:" by its "href" attribute`)
  or the element-attribute form
  (`Then the element ".cta" with the attribute "data-test" and the value "primary" should exist`).
- **Duplicate text.** Scope assertions with named selectors or web-first:
  `Then "#success" should contain text "Saved" within 3 seconds`.
- **Iframes.** Always `When I switch to the iframe "<sel>"` first, then run
  `... inside the iframe` steps, then `When I switch to the root document`.
- **Time-dependent UI.** Use clock steps
  (`Given the system time is "..."`, `When I advance the clock by N minutes`).
- **External APIs in CI.** Mock with `Given the URL "..." returns the JSON:`
  rather than hitting real services.

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
# watch the browser (debug)
npm run test:headed
# fastest run (no slow-mo)
npm run test:fast
# record video of failures
WEBSHIP_VIDEO=on-failure npm test
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

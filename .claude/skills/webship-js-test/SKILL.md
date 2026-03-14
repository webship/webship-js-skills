---
name: webship-js-test
description: Create and run webship-js BDD tests for a website page. Explores the page, creates .feature files with desktop+mobile scenarios, handles AJAX forms, and runs the suite.
---

# /webship-js-test — Create & Run Tests for a Page

Create comprehensive BDD test scenarios for a website page using webship-js 2.0.

## Arguments

- `$ARGUMENTS` — The page path to test (e.g., `/contact`, `/login`, `/about`)

## Prerequisites

- webship-js project must be set up (use `/webship-js-setup` first)
- `cucumber.js` must have correct `launchUrl`

## Context Loading (MUST do before proceeding)

Before creating tests, load the full webship-js context:

### 1. Read the official documentation
Fetch and read ALL of the following pages:
- https://webship.co/docs/webship-js/2.0.x
- https://webship.co/docs/webship-js/2.0.x/step-definitions
- https://webship.co/docs/webship-js/2.0.x/api-step-definitions
- https://webship.co/docs/webship-js/2.0.x/assertions
- https://webship.co/docs/webship-js/2.0.x/commands
- https://webship.co/docs/webship-js/2.0.x/global-settings

### 2. Read webship-js source code
Read the source code from local `node_modules/webship-js/` if it exists, otherwise fetch from https://github.com/webship/webship-js (branch `2.0.x`):

**Step definition source code (read ALL — this is the source of truth for available steps):**
- `node_modules/webship-js/tests/step-definitions/webship.js` — all UI step definitions
- `node_modules/webship-js/tests/step-definitions/webship-api.js` — all API step definitions

**Example .feature files (read ALL for patterns, conventions, and naming):**
- `node_modules/webship-js/tests/features/*.feature` — all 49 example feature files
  These include examples for: navigation, forms, clicks, scrolling, modals, AJAX waits,
  assertions, checkboxes, radio buttons, file uploads, links, tables, API testing, etc.

**Example HTML test pages (read to understand test page structure):**
- `node_modules/webship-js/examples/*.html` — all 30 example HTML pages

**Configuration files:**
- `node_modules/webship-js/cucumber.js` — default Cucumber config
- `node_modules/webship-js/playwright.config.ts` — default Playwright config

### 3. Read existing project files
Read ALL of these from the current project:
- `cucumber.js` — get launchUrl and configuration
- `playwright.config.ts` — get browser settings
- `tests/features/*.feature` — existing feature files (avoid duplicates)
- `tests/step-definitions/*.js` — existing custom step definitions
- `tests/assets/*` — existing test assets

### 4. Use loaded context
- Only use step definitions that exist in the source code (`webship.js` and `webship-api.js`)
- Follow the naming conventions from the example `.feature` files
- Match the Gherkin style and patterns from the examples

## Instructions

### Phase 1: Explore the Page

1. Read `cucumber.js` to get the `launchUrl`.
2. Use the Playwright MCP browser to navigate to the page.
3. Take a snapshot and identify all testable elements:
   - Forms (inputs, selects, checkboxes, radio buttons, submit buttons)
   - Links (internal, external, mailto, tel)
   - Navigation elements
   - Content sections and headings
   - Modal dialogs
   - Dynamic/AJAX content

### Phase 2: Create Feature Files

Create `.feature` files in `tests/features/` using descriptive naming:
`<page>--<test-category>.feature`

**Required test categories:**

1. **Page Load** (`--page-load.feature`):
   - Page loads successfully on desktop
   - Key content is visible
   - Page loads on mobile viewport

2. **Form Validation** (`--form-empty-submit.feature`, `--form-invalid-*.feature`):
   - Empty form submission shows required field errors
   - Invalid input shows validation errors
   - Both desktop and mobile

3. **Form Valid Submission** (`--form-valid-*.feature`):
   - Submit with required fields only
   - Submit with all fields filled
   - Handle rate limiting with custom step if needed

4. **Links** (`--*-link.feature`):
   - Links are present and have correct hrefs
   - Both desktop and mobile

### Phase 3: Write Scenarios

Use webship-js step definitions. Critical rules:

- **ALWAYS** add `And I wait for AJAX to finish` after `And I press "Submit"`
- Use `I should see "text"` for visible text assertions
- Use `the "selector" link should contain "value" by "href" attr` for link attributes
- Use `the response should contain "text"` for HTML text content checks
- Tag scenarios: `@desktop`, `@mobile`, `@validation`, `@submission`, `@links`

Example pattern:
```gherkin
Feature: Contact form validation
  As an anonymous user
  I want to see errors when submitting invalid data
  So that I know what to fix

  @desktop @validation
  Scenario: Empty form shows errors on desktop
    Given I am on "/contact"
    When I press "Submit"
    And I wait for AJAX to finish
    Then I should see "Name field is required."
```

### Phase 4: Handle Edge Cases

- **Rate limiting**: Create custom step in `tests/step-definitions/custom.js` using `page.waitForFunction()` to poll for multiple outcomes
- **AJAX forms**: The `I press` step only clicks — it does NOT wait for page load
- **Auto-dismissing messages**: Reduce `minWaitTime.page` to 500ms in `cucumber.js`
- **HTML attributes**: Use attribute assertions, not `the response should contain`

### Phase 5: Run Tests

```bash
npm test
```

Or run specific tags:
```bash
npx cucumber-js --tags "@desktop"
npx cucumber-js --tags "@validation"
```

### Phase 6: Report

```bash
node generate-reports.js
```

Report the results: total scenarios, passed/failed, any issues found.

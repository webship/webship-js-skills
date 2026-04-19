---
name: webship-js-steps
description: Quick reference for every webship-js step definition — Given/When/Then UI, selector, screenshot, and API steps — with usage examples pulled from the installed source.
---

# /webship-js-steps — Step definition reference

Display available webship-js 2.0.x step definitions.

## Arguments

- `$ARGUMENTS` — optional filter: `navigation`, `form`, `click`, `wait`,
  `scroll`, `assert`, `element`, `link`, `field`, `checkbox`, `radio`,
  `modal`, `selector`, `viewport`, `position`, `screenshot`, `api`,
  `debug`, or `all` (default).

## Context loading (source of truth)

- `node_modules/webship-js/tests/step-definitions/webship.js` — UI steps.
- `node_modules/webship-js/tests/step-definitions/webship-api.js` — API.
- `node_modules/webship-js/tests/step-definitions/webship-selectors.js` —
  named-selector registry, breakpoints, relative-position assertions.
- `node_modules/webship-js/tests/step-definitions/webship-screenshot.js` —
  screenshot capture.
- `node_modules/webship-js/tests/features/*.feature` — real usage samples.

If webship-js is not installed locally, fetch the same files from
`https://github.com/webship/webship-js/tree/2.0.x`.

Also scan the current project:

- `tests/step-definitions/*.js` — custom steps (include these in the output).
- `tests/features/*.feature` — existing patterns to stay consistent with.

Every step supports `I` / `we` pronouns (optional). `the`, `a`, `an` tokens
are often optional too — check each regex before claiming a variant.

## Reference

### Context (Given)

```gherkin
Given I am an anonymous user
Given I am on the homepage
Given I am on "/login"
Given I define css selectors:
  | name         | css selector    |
  | login button | button.login    |
Given I define xpath selectors:
  | name       | xpath                  |
  | page title | //h1[@class='title']   |
```

### Viewport

```gherkin
Given I am viewing the site on a "xl" screen
Given I am viewing the site on a "xs" device
# built-in breakpoints: xs, sm, md, lg, xl (default), xxl, xxxl
```

### Navigation (When)

```gherkin
When I go to the homepage
When I go to "/about"
When I reload the page
When I move forward one page
When I move backward one page
When I follow "Read more"
```

### Form input

```gherkin
When I fill in "email" with "user@example.com"
When I fill in "email-field" with "user@example.com" by its "id" attribute
When I fill in "message" with:
  """
  multi-line value
  """
When I fill in "user@example.com" for "email"
When I fill in the following:
  | Email | user@example.com |
  | Name  | Rajab            |
When I select "Option 1" from "Country"
When I additionally select "Option 2" from "Countries"
When I check "Accept terms"
When I uncheck "Subscribe"
When I select radio button "Male"
When I attach the file "resume.pdf" to "Upload CV"
```

### Click / press

```gherkin
When I press "Submit"
When I press "login-btn" by its "id" attribute
When I click "Read more"
When I click "login-btn" by its "id" attribute
When I click "Edit" in the "Order #123" row
# positional (requires named selector):
When I click login button
When I click login button, submit button
```

### Selection / focus

```gherkin
When I move focus to "email" field
When I select all text in "email" field
When I select from 0 to 5 text in "email" field
When I select "user" text in "email" field
```

### Scroll

```gherkin
When I scroll down
When I scroll down 500
When I scroll up 100
When I scroll to the top
When I scroll to the bottom
When I scroll right 200
When I scroll left
When I scroll to the start
When I scroll to the end
When I scroll to top of "main nav"
When I scroll to bottom of "footer"
When I scroll to start of "carousel"
When I scroll to end of "carousel"
```

### Waits

```gherkin
When I wait 2 seconds
When I wait max of 5 seconds
When I wait 1 minute
When I wait until the page is loaded
When I wait for AJAX to finish
```

### Modals

```gherkin
When I click "Close" in the modal
When I close the modal
When I dismiss the modal dialog
When I wait for the modal to appear
When I wait for the modal to disappear
Then I should see a modal
Then I should see a modal with title "Confirm delete"
Then I should see a "confirm" modal
Then I should see "Are you sure?" in the modal
```

### Selector registry

```gherkin
When I add "header" selector for "header.page-header" css selector
When I add "page title" selector for "//h1[@class='title']" xpath selector
When I add selectors from "homepage-selectors.json" file
Then I print css selectors
Then I print xpath selectors
```

### Text assertions (Then)

```gherkin
Then I should see "Welcome back"
Then I should not see "Error"
Then I should see "Submitted" in the "success message" element
Then I should not see "Error" in the "status" element by its "id" attribute
Then I should see text matching "Order #\d+"
Then I should see text matching "Order #\d+" in the "summary" element
Then I should see "Yes" in the "Order #123" row
Then I should not see "No" in the "Order #123" row
```

### Location assertions

```gherkin
Then I should be on the homepage
Then I should not be on the homepage
Then I should be on "/dashboard"
Then I should not be on "/admin"
Then the url should match "^/users/\d+$"
Then the url should not match "login"
```

### Element assertions

```gherkin
Then I should see a "submit button" element
Then I should not see an "error icon" element
Then I should see a "submit-btn" element by its "id" attribute
Then I should see 3 ".card" elements
Then the "main nav" element should contain "Home"
Then the "status" element should not contain "Error"
Then the "message" element should contain css property "color:rgb(255, 0, 0)"
Then the "message" element should not contain css property "display:none"
```

### Link assertions

```gherkin
Then the "Read more" link should contain "/articles/42"
Then the "read-more" link should contain "/articles/42" by its "id" attribute
# HTML attribute check (href/src/etc.) — use the link form, not `response should contain`
Then the "Contact" link should contain "mailto:hello@example.com"
```

### Field / checkbox / radio

```gherkin
Then the "email" field should contain "user@example.com"
Then the "email" field should not contain "admin"
Then the "Accept" checkbox should be checked
Then the "Newsletter" checkbox is not checked
Then the checkbox "accept-terms" is checked
Then the "Male" radio button is selected
Then the radio button with value "yes" should be selected
```

### HTTP response

```gherkin
Then the response status code should be 200
Then the response should contain "OK"
Then the response should not contain "Access denied"
```

### Relative position (named selectors required)

```gherkin
Then I see logo above main nav
Then I see footer below main content
Then I see sidebar to the left of article
Then I see close icon to the right of title
Then I see avatar inside of header
Then I see tooltip outside of form
Then I see modal over backdrop
Then I see hero not over header
Then I see visible submit button
Then I don't see error message
Then I see email field has focus
```

### Screenshots

```gherkin
When I save screenshot
When I save fullscreen screenshot
When I save 1280 x 800 screenshot
When I save fullscreen 1280 x 800 screenshot
When I save screenshot with name "login-filled"
When I save fullscreen screenshot with name "checkout-cart"
```

Env vars: `WEBSHIP_SCREENSHOT_DIR`, `WEBSHIP_SCREENSHOT_ON_FAILED`,
`WEBSHIP_SCREENSHOT_ON_EVERY_STEP`, `WEBSHIP_SCREENSHOT_FULLSCREEN`,
`WEBSHIP_SCREENSHOT_PURGE`, `WEBSHIP_SCREENSHOT_PATTERN`,
`WEBSHIP_SCREENSHOT_PATTERN_FAIL`, `WEBSHIP_SCREENSHOT_INFO_TYPES`.

Filename placeholders: `{datetime}`, `{feature_file}`, `{step_line}`,
`{ext}`, `{failed_prefix}`.

### API — setup

```gherkin
Given the API base URL is "https://api.example.com"
Given I am authenticating as "admin" with "secret" password
Given I set header "X-Api-Key" with value "abc123"
Given I set the header "Accept" to "application/json"
Given I set the following headers:
  | X-Api-Key | abc123           |
  | Accept    | application/json |
Given I set the request body to '{"name":"Rajab"}'
Given I set the request body with:
  | name  | Rajab            |
  | email | r@example.com    |
Given I set placeholder "userId" to "42"
```

### API — send

```gherkin
When I send a GET request to "/users/:userId"
When I send a POST request to "/users" with values:
  | name  | Rajab            |
  | email | r@example.com    |
When I send a POST request to "/users" with body:
  """
  { "name": "Rajab" }
  """
When I send a POST request to "/users" with form data:
  """
  name=Rajab&email=r%40example.com
  """
```

### API — assert

```gherkin
Then the API response code should be 200
Then the API response should contain "Rajab"
Then the API response should not contain "error"
Then the API response should contain json:
  """
  { "ok": true }
  """
Then the JSON response should have "data.id" equal to 42
Then the JSON response should have property "data.email"
Then the JSON response should not have property "password"
Then the response should be valid JSON
Then the response header "Content-Type" should contain "application/json"
Then print API response
```

### Debug

```gherkin
Then print current URL
Then print last response
Then I print css selectors
Then I print xpath selectors
```

## Critical tips

1. **Always wait after `I press` / submit.** Chain `And I wait for AJAX to finish`.
2. **Use attribute-based link assertion** for `href`, not `response should contain`.
3. **Selector lookup** tries label → placeholder → name → id → css class.
4. **Named selectors win** when text is ambiguous. Register once, reuse.
5. **Custom steps** go in `tests/step-definitions/custom.js`; they auto-load
   via `cucumber.js` `require:`.
6. **Source of truth:** `webship.js`, `webship-api.js`, `webship-selectors.js`,
   `webship-screenshot.js` — always verify phrasing there before committing.

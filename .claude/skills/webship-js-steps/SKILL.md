---
name: webship-js-steps
description: Quick reference for every webship-js step definition installed in the current project. Covers UI, web-first auto-wait assertions, API + REST, a11y (axe-core), iframe, clock, network mocking, cookies + storage, video recording, XML/YAML, screenshots, tables, file downloads, JS-error capture, and more. Filter by category.
---

# /webship-js-steps — Step definition reference

Display available webship-js step definitions.

## Arguments

- `$ARGUMENTS` — optional category filter. Categories map to files in
  `node_modules/webship-js/tests/step-definitions/`:

  `a11y`, `action`, `api`, `assertion`, `auth`, `clock`, `cookie`, `debug`,
  `dialog`, `element`, `field`, `file-download`, `form`, `iframe`, `input`,
  `javascript`, `keyboard`, `link`, `metatag`, `modal`, `navigation`,
  `network`, `path`, `response`, `responsive`, `rest`, `screenshot`,
  `scroll`, `selectors`, `storage`, `table`, `video`, `wait`, `web-first`,
  `xml`, `yaml`, or `all` (default).

## Context loading (source of truth)

- `node_modules/webship-js/tests/step-definitions/*.steps.js` — one file
  per category; the installed catalog defines what's available in the
  current version.
- `node_modules/webship-js/tests/features/*.feature` — real usage samples.

If webship-js is not installed locally, fetch the same files from
https://github.com/webship/webship-js/tree/2.0.x.

Steps below reflect the catalog at the time of writing. Skip anything the
installed source does not include.

Also scan the current project:

- `tests/step-definitions/*.js` — custom steps (include these in the
  output).
- `tests/features/*.feature` — existing patterns to stay consistent with.

Every step supports `I` / `we` pronouns (optional). `the`, `a`, `an`
tokens are often optional too — verify against each regex before
recommending a variant.

## Reference

### Context (Given) — `navigation.steps.js` / `selectors.steps.js`

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

### Viewport — `selectors.steps.js` + `responsive.steps.js`

```gherkin
Given I am viewing the site on a "xl" screen          # built-in breakpoints
Given I am viewing the site on a "xs" device
Given the following responsive breakpoints:
  | name | width | height |
  | xs   | 375   | 667    |
When I set the viewport to the "md" breakpoint
When I set the viewport width to 1024
When I set the viewport height to 768
When I set the viewport to 1280 by 800
When I set the viewport size to 1280x800
# breakpoints: xs, sm, md, lg, xl (default), xxl, xxxl
```

### Navigation — `navigation.steps.js`

```gherkin
When I go to the homepage
When I go to "/about"
When I reload the page
When I move forward one page
When I move backward one page
When I go back
When I follow "Read more"
```

### Path / URL — `path.steps.js`

```gherkin
Then the path should be "/dashboard"
Then the path should not be "/admin"
Then current url should have the "tab" parameter
Then current url should have the "tab" parameter with the "billing" value
Then current url should not have the "ref" parameter
Then I should be on "/dashboard"
Then the url should not match "login"
```

### Pointer / mouse / drag / tap — `action.steps.js`

```gherkin
When I hover over "main nav"
When I move the pointer to "main nav"
When I double-click on "row 3"
When I right-click on "row 3"
When I middle-click on "row 3"
When I click on "row 3" while holding "Shift"
When I drag "card-1" to "drop-zone"
When I tap on "menu"
```

### Form input — `form.steps.js` + `input.steps.js`

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
# selector-based variants:
When I fill in the field "#email" with "user@example.com"
When I check the checkbox "#accept"
When I uncheck the checkbox "#newsletter"
When I choose the radio button "input[value='yes']"
When I unselect "Option 1" from "#country"
When I clear the select "#country"
Given browser validation for the form "#contact" is disabled
```

### Field state + advanced inputs — `field.steps.js`

```gherkin
Then the field "#email" should be empty
Then the field "#email" should not be empty
Then the field "#email" should exist
Then the field "#email" should not exist
Then the field "#email" should be required
Then the field "#email" should not be required
Then the field "#name" should have "valid" state
# multi-value / specialized:
When I fill in the multi-value field "Tags" with the following values:
  | red |
  | green |
When I fill in the color field "Theme" with the value "#ff0000"
Then the color field "Theme" should have the value "#ff0000"
When I fill in the WYSIWYG field "Body" with the "<p>hello</p>"
# datetime:
When I fill in the datetime field "Start" with date "2026-05-14" and time "09:30"
When I fill in the date part of the datetime field "Start" with "2026-05-14"
When I fill in the time part of the datetime field "Start" with "09:30"
When I fill in the start datetime field "Range" with date "2026-05-14" and time "09:00"
When I fill in the end datetime field "Range"   with date "2026-05-14" and time "18:00"
# <select>:
Then the option "Egypt" should exist within the select element "#country"
Then the option "Egypt" should be selected within the select element "#country"
```

### Click / press — `action.steps.js`

```gherkin
When I press "Submit"
When I press "login-btn" by its "id" attribute
When I click "Read more"
When I click "login-btn" by its "id" attribute
When I click "Edit" in the "Order #123" row
When I click on the element "main nav"
When I click the "Sign in" button       # role-based
When I click the "Profile" link
When I click the "Tab 2" tab
When I attach the file "resume.pdf" to "Upload CV"
# positional (requires named selector):
When I click login button
When I click login button, submit button
```

### Keyboard — `keyboard.steps.js`

```gherkin
When I press the key "Enter"
When I press the key "Tab" on the element "#email"
When I press the keys "Control+S"
When I press the keys "Control+Shift+P" on the element "body"
```

### Focus / selection — `selectors.steps.js`

```gherkin
When I move focus to "email" field
When I select all text in "email" field
When I select from 0 to 5 text in "email" field
When I select "user" text in "email" field
```

### Scroll — `scroll.steps.js`

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
When I scroll to the element "#section-3"
```

### Waits — `wait.steps.js`

```gherkin
When I wait 2 seconds
When I wait max of 5 seconds
When I wait 1 minute
When I wait until the page is loaded
When I wait for AJAX to finish
When I wait for 5 seconds for AJAX to finish
When I wait for "#status" to appear
When I wait for "#spinner" to disappear
When I wait for the text "Saved" to appear
When I wait for the text "Loading" to disappear
When I wait until the URL contains "/dashboard"
When I wait until the page title is "Dashboard"
When I wait until the page title contains "Welcome"
When I wait until 3 elements match ".card"
When I wait until at least 1 elements match ".alert"
When I wait until the network is idle
When I wait until the page is interactive
When I wait until pending timers settle
When eventually I should see "Connected"
When eventually I should see "Connected" within 10 seconds
```

### Clock mocking — `clock.steps.js`

```gherkin
Given the system time is "2026-01-01T00:00:00Z"
When I advance the clock by 500 ms
When I advance the clock by 30 seconds
When I advance the clock by 5 minutes
When I pause the clock
When I resume the clock
When I set the system time to "2026-06-15T12:00:00Z"
```

### Network mocking — `network.steps.js`

```gherkin
Given the URL "/api/users" returns the JSON:
  """
  [{ "id": 1, "name": "Rajab" }]
  """
Given the URL "/api/users/42" returns status 404
Given the URL "/api/users/42" returns status 500 with body "boom"
Given the URL "/api/slow" is delayed by 2000 ms
Given the URL "/api/secret" is blocked
Given the network is offline
Given the network is online
Given I start recording network requests
Then a request to "/api/users" should have been made
Then a POST request to "/api/users" should have been made
Then no request to "/api/analytics" should have been made
```

### Storage — `storage.steps.js`

```gherkin
Given the local storage "token" is set to "abc123"
Given the local storage "token" is removed
Given local storage is cleared
Given the session storage "tab" is set to "billing"
Given the session storage "tab" is removed
Given session storage is cleared
```

### Cookies — `cookie.steps.js`

```gherkin
Given the cookie "session_id" is set to "abc123"
Given the cookie "session_id" is removed
Given all cookies are cleared
Then a cookie with the name "session_id" should exist
Then a cookie with the name "session_id" and the value "abc123" should exist
Then a cookie with the name "session_id" and a value containing "abc" should exist
Then a cookie with a name containing "session" should exist
Then a cookie with the name "tracker" should not exist
```

### Auth — `auth.steps.js`

```gherkin
Given the basic authentication with the username "admin" and the password "secret"
When I save the auth state to "./auth/admin.json"
Given I restore the auth state from "./auth/admin.json"
Given I clear the auth state
```

### Modals + browser dialogs — `modal.steps.js` + `dialog.steps.js`

```gherkin
Then I should see a modal
Then I should see a modal with title "Confirm delete"
Then I should see a "confirm" modal
Then I should see "Are you sure?" in the modal
Then the modal should contain "Are you sure?"
When I click "Yes" in the modal
When I click on ".confirm-btn" in the modal
When I close the modal
When I dismiss the modal dialog
# browser alert/confirm/prompt:
Given I will accept the next dialog
Given I will accept the next dialog with "my answer"
Given I will dismiss the next dialog
Given I accept all confirmation dialogs
Given I do not accept any confirmation dialogs
Then the last dialog message should be "Are you sure?"
Then the last dialog message should contain "Are you"
Then the last dialog type should be "confirm"
```

### iframe — `iframe.steps.js`

```gherkin
When I switch to the iframe "#payment-frame"
When I switch to iframe with locator ".stripe-frame"
When I switch to the iframe with title "Payment form"
When I switch to the iframe with name "checkout"
When I switch to the root document
When I click "Pay" inside the iframe
When I click "pay-btn" by attr inside the iframe
When I fill in "Card number" with "4242 4242 4242 4242" inside the iframe
Then I should see "Approved" inside the iframe
Then I should not see "Declined" inside the iframe
```

### Selector registry — `selectors.steps.js`

```gherkin
When I add "header" selector for "header.page-header" css selector
When I add "page title" selector for "//h1[@class='title']" xpath selector
When I add selectors from "homepage-selectors.json" file
Then I print css selectors
Then I print xpath selectors
```

### Text assertions — `assertion.steps.js`

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

### Element assertions — `element.steps.js`

```gherkin
Then I should see a "submit button" element
Then I should not see an "error icon" element
Then I should see a "submit-btn" element by its "id" attribute
Then I should see 3 ".card" elements
Then the "main nav" element should contain "Home"
Then the "status" element should not contain "Error"
Then the element ".card-2" should appear after the element ".card-1"
Then the text "Footer" should appear after the text "Body"
Then the element ".cta" with the attribute "data-test" and the value "primary" should exist
Then the element ".cta" with the attribute "data-test" and the value containing "prim" should exist
Then the element "#hero" should be at the top of the viewport
Then the element "#hero" should be centered in the viewport
Then the element "#hero" should be displayed
Then the element "#hero" should not be displayed
Then the element "#hero" should be displayed within a viewport
Then the element "#hero" should be displayed within a viewport with a top offset of 80 pixels
When I trigger the JS event "change" on the element "#country"
When I hover over the element "main nav"
When I focus on the element "#email"
```

### Web-first assertions (auto-wait) — `web-first.steps.js`

```gherkin
Then ".submit-btn" should be visible
Then ".submit-btn" should be visible within 5 seconds
Then ".spinner" should not be visible
Then ".confirm" should be focused within 2 seconds
Then "#submit" should be enabled
Then "#submit" should be disabled
Then "input[name=email]" should be editable
Then ".card" should be in the viewport
Then ".card" should not be in the viewport
Then ".card" should have a count of 3 within 5 seconds
Then "h1" should have text "Welcome"
Then "h1" should contain text "Welcome"
Then "input[name=email]" should have value "user@example.com"
Then "img.logo" should have attribute "alt" with value "Company"
Then "button" should have class "primary"
Then the "Sign in" button should be visible
Then the "Profile" link should be visible within 2 seconds
```

### Links — `link.steps.js`

```gherkin
Then the "Read more" link should contain "/articles/42"
Then the "read-more" link should contain "/articles/42" by its "id" attribute
Then the link "Read more" with the href "/articles/42" should exist
Then the link "Read more" with the href "/articles/42" within the element ".card" should exist
Then the link with the title "Open menu" should exist
Then the link "Documentation" should be an absolute link
Then the link "Home" should not be an absolute link
When I click on the link with the title "Open menu"
```

### HTTP response — `response.steps.js`

```gherkin
Then the response should contain "OK"
Then the response should not contain "Access denied"
Then the response status code should be 200
Then the response status code should not be 500
Then the response should contain the header "Content-Type"
Then the response should not contain the header "X-Internal"
Then the response header "Content-Type" should contain the value "application/json"
Then the response header "Cache-Control" should not contain the value "no-store"
```

### REST shortcut — `rest.steps.js`

```gherkin
Given a REST header "Authorization" with value "Bearer xyz"
When I send a REST "GET" request to "https://api.example.com/users/42"
When I send a REST "POST" request to "https://api.example.com/users" with body:
  """
  { "name": "Rajab" }
  """
Then the REST response status code should be 200
Then the REST response should contain "Rajab"
```

### API (`api.steps.js`)

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

When I send a GET    request to "/users/:userId"
When I send a POST   request to "/users" with values:
  | name  | Rajab            |
  | email | r@example.com    |
When I send a POST   request to "/users" with body:
  """
  { "name": "Rajab" }
  """
When I send a POST   request to "/users" with form data:
  """
  name=Rajab&email=r%40example.com
  """

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

### XML response — `xml.steps.js`

```gherkin
Given the response content from the file "fixtures/users.xml"
Given the response content is the following:
  """
  <users><user id="1">Rajab</user></users>
  """
Then the response should be in XML format
Then the XML element "/users/user" should exist
Then the XML element "/users/user[@id='1']" should be equal to "Rajab"
Then the XML element "/users/user[@id='1']" should contain "Raj"
Then the XML element "/users/user" should have 1 element(s)
Then the XML attribute "id" on element "/users/user" should be equal to "1"
Then the XML should use the namespace "http://example.com/ns"
When I print last XML response
```

### YAML response — `yaml.steps.js`

```gherkin
Given the YAML response content from the file "fixtures/cfg.yml"
Given the YAML response content is the following:
  """
  users:
    - name: Rajab
      age: 30
  """
Given the active YAML document is 1
Then the YAML response should have 2 document(s)
Then the response should be in YAML format
Then the YAML should have no duplicate keys
Then the YAML element "users.0.name" should exist
Then the YAML element "users.0.name" should be equal to "Rajab"
Then the YAML element "users.0.name" should contain "Raj"
Then the YAML value at "users.0.age" should be of type "number"
Then the YAML value at "users.0.age" should be greater than 18
Then the YAML value at "users.0.age" should be between 18.0 and 99.0
Then the YAML array at "users" should contain an item where "name" is "Rajab"
Then every item in "users" should have key "email"
Then the YAML keys at "users.0" should be exactly "name,email"
Then the YAML should match JSON Schema "schemas/user.json"
When I print last YAML response
```

### Tables — `table.steps.js`

```gherkin
Then the table ".orders" should have 5 rows
Then the table ".orders" should have 4 columns
Then the table ".orders" should contain the following columns:
  | Order # | Customer | Total | Status |
Then the table ".orders" should be empty
Then the table ".orders" should not be empty
Then the table ".orders" should be sorted by "Total" in "desc" order
Then the table ".orders" should contain the following rows:
  | Order #123 | Rajab | $99 | Paid |
Then the "Order #123" row should contain the following:
  | Customer | Rajab |
  | Status   | Paid  |
```

### Accessibility (axe-core) — `a11y.steps.js`

```gherkin
Then the page should pass an accessibility audit
Then the page should pass an accessibility audit at level "AA"
Then the page should pass the accessibility rules "color-contrast,label"
Then the page should pass an accessibility audit excluding ".third-party"
Then the page should not violate the accessibility rule "color-contrast"
Then the page should have no critical accessibility violations
Then the page should have no serious accessibility violations
Then the element "#contact-form" should pass an accessibility audit
Then I print accessibility violations
# structural (no axe):
Then every image should have an alt attribute
Then every form field should have an accessible label
Then every button should have an accessible name
Then every link should have an accessible name
Then the page should have a title
Then the page should declare a language
Then the page language should be "en"
Then the page should have a main landmark
Then the page should have a navigation landmark
Then the page should have exactly one h1
Then the heading hierarchy should be valid
Then the page should have a skip link
Then no element should have a positive tabindex
Then every ARIA reference should resolve
Then every ARIA role should be valid
Then required fields should be consistently marked
Then user zoom should be allowed
Then the focused element should match "input[name=email]"
Then the focused element should be labeled "Email"
```

### Meta tags — `metatag.steps.js`

```gherkin
Then the meta tag should exist with the following attributes:
  | name    | description     |
  | content | Webship-js docs |
Then the meta tag should not exist with the following attributes:
  | property | og:image |
Then the "description" meta tag should not contain any HTML tags
```

### Screenshots — `screenshot.steps.js`

```gherkin
When I save screenshot
When I save fullscreen screenshot
When I save 1280 x 800 screenshot
When I save fullscreen 1280 x 800 screenshot
When I save screenshot with name "login-filled"
When I save fullscreen screenshot with name "checkout-cart"
```

### Video recording — `video.steps.js`

```gherkin
When I start video recording
When I stop video recording
When I save the current video as "checkout-flow"
Then print video path
```

Env: `WEBSHIP_VIDEO` (`off|on|on-failure|tag`), `WEBSHIP_VIDEO_DIR`.
Tags: `@video` force on, `@no-video` suppress.

### File downloads — `file-download.steps.js`

```gherkin
When I download the file from the URL "/exports/users.csv"
When I download the file from the link "Export users"
Then the downloaded file should contain:
  """
  id,name
  1,Rajab
  """
Then the downloaded file name should be "users.csv"
Then the downloaded file name should contain "users"
Then the downloaded file should be a zip archive containing the following files named:
  | users.csv |
Then the downloaded file should be a zip archive containing the following files partially named:
  | users |
Then the downloaded file should be a zip archive not containing the following files partially named:
  | secret |
```

### JavaScript errors — `javascript.steps.js`

```gherkin
Then there should be no JavaScript errors
Then there should be no JavaScript warnings
Then JavaScript errors should not match "third-party-sdk"
Then print JavaScript errors
```

Configure via `worldParameters.javascript` (`mode: warn|fail|off`,
`levels`, `ignore`, `beforeScenario`, `afterScenario`) or
`WEBSHIP_JS_ERROR_*` env. Per-scenario tags: `@js-fail`, `@js-warn`,
`@js-off`.

### Relative position (named selectors) — `selectors.steps.js`

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

### Debug — `debug.steps.js`

```gherkin
Then print current URL
Then print last response
```

## Critical tips

1. **Web-first first.** Prefer
   `Then "<sel>" should be visible/contain text/have value within N seconds`
   over chaining `wait for AJAX to finish`. Auto-waits, less flaky.
2. **Always wait after `I press` / submit** *if* you're not using a
   web-first assertion next.
3. **Attribute-based link assertion** for `href`, not `response should contain`.
4. **Selector lookup** tries label → placeholder → name → id → css class.
5. **Named selectors win** when text is ambiguous. Register once, reuse.
6. **Custom steps** go in `tests/step-definitions/custom.js`; loaded
   automatically.
7. **Source of truth:** the 36 `*.steps.js` files in
   `node_modules/webship-js/tests/step-definitions/` — always verify
   phrasing there before committing.
8. **Iframe scope.** Always `When I switch to the iframe "..."` first; reset
   with `When I switch to the root document`.
9. **Clock mocking** stops `Date.now()` from drifting. Wrap any
   time-dependent UI test with `Given the system time is "..."`.
10. **Cucumber-js v10+.** `FORCE_COLOR=1` for colored CI logs; the
    `colorsEnabled` option was removed in cucumber-js 10.

---
name: webship-js-steps
description: Quick reference for all webship-js step definitions. Lists all available Given/When/Then steps with usage examples.
---

# /webship-js-steps — Step Definition Reference

Display all available webship-js 2.0 step definitions.

## Arguments

- `$ARGUMENTS` — Optional filter: `navigation`, `form`, `click`, `wait`, `assert`, `link`, `modal`, `api`, or `all` (default: all)

## Context Loading (MUST do before proceeding)

Before displaying step definitions, load the full webship-js context to ensure accuracy:

### 1. Read the official documentation
Fetch and read ALL of the following pages:
- https://webship.co/docs/webship-js/2.0.x
- https://webship.co/docs/webship-js/2.0.x/step-definitions
- https://webship.co/docs/webship-js/2.0.x/api-step-definitions
- https://webship.co/docs/webship-js/2.0.x/assertions
- https://webship.co/docs/webship-js/2.0.x/commands

### 2. Read webship-js source code
Read the source code from local `node_modules/webship-js/` if it exists, otherwise fetch from https://github.com/webship/webship-js (branch `2.0.x`):

**Step definition source code (read ALL — this is the source of truth):**
- `node_modules/webship-js/tests/step-definitions/webship.js` — all UI step definitions
- `node_modules/webship-js/tests/step-definitions/webship-api.js` — all API step definitions

**Example .feature files (read for real usage patterns):**
- `node_modules/webship-js/tests/features/*.feature` — all 49 example feature files

**Example HTML test pages (read to understand what the steps interact with):**
- `node_modules/webship-js/examples/*.html` — all 30 example HTML pages

### 3. Read existing project files
If in a project directory, also read:
- `tests/step-definitions/*.js` — custom step definitions
- `tests/features/*.feature` — existing feature files

### 4. Merge and present
Combine information from docs, source code, and examples. The **source code** (`webship.js` and `webship-api.js`) is the authoritative reference — use it to verify and supplement what the docs say. Include any steps found in source code that are missing from docs.

## Instructions

Based on the filter argument, display the relevant step definitions from the loaded context:

### Navigation Steps
```gherkin
Given I am on "/path"
Given I am on the homepage
When I go to "/path"
When I go to the homepage
When I move forward one page
When I move backward one page
```

### Form Steps
```gherkin
When I fill in "Label" with "value"
When I fill in "attr" with "value" by "name" attr
When I fill in "value" for "Label"
When I fill in the following:
  | Field1 | value1 |
  | Field2 | value2 |
When I press "Button"                    # ALWAYS follow with AJAX wait!
When I select "Option" from "Select"
When I check "Checkbox"
When I uncheck "Checkbox"
When I select radio button "Value"
When I attach the file "name" to "#input"
```

### Click Steps
```gherkin
When I click "Link Text"
When I click "attr" by "name" attr
When I click "Action" in the "Row" row
```

### Wait Steps
```gherkin
When I wait for AJAX to finish           # networkidle - USE AFTER FORM SUBMIT
When I wait N seconds
When I wait until the page is loaded     # domcontentloaded
```

### Scroll Steps
```gherkin
When I scroll down/up/left/right
When I scroll down 500
When I scroll to the top/bottom
When I scroll to the start/end
When I scroll to top of "#element"
When I scroll to bottom of "#element"
```

### Text Assertions
```gherkin
Then I should see "text"
Then I should not see "text"
Then I should see text matching "regex"
Then I should see "text" in the "element" element
Then I should see "text" in the "Row" row
Then the response should contain "text"  # checks textContent, NOT HTML attrs
```

### Page Assertions
```gherkin
Then I should be on "/path"
Then I should be on the homepage
Then the url should match "pattern"
Then the response status code should be 200
```

### Element Assertions
```gherkin
Then I should see a "name" element
Then I should see a "attr" element by "name" attr
Then the "field" field should contain "value"
Then the "element" element should contain "css-prop:value"
```

### Link Assertions
```gherkin
Then the "Link" link should contain "/path"
Then the "attr" link should contain "value" by "href" attr
```

### Checkbox/Radio Assertions
```gherkin
Then the "name" checkbox should be checked
Then the "name" checkbox should not be checked
Then the radio button "value" should be selected
Then the "name" radio button is selected
```

### Modal Steps
```gherkin
Then I should see a modal
Then I should see a modal with title "Title"
Then I should see "text" in the modal
When I click "Button" in the modal
When I close the modal
When I wait for the modal to appear/disappear
```

### API Steps
```gherkin
Given the API base URL is "url"
Given I am authenticating as "user" with "pass" password
Given I set header "Name" with value "Value"
Given I set the request body to '{"key":"value"}'
When I send a GET/POST/PUT/DELETE request to "/endpoint"
When I send a POST request to "/endpoint" with body:
  """
  {"key": "value"}
  """
Then the API response code should be 200
Then the API response should contain "text"
Then the JSON property "path" should be value
Then the response should be valid JSON
Then print API response
```

## Critical Tips

1. **After `I press`**: ALWAYS add `And I wait for AJAX to finish`
2. **HTML attributes**: Use `by "href" attr` pattern, NOT `response should contain`
3. **Selectors**: Steps try label -> placeholder -> name -> ID -> CSS class
4. **Custom steps**: Put in `tests/step-definitions/custom.js`
5. **Source of truth**: Always cross-reference with `webship.js` and `webship-api.js` source code for the latest step definitions

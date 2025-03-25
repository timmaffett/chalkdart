# ChalkDart Change Log

## 3.0.2

- Remove html_character_entities dependency and add that code locally

## 3.0.1

- Fix minor error of old ChalkWhitespaceStyle instead of ChalkWhitespaceTreatment
- Added note about being about to use any valid `white-space` CSS value for [whiteSpaceTreatment]

## 3.0.0

- add support for HTML output mode with new supporting methods for Chalk and Chalk string support
  The intention of this is to allow the use of Chalk for loggers which may be sending output to a
  server/database for viewing in a browser or other html capable viewer.
  The viewed HTML will appear as it does in the VSCode debug console.

New HTML Output Features:
- Output Mode Control:
  - `Chalk.setDefaultOutputMode = ChalkOutputMode.html` to set default mode to html for future constructed Chalk objects
  - `chalk.setOutputMode = ChalkOutputMode.html` to set the output mode on an existing Chalk object
  - Use [ChalkOutputMode.ansi] to change back to ANSI mode (default unless explicitly set to html)

- Color Scheme Support:
  - `Chalk.defaultHtmlBasicANSIColorSet` property for setting default color scheme
  - `Chalk.setDefaultHtmlBasicANSIColorSet` method for changing color scheme
  - Available schemes: [ChalkAnsiColorSet.lightBackground], [ChalkAnsiColorSet.darkBackground], [ChalkAnsiColorSet.highContrast]

- HTML Safety Methods:
  - `chalk.stripHtmlTags()` - Removes HTML tags from text
  - `Chalk.htmlSafeSpaces()` - Preserves spaces in HTML output
  - `Chalk.htmlSafeGtLt()` - Converts < and > to HTML entities
  - `Chalk.htmlSafeEntities()` - Converts all HTML special characters to entities

- Stylesheet Generation:
  - `chalk.stylesheet()` - Generates CSS styles for HTML output
  - `chalk.inlineStylesheet()` - Generates CSS wrapped in <style> tags
  - Customizable options for:
    - Color schemes
    - Whitespace treatment
    - Custom colors
    - Font families (10 customizable slots)

- String Extension Methods:
  - Added `stripHtmlTags` for removing HTML tags
  - Added `htmlSafeGtLt` for safe HTML character conversion
  - Added `htmlSafeSpaces` for space preservation
  - Added `htmlSafeEntities` for entity conversion
  - Extended `strip` to handle HTML tags when in HTML mode

- Example Command Line Options:
  - Added HTML output examples:
    ```
    dart run chalkdart_example.dart --html --light >testlightmode.html
    dart run chalkdart_example.dart --html --highcontrast >testhighcontrastmode.html
    dart run chalkdart_example.dart --html --dark >testdarkmode.html
    ```

## 2.4.0

- add the first ever color debugging support for Flutter apps within VSCode via XCode.
  `Chalk.xcodeSafeEsc = true;` to activate XCode safe mode.
  (Requires the use of my "XCode Flutter Color Debugging" VSCode Extension found at
  [https://marketplace.visualstudio.com/items?itemName=HiveRight.xcodefluttercolordebugging](https://marketplace.visualstudio.com/items?itemName=HiveRight.xcodefluttercolordebugging))
- Update docs in README.md and change out inline base64 url images for server pngs (The inline base64 encoded url images no longer worked on pub.dev/github)

## 2.3.3

- add Wasm support, Since dart:html is not supported when compiling to Wasm, the
  correct alternative now is to use dart.library.js_interop to differentiate
  between native and web.
- Add topics to pubspec.yaml

## 2.3.2

- Fix README.md that got swapped

## 2.3.1

- Dart format code and fix make_css_x11_methods.dart so it outputs correct dart format.

## 2.3.0

- Added support for color previews to all dart docs using Markdown images and inline SVGs.  VSCode supports this.
- Completed the dart docs for all of the string extension methods, including new color previews.
- Always include all X11/CSS colors without having to import the _x11 variants of the chalk files.

## 2.2.1

- Dart format on source

## 2.2.0

- Extended make_css_x11_methods.dart to have capability to generate extensions to String class for all
  the X11/Css color methods from chalk_x11.dart
- Added `chalkstrings_x11.dart` class for adding X11 Chalk methods as extensions to String class

## 2.1.0

- Added Chalk extensions to String class for all Chalk methods using `chalkstrings.dart`

## 2.0.11

- Updated packages, fixed typos in readme, removed non functional badges from readme

## 2.0.10

- Add quotes to screenshot section of pubspec.yaml

## 2.0.9

- Added screenshots to pubspec.yaml

## 2.0.8

- Changed http link in readme to https

## 2.0.7

- More example cleanup

## 2.0.6

- Simplify/cleanup example

## 2.0.5

- There is always something. Regenerate dart docs

## 2.0.4

- Use png instead of svg for logo

## 2.0.3

- Remove html/script from README.md and regenerate dart docs

## 2.0.2

- Add link to readme to dart docs on timmaffett.github.io/chalkdart_docswhich have full color docs because they don't work on github/pub.dev from README.md

## 2.0.1

- Remove html/script sorted table from readme and docs - they don't work on github/pub.dev

## 2.0.0

- Initial public release of chalkdart package.

## 1.0.0

- Initial version, created by Tim Maffett

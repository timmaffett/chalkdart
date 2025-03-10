# Change Log

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

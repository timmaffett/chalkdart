# Chalk'Dart [![Share on Twitter](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Dart%Chalk%20plugin!&url=https://github.com/timmaffett/chalkdart&hashtags=flutter,dart,dartlang,console) [![Share on Facebook](https://img.shields.io/badge/share-facebook-blue.svg?longCache=true&style=flat&colorB=%234267b2)](https://www.facebook.com/sharer/sharer.php?u=https%3A//github.com/timmaffett/chalkdart)
<img src="https://raw.githubusercontent.com/timmaffett/chalkdart/master/media/ChalkDart.png" width="100%">

[![Pub](https://img.shields.io/pub/v/chalkdart.svg)](https://pub.dartlang.org/packages/chalkdart)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://flutterawesome.com/console-terminal-text-coloring-and-styling-library-for-dart)
[![License](https://img.shields.io/badge/License-BSD%203.0-blue.svg)](/LICENSE)
[![GitHub contributors](https://img.shields.io/github/contributors/timmaffett/chalkdart)](https://github.com/timmaffett/chalkdart/graphs/contributors)
[![GitHub forks](https://img.shields.io/github/forks/timmaffett/chalkdart)](https://github.com/timmaffett/chalkdart)
[![GitHub stars](https://img.shields.io/github/stars/timmaffett/chalkdart?)](https://github.com/timmaffett/chalkdart)

## TLDR Summary - Easy to use console text coloring and styling using ANSI (and now HTML for web logs as well!)

Any amount of nesting of colors/styles is fully supported:

```dart
import 'package:chalkdart/chalk.dart';

print(chalk.yellow.onBlue('Hello ${chalk.blue.onGreen.bold('beautiful')} world!'));
```

![Hello beautiful world](https://github.com/timmaffett/chalkdart/raw/master/media/hello_beautiful_world_example.png)

or using the Chalk String extensions:

```dart
import 'package:chalkdart/chalkstrings.dart';

// nested colors and styling are supported
print('Hello ${'beautiful'.blue.onGreen.bold} world!'.yellow.onBlue);
```

![Hello beautiful world](https://github.com/timmaffett/chalkdart/raw/master/media/hello_beautiful_world_example.png)


## 🎉 ChalkDart 3.0 - Now with HTML Output Support! 

ChalkDart 3.0 introduces groundbreaking HTML output capabilities, making it the most versatile text styling solution for Dart.  HTML output capabilities allows the option of generating colorized/styled output for server/web based logging.  While other packages like AnsiColors only handle ANSI terminal output, ChalkDart now offers:

> 🔥 Now includes support for full ANSI coloring/styling 🌈 while debugging/running Flutter apps within XCode from VSCode on Mac OSX!  ANSI styling has never before been available via XCode - but it is now!  Upgrade your OSX Flutter logging to the next level with the colored output capabilities made trivial with ChalkDart. 🚀 💥
> (XCode support requires the companion ["XCode Flutter Color Debugging" VSCode extension](https://marketplace.visualstudio.com/items?itemName=HiveRight.xcodefluttercolordebugging)).  More details found below.


> 📡 ⚡ 💻 🚀  Now includes a HTML mode so that coloring/styling uses HTML tags rather than ANSI codes, so that ChalkDart can be used to color/style logs
that may be sent to a database/server for viewing within a browser environment.  (Honestly, makes ChalkDart the only logical choice for logging packages that wish to
additionally support logging to firebase/files/server as well as traditional ANSI console/terminal support.😉)
- Examples of the HTML output produced by example/chalkdart_example.dart:
  - [Example of Dark Mode color set (ChalkAnsiColorSet.darkBackground)](https://timmaffett.github.io/chalkdart_examples/testdarkmode.html)
  - [Example of Light Mode color set (ChalkAnsiColorSet.lightBackground)](https://timmaffett.github.io/chalkdart_examples/testlightmode.html)
  - [Example of High Contrast Mode color set (ChalkAnsiColorSet.highContrast)](https://timmaffett.github.io/chalkdart_examples/testhighcontrastmode.html)

- To see the identical ANSI output of the above examples execute chalkdart_example.dart within VSCode and see output to your debug console or
  `dart run example/chalkdart_example.dart` from your terminal shell that support full color ANSI (I recommend [iTerm2 for MacOSX](https://iterm2.com/#/section/home))

- **Dual Output Modes**: Switch seamlessly between ANSI terminal output and HTML output with a single line of code
- **Complete Styling Solution**: Use the same intuitive API for both console and web-based logging
- **Perfect for Modern Logging**: Ideal for systems that need to log to both terminal and web interfaces (e.g., Firebase, web dashboards)
- **Rich HTML Features**: Full CSS styling, customizable fonts, and comprehensive color schemes
- **String Extensions**: Powerful string extension methods for more natural Dart-style coding
- **Best-in-Class Terminal Support**: Superior ANSI support including XCode debugging and VSCode integration.  I authored the complete ANSI support available in the VSCode debug terminal, and the ["XCode Flutter Color Debugging" VSCode extension](https://marketplace.visualstudio.com/items?itemName=HiveRight.xcodefluttercolordebugging), specifically to support all of the capabilities of ChalkDart.
- Nominal real world size difference from any other minimal ANSI package, as Dart tree-shaking removes all unused features at build time.  The easy of use of ChalkDart, and the ability to nest and combine styles and styled strings in any manner, make the ChalkDart DevX/UX more than make up for a few thousand bytes of compiled size.

Why choose ChalkDart over alternatives?
  - 🎨 **Comprehensive Color Support**: 
  - Color name autocompletion in IDEs
  - 🔄 **Format Flexibility**: The only package that can output both ANSI and HTML without changing your code
  - 📱 **Better IDE Support**: Full support for VSCode, Android Studio, and first ever support for colorized XCode debugging using print and printDebug() (Using the companion ["XCode Flutter Color Debugging" VSCode extension](https://marketplace.visualstudio.com/items?itemName=HiveRight.xcodefluttercolordebugging))
  - Intelligent style nesting and combining - Any combination of nesting and styles is seamlessly supported.
    Perfect for logging libraries where the logging library can use styling of it's own, but also accept any strings from callers that also have been styled with ChalkDart (also supports nesting of any ANSI codes not generated by ChalkDart).
  - All 140+ standard CSS/X11 color names (cornflowerBlue, darkSeaGreen, etc.)
  - RGB, HSL, HWB, LAB color models
    HSL color space in particular can be nice for easily increasing the saturation or brightness of colors to indicate
    progress or error severity (or hue for making rainbows 🌈. 
  - Hex color codes (#RRGGBB)
  - True color and legacy ANSI 256-color mode support for less capable terminals
  - Custom color keyword definition

> Disclaimer: I needed to update the readme for 3.0, so I thought I would download Cursor AI and ask it to summarize my pull request adding the html output capabilities.  The majority of the text above was written by Cursor - it's quite a ChalkDart promoter - lol- it gave me quite a chuckle.  Better than having to take the time to write something up myself - for now at least.  It did come up with some valid points though. 😉 (It apparently likes emojis also.. 😆)  Cursor also wrote the HTML Output section towards the end summarizing the changes, as well as adding detail to my CHANGELOG.md entry.

##### vscode debug console

<img src="https://github.com/timmaffett/chalkdart/raw/master/media/ABasic.png" width="100%">

##### windows terminal

<img src="https://github.com/timmaffett/chalkdart/raw/master/media/AChalkDart2.png" width="100%">

## Console/Terminal text coloring and styling library for Dart

### 'Terminal string styling done right'

I created this for my Dart/Flutter development logging back in 2020, and in 2022 I finally took the time to clean it up and get it released as a package.
In the mean time I added full ANSI support to the Visual Studio Code debugging console and the Dart-Pad console as well.  You can use any of the ANSI capabilities of this package within your VSCode debugger to enable colorful, styled logging today. 😊

Check out `example/chalkdart_example.dart` for some cool examples of what it is capable of.
Check out `example/chalkdart_string_example.dart` for some cool examples of what it is capable of using the Chalk String extension classes.


If you have used the Chalk.js package within the npm/node.js environment you know how nice and easy it makes text coloring and styling! This ChalkDart version can be used essentially exactly as the js version.

## Full Api Dart Docs can be found [here](https://timmaffett.github.io/chalkdart_docs/index.html)

[ChalkDart API Documentation](https://timmaffett.github.io/chalkdart_docs/index.html)

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/timmaffett/chalkdart/issues).

## Highlights

- Expressive API
- Optional String extension classes which allow use of the Chalk methods directly on Strings
- Highly performant
- Ability to nest styles
- Supports dynamic argument list and automatically handles printing Maps, Lists, Iterables and Function closures
- [256/Truecolor color support](#256-and-truecolor-color-support)
- All standard X11/CSS/SVG colors can be accessed for by name.
- Ignores Auto-detected ANSI color support/as common Dart/Flutter IDE's report this incorrectly.
- Ability to use with or without additional extension of the `String` class.
- Clean and focused
- Actively maintained
- Popup documentation within VSCode supports previews of colors.
- Complete support for XCode debugging via VSCode using the companion ["XCode Flutter Color Debugging" VSCode extension](https://marketplace.visualstudio.com/items?itemName=HiveRight.xcodefluttercolordebugging).

## Install

```console
$ dart pub add chalkdart
```

## Usage

```dart
import 'package:chalkdart/chalk.dart';

print(chalk.yellow.onBlue('Hello world!'));
```
![Hello world](https://github.com/timmaffett/chalkdart/raw/master/media/hello_world_example.png)

Any amount of nesting of colors/styles is fully supported:

```dart
import 'package:chalkdart/chalk.dart';

print(chalk.yellow.onBlue('Hello ${chalk.blue.onGreen.bold('beautiful')} world!'));
```

![Hello beautiful world](https://github.com/timmaffett/chalkdart/raw/master/media/hello_beautiful_world_example.png)

or using the Chalk String extensions:

```dart
import 'package:chalkdart/chalkstrings.dart';

// nested colors and styling are supported
print('Hello ${'beautiful'.blue.onGreen.bold} world!'.yellow.onBlue);
```

![Hello beautiful world](https://github.com/timmaffett/chalkdart/raw/master/media/hello_beautiful_world_example.png)

Chalk comes with an easy to use composable API where you just chain and nest the styles you want.

```dart
import 'package:chalkdart/chalk.dart';

// Combine styled and normal strings
print(chalk.blue('Hello') + ' World' + chalk.red('!'));

// Compose multiple styles using the chainable API
print(chalk.blue.onRed.bold('Hello world!'));

// Pass in multiple arguments
print(chalk.blue('Hello', 'World!', 'Foo', 'bar', 'biz', 'baz'));

// Nest styles
print(chalk.red('Hello', chalk.underline.bgBlue('world') + '!'));

// Nest styles of the same type even (color, underline, background)
print(chalk.green(
     'I am a green line ' +
     chalk.blue.underline.bold('with a blue substring') +
     ' that becomes green again!'
));

// use in multiline string with interpolation
print('''
      CPU: ${chalk.red('90%')}
      RAM: ${chalk.green('40%')}
      DISK: ${chalk.yellow('70%')}
   ''');

// or with inline calcs
print('''
CPU: ${chalk.red(cpu.totalPercent)}%
RAM: ${chalk.green((ram.used / ram.total * 100))}%
DISK: ${chalk.rgb(255,131,0)((disk.used / disk.total * 100))}%
''');

// Use RGB colors in debug console or terminals that support it.
print(chalk.keyword('orange')('Yay for orange colored text!'));
print(chalk.rgb(123, 45, 67).underline('Underlined reddish color'));
print(chalk.hex('#9e9e9e').bold('Bold gray!'));
```

Alternately using the Chalk String extensions:

```dart
import 'package:chalkdart/chalkstrings.dart';
//(or include import 'package:chalkdart/chalkstrings_x11.dart'; for use of all x11 colors)

// Combine styled and normal strings
print('Hello'.blue + ' World' + '!'.red);

// Compose multiple styles using the chainable API
print('Hello world!'.blue.onRed.bold);

// Nest styles
print(('Hello' + 'world'.underline.bgBlue + '!').red);

// Nest styles of the same type even (color, underline, background)
print(('I am a green line ' +
     'with a blue substring'.blue.underline.bold +
     ' that becomes green again!').green
);

// use in multiline string with interpolation
print('''
      CPU: ${'90%'.red}
      RAM: ${'40%'.green}
      DISK: ${'70%'.yellow}
   ''');

// or with inline calcs
print('''
CPU: ${cpu.totalPercent.toStringAsFixed(2).red}%
RAM: ${(ram.used / ram.total * 100).toStringAsFixed(2).green}%
DISK: ${(disk.used / disk.total * 100).toStringAsFixed(2).rgb(255,131,0)}%
''');

// Use RGB colors in debug console or terminals that support it.
print('Yay for orange colored text!'.keyword('orange'));
print('Underlined reddish color'.rgb(123, 45, 67).underline);
print('Bold gray!'.hex('#9e9e9e').bold);
```

Output from either of the above examples:

![Output from either of above examples](https://github.com/timmaffett/chalkdart/raw/master/media/complex_example.png)


Easily define your own themes:

```dart
import 'package:chalkdart/chalk.dart';

const error = chalk.bold.red;
const warning = chalk.keyword('orange');

print(error('Error!'));
print(warning('Warning!'));
```

```dart
const name = 'Tim Maffett';
print(chalk.green('Hello $name'));
//=> 'Hello Tim Maffett'

//or using String extensions
print('Hello $name'.green);
//=> 'Hello Tim Maffett'
```


## API

### chalk.`<style>[.<style>...](string, [string...])`

Example: `chalk.red.bold.underline('Hello', 'world');`

Chain [styles](#styles) and call the last one as a method with a string argument. Order doesn't matter, and later styles take precedent in case of a conflict. This simply means that `chalk.red.yellow.green` is equivalent to `chalk.green`.

String interpolation can be ised or multiple arguments can be listed and will be separated by space (or the string specified by `joinWith`).  The arguments can be of any type, Map<>, List<>, Iterable and Functions/Function closures are also supported.  By default Lists are joined together with a ' '(space), but the `joinWith` method can be used to specify a different join string. Up to 15 arguments can be included as arguments to a Chalk object.

## Styles

### Modifiers

- `reset` - Resets the current color chain.
- `blink` - Make text blink.
- `rapidblink` - Make text blink rapidly.
- `bold` - Make text bold.
- `dim` - Emitting only a small amount of light.
- `italic` - Make text italic.
- `underline` - Make text underline.
- `doubleunderline` - Thicker text underline.
- `overline` - Make text overline.
- `inverse` (or `invert`)- Inverse background and foreground colors.
- `hidden` - Prints the text, but makes it invisible.
- `superscript` - Make text superscript.
- `subscript` - Make text subscript.
- `strikethrough` - Puts a horizontal line through the center of the text.
- `visible`- Prints the text only when Chalk has a color level > 0. Can be useful for things that are purely cosmetic.
- `font1`-`font10` - Changes the font

Some of these ANSI styles are not widely supported within all terminal emulators, but I have added COMPLETE support to the standard Visual Studio Code debug console as well as to the Dart-Pad console.  Android Studio also has fairly complete support within it's debug console. See the VSCode section for info on using CSS to map fonts to the `font1` through `font10`.

### Colors

The exact RGB values for the base ANSI colors are rendered console/terminal dependent - and can be configured on some terminals such Windows Terminal - [more info here](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit)

I include original JS Chalk 'xxxxBright' method names for users that may want legacy compatibility with original JS Chalk).

- `black`
- `red`
- `green`
- `yellow`
- `blue`
- `magenta`
- `cyan`
- `white`
- `brightBlack`  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `blackBright`, `gray`, `grey`)</sup></sub>
- `brightRed`  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `redBright`)</sup></sub>
- `brightGreen` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `greenBright`)</sup></sub>
- `brightYellow` &nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `yellowBright`)</sup></sub>
- `brightBlue` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `blueBright`)</sup></sub>
- `brightMagenta` &nbsp;&nbsp;&nbsp;<sub><sup>(alias `magentaBright`)</sup></sub>
- `brightCyan`  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `cyanBright`)</sup></sub>
- `brightWhite`  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `whiteBright`)</sup></sub>

### Background colors

They are named by prefixing the color with 'on'.  Chalk'Dart favors the 'onXXXXX' style of specifying background colors because the verb 'on' makes chained methods read better as a sentence ([it's the Dart way](https://dart.dev/guides/language/effective-dart/design#prefer-a-non-imperative-verb-phrase-for-a-boolean-property-or-variable)).  I include original Chalk 'bgXXXX' method names for users that may prefer that scheme (essentially for legacy compatability with original JS Chalk).  

For example 'onBlue' and 'bgBlue' are the same, it is a matter of
users preference on how they want their code to read.

- `onBlack` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgBlack`)</sup></sub>
- `onRed` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgRed`)</sup></sub>
- `onGreen` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgGreen`)</sup></sub>
- `onYellow` &nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgYellow`)</sup></sub>
- `onBlue` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgBlue`)</sup></sub>
- `onMagenta` &nbsp;&nbsp;<sub><sup>(alias `bgMagenta`)</sup></sub>
- `onCyan` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgCyan`)</sup></sub>
- `onWhite` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgWhite`)</sup></sub>
- `onBrightBlack` <sub><sup>/ `onGray` / `onGrey` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(alias: `bgBlackBright`, `bgGray`, `bgGrey`)</sup></sub>
- `onBrightRed` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgRedBright`)</sup></sub>
- `onBrightGreen` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgGreenBright`)</sup></sub>
- `onBrightYellow` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgYellowBright`)</sup></sub>
- `onBrightBlue` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgBlueBright`)</sup></sub>
- `onBrightMagenta` &nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgMagentaBright`)</sup></sub>
- `onBrightCyan` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgCyanBright`)</sup></sub>
- `onBrightWhite` &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<sub><sup>(alias `bgWhiteBright`)</sup></sub>

## 256 and Truecolor color support

Chalk supports 256 colors and [Truecolor](https://gist.github.com/XVilka/8346728) (16 million colors) on supported terminal apps.

Colors are downsampled from 16 million RGB values to an ANSI color format that is supported by the terminal emulator (or by specifying `{level: n}` as a Chalk option). For example, Chalk configured to run at level 1 (basic color support) will downsample an RGB value of #FF0000 (red) to 31 (ANSI escape for red).

Examples:

- `chalk.hex('#DEADED').underline('Hello, world!')`
- `chalk.keyword('orange')('Some orange text')`
- `chalk.rgb(15, 100, 204).inverse('Hello!')`

Background versions of these models are prefixed with `bg` and the first level of the module capitalized (e.g. `keyword` for foreground colors and `bgKeyword` for background colors).

- `chalk.onHex('#DEADED').underline('Hello, world!')`
- `chalk.onKeyword('orange')('Some orange text')`
- `chalk.onRgb(15, 100, 204).inverse('Hello!')`

The following color models can be used:

- [`rgb`](https://en.wikipedia.org/wiki/RGB_color_model) - Example: `chalk.rgb(255, 136, 0).bold('Orange!')`
- [`hex`](https://en.wikipedia.org/wiki/Web_colors#Hex_triplet) - Example: `chalk.hex('#FF8800').bold('Orange!')`
- [`hsl`](https://en.wikipedia.org/wiki/HSL_and_HSV) - Example: `chalk.hsl(32, 100, 50).bold('Orange!')`
- [`hsv`](https://en.wikipedia.org/wiki/HSL_and_HSV) - Example: `chalk.hsv(32, 100, 100).bold('Orange!')`
- [`hwb`](https://en.wikipedia.org/wiki/HWB_color_model) - Example: `chalk.hwb(32, 0, 50).bold('Orange!')`
- [`xyz`](https://en.wikipedia.org/wiki/CIE_1931_color_space) - Example: `chalk.xyz(0.9, 0.9, 0.1).bold('Yellow!')`
- [`lab`](https://en.wikipedia.org/wiki/CIELAB_color_space#CIELAB) - Example: `chalk.lab(85, 0, 108).bold('yellow-Orange!')`

- [`ansi`](https://en.wikipedia.org/wiki/ANSI_escape_code#3/4_bit) - Example: `chalk.ansi(31).bgAnsi(93)('red on yellowBright')`
- [`ansi256`](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit) - Example: `chalk.onAnsi256(194)('Honeydew, more or less')`
- [`keyword`](https://www.w3.org/wiki/CSS/Properties/color/keywords) (X11/CSS/SVG color keywords) - Example: `chalk.cornFlowerBlue.onBeige` or `chalk.keyword('orange').bold('Orange!')`
            The keyword table can be extended via and the new keywords can be accessed via

```dart
Chalk.addColorKeywordHex('myfavorite', 0x6495ED ); // using hex int
chalk.color.myfavorite('This is my favorite color');
Chalk.addColorKeywordHex('my2ndFavorite', '#6A5ACD' );  // or using string
chalk.color.my2ndfavorite('This is my 2nd favorite color');
```

or

```dart
chalk.keyword('myfavorite)('Using the keyword() method');
chalk.color.my2ndfavorite('This is my 2nd favorite color');
```

There are also extension methods for each of the X11/CSS/SVG color names.  With that you get code completion for available colors as well as compile time checking of color names.

```dart
import 'package:chalkdart/chalk.dart';

chalk.cornflowerBlue.onLimeGreen('Hey there!);

// without extension methods you can use the dynamic keyword lookup method:
chalk.color.cornflowerBlue.onLimeGreen('Hi Again!);
// or off x11
chalk.x11.cornflowerBlue.onLimeGreen('Hi Again!);
// or off csscolor
chalk.csscolor.cornflowerBlue.onLimeGreen('Hi Again!);

```

## HTML Output Mode

ChalkDart 3.0.0 introduces HTML output mode, allowing you to generate HTML-styled text instead of ANSI codes. This is particularly useful for logging to web-based systems or creating HTML output.

### Basic HTML Usage

```dart
import 'package:chalkdart/chalk.dart';

// Create a new Chalk instance with HTML output mode
final htmlChalk = Chalk(outputMode: ChalkOutputMode.html);

// Add the stylesheet to your output
print(htmlChalk.inlineStylesheet());

// Use chalk as normal - it will output HTML instead of ANSI codes
print(htmlChalk.red.bold('This is red and bold text'));
```

### HTML Safety Methods

```dart
// Make text safe for HTML display
print(htmlChalk.blue('Text with <angles> & symbols'.htmlSafeGtLt));

// Preserve spaces in HTML output by converting to &nbsp;
print(htmlChalk.green('Text    with    spaces'.htmlSafeSpaces));
// Alternatively, a simpler approach is to set whitespace preservation in the stylesheet:
print(htmlChalk.inlineStylesheet(
    whiteSpaceTreatment: ChalkWhitespaceTreatment.preserveNoWrap.css  // Preserves spaces without HTML entity conversion
));
print(htmlChalk.green('Text    with    spaces'));  // Spaces will be preserved by CSS

// Convert all HTML special characters to entities
print(htmlChalk.yellow('Special & characters'.htmlSafeEntities));

// Remove HTML tags
print(htmlChalk.stripHtmlTags('<span>Remove tags</span>'));
```

The `whiteSpaceTreatment` parameter in stylesheet generation is often a better choice for space preservation as it:
- Doesn't modify your original text
- Applies globally to all output
- Uses CSS instead of HTML entities
- Is more efficient and readable
- Preserves copy/paste functionality better than using `&nbsp;`

### Customizing HTML Output

```dart
// Set color scheme for basic ANSI colors
Chalk.defaultHtmlBasicANSIColorSet = ChalkAnsiColorSet.darkBackground;  // or .lightBackground or .highContrast

// Generate custom stylesheet
print(htmlChalk.stylesheet(
    colorSetToUse: ChalkAnsiColorSet.darkBackground,
    whiteSpaceTreatment: ChalkWhitespaceTreatment.preserve.css,
    foregroundColor: '#000000',
    backgroundColor: '#ffffff',
    font1: '"Your Custom Font", sans-serif'
));
```

## IDE Support

The terminals and debug consoles in current versions of both Android Studio, IntelliJ and 
Visual Studio Code support 24bit/16M color ansi codes and most attributes.  However, they
both report that they DO NOT support ANSI codes.  For this reason Chalk'Dart defaults to
supporting full level 3 (24 bit) ANSI codes.

## XCode Support on OSX

Full ANSI coloring/styling support is finally available when debugging or running within XCode via VSCode.  XCode has always corrupted and truncated all messages that contained escape sequences (including valid ANSI ones), making colored logging from XCode impossible.  I have surmounted this while running within XCode by encoding all ASCII 27 (\\x1B) ESC characters as `[^ESC}` and adding my ["XCode Flutter Color Debugging" VSCode extension](https://marketplace.visualstudio.com/items?itemName=HiveRight.xcodefluttercolordebugging) to VSCode to translate these back so that the ANSI escape sequence can be properly interpreted by VSCode.

The only additional code that needs to be added is setting `Chalk.xcodeSafeEsc=true` to activate the XCode safe ESC mode within the ChalkDart package.

Once that is done ChalkDart will output the properly encoded escape sequences and this VSCode extension will automatically convert the encoded escape
sequences back to standard ANSI sequences for the VSCode debug console to interpret.

```dart
import 'package:chalkdart/chalkstrings.dart';

void main() {
    Chalk.xcodeSafeEsc = true;  // activate XCode Safe ESC mode within ChalkDart Package
    print('Hello world!'.yellow.onBlue);

    ...the rest of your flutter app which will be debugged within VSCode via execution within XCode...
}
```

> With the ["XCode Flutter Color Debugging" VSCode extension](https://marketplace.visualstudio.com/items?itemName=HiveRight.xcodefluttercolordebugging) you can enjoy full color messages/console logging from within your Flutter app, EVEN when debugging via XCode.

![Color debug console messages via XCode WITH this extension](https://github.com/timmaffett/chalkdart/raw/master/media/with_xcodefluttercolordebugging.png)

> When debugging a Flutter app via XCode WITHOUT this extension you would just see something like the following, raw broken ansi sequences AND *truncated* messages, anytime you attempt to output color:

![Broken debug console messages via XCode without this extension](https://github.com/timmaffett/chalkdart/raw/master/media/without_xcodefluttercolordebugging.png)

## VSCode

It is possible to set the fonts that VSCode uses in the debug console.  More information can be found [here](vscode.md).

## Browser support

Chrome, Firefox and Edge natively support ANSI escape codes in their respective developer consoles.
From dart web code you can use `window.console.log(...)` to log messages to the browser's debug console.

## Windows

If you're on Windows, do yourself a favor and use [Windows Terminal](https://github.com/microsoft/terminal) instead of `cmd.exe`.

## Related

- [chalk-js](https://github.com/chalk/chalk) - The original Chalk library module for javascript which was the inspiration for this (as well as being the basis for this readme as well)!
  
## Author/Maintainer

- [Tim Maffett](https://github.com/timmaffett)


## Other examples

##### Charts from chalkdart_example.dart output to windows terminal
<img src="https://github.com/timmaffett/chalkdart/raw/master/media/Ansi0.png" width="100%">
<img src="https://github.com/timmaffett/chalkdart/raw/master/media/Ansi1.png" width="100%">

<img src="https://github.com/timmaffett/chalkdart/raw/master/media/AWindowsTerminal.png" width="100%">
<img src="https://github.com/timmaffett/chalkdart/raw/master/media/AChalkDart2_chart2.png" width="100%">


### chalk.level

Specifies the level of color support.

Color support is automatically detected, but you can override it by setting the `level` property.
Changing the `level` applies globally to all Chalk consumers.
Note dart determines VSCode debug console and Android Studio debug console do not support ansi control sequences, when in fact they do, so by default the level is set to 3 (full color/sequence support) as the default, no matter what the console/terminal reports.  You must set this yourself if you want a different value.

If you need to change this in a reusable module, create a new instance:

```dart
// using constructor
var chalkWithLevel0 = Chalk(level: 0);
// Using the instance accomplishes the same thing
var chalkWithLevel0 = Chalk.instance(level: 0);
// this alternative naming of `instance` is provided for users accustomed to the JS version of Chalk
var chalkWithLevel0 = Chalk.Instance(level: 0);
```

| Level | Description |
| :---: | :--- |
| `0` | All colors disabled |
| `1` | Basic color support (16 colors) |
| `2` | 256 color support |
| `3` | Truecolor support (16 million colors) |

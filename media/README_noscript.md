<img src="https://raw.githubusercontent.com/timmaffett/chalkdart/master/media/ChalkDart.png" width="100%">

##### vscode debug console

<img src="https://github.com/timmaffett/chalkdart/raw/master/media/ABasic.png" width="100%">

##### windows terminal

<img src="https://github.com/timmaffett/chalkdart/raw/master/media/AChalkDart2.png" width="100%">

## Console/Terminal text coloring and styling library for Dart

### 'Terminal string styling done right'

I created this for my Dart/Flutter development logging almost 2 years ago now, and I have finally taken the time to clean it up and get it released as a package.
In the mean time I added full ANSI support to the Visual Studio Code debugging console as well as just finishing full ANSI support for the Dart-Pad console as well.  You can use this within your VSCode debugger to enable colorful, styled logging today. 😊

Check out `example/chalkdart_example.dart` for some cool examples of what it is capable of.

If you have used the Chalk.js package within the npm/node.js environment you know how nice and easy it makes text coloring and styling! This ChalkDart version can be used essentially exactly as the js version.

## Full Api Dart Docs can be found [here](https://timmaffett.github.io/chalkdart_docs/index.html)

[ChalkDart API Documentation](https://timmaffett.github.io/chalkdart_docs/index.html)

## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/timmaffett/chalkdart/issues).

## Highlights

- Expressive API
- Highly performant
- Ability to nest styles
- Supports dynamic argument list and automatically handles printing Maps, Lists, Iterables and Function closures
- [256/Truecolor color support](#256-and-truecolor-color-support)
- All standard X11/CSS/SVG colors can be accessed for by name.
- Ignores Auto-detected ANSI color support/as common Dart/Flutter IDE's report this incorrectly.
- Not an extentension of the `String` class.
- Clean and focused
- Actively maintained

## Install

```console
$ dart pub add chalkdart
```

## Usage

```dart
import 'package:chalkdart/chalk.dart';

print(chalk.yellow.onBlue('Hello world!'));
```

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
print(chalk.hex('#DEADED').bold('Bold gray!'));
```

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

I include original JS Chalk 'xxxxBright' method names for users that may want legacy compatability with original JS Chalk).

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

or import the X11 extension methods to get proper methods for each of the X11/CSS/SVG color names.  With that you get code completion for available colors as well as compile time checking of color names.

```dart
import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalk_x11.dart'; // get methods for x11/css/svg color name keywords

chalk.cornflowerBlue.onLimeGreen('Hey there!);

// without extension methods you can use the dynamic keyword lookup method:
chalk.color.cornflowerBlue.onLimeGreen('Hi Again!);
// or off x11
chalk.x11.cornflowerBlue.onLimeGreen('Hi Again!);
// or off csscolor
chalk.csscolor.cornflowerBlue.onLimeGreen('Hi Again!);

```

### chalk.level

Specifies the level of color support.

Color support is automatically detected, but you can override it by setting the `level` property. You should however only do this in your own code as it applies globally to all Chalk consumers.
Note dart determines VSCode debug console and Android Studio debug console do not support ansi control sequences, when in fact they do, so by default the level is set to 3 (full color/sequence support) as the default, no matter what the console/terminal reports.  You must set this yourslef if you want a different value.

If you need to change this in a reusable module, create a new instance:

```dart
var chalkWithLevel0 = chalk.instance(level: 0);
// this version is provided for users of the JS version of Chalk
var chalkWithLevel0 = chalk.Instance(level: 0);
```

| Level | Description |
| :---: | :--- |
| `0` | All colors disabled |
| `1` | Basic color support (16 colors) |
| `2` | 256 color support |
| `3` | Truecolor support (16 million colors) |

## IDE Support

The terminals and debug consoles in current versions of both Android Studio, IntelliJ and 
Visual Studio Code support 24bit/16M color ansi codes and most attributes.  However, they
both report that they DO NOT support ANSI codes.  For this reason Chalk'Dart defaults to
supporting full level 3 (24 bit) ANSI codes.

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

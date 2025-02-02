# Chalk'Dart [![Share on Twitter](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Dart%Chalk%20plugin!&url=https://github.com/timmaffett/chalkdart&hashtags=flutter,dart,dartlang,console) [![Share on Facebook](https://img.shields.io/badge/share-facebook-blue.svg?longCache=true&style=flat&colorB=%234267b2)](https://www.facebook.com/sharer/sharer.php?u=https%3A//github.com/timmaffett/chalkdart)
<img src="https://raw.githubusercontent.com/timmaffett/chalkdart/master/media/ChalkDart.png" width="100%">

[![Pub](https://img.shields.io/pub/v/chalkdart.svg)](https://pub.dartlang.org/packages/chalkdart)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://flutterawesome.com/console-terminal-text-coloring-and-styling-library-for-dart)
[![License](https://img.shields.io/badge/License-BSD%203.0-blue.svg)](/LICENSE)
[![GitHub contributors](https://img.shields.io/github/contributors/timmaffett/chalkdart)](https://github.com/timmaffett/chalkdart/graphs/contributors)
[![GitHub forks](https://img.shields.io/github/forks/timmaffett/chalkdart)](https://github.com/timmaffett/chalkdart)
[![GitHub stars](https://img.shields.io/github/stars/timmaffett/chalkdart?)](https://github.com/timmaffett/chalkdart)

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

## Install

```console
$ dart pub add chalkdart
```

## Usage

```dart
import 'package:chalkdart/chalk.dart';

print(chalk.yellow.onBlue('Hello world!'));
```

Any amount of nesting of colors/styles is fully supported:

```dart

var kind = 'beautiful';
print(chalk.yellow.onBlue('Hello ${chalk.blue.onGreen.bold(kind)} world!'));

```

or using the Chalk String extensions:

```dart
import 'package:chalkdart/chalkstrings.dart';

print('Hello world!'.yellow.onBlue);

// nested colors and styling are supported
var kind = 'beautiful';
print('Hello ${kind.blue.onGreen.bold} world!'.yellow.onBlue);

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
CPU: ${cpu.totalPercent.toString().red}%
RAM: ${(ram.used / ram.total * 100).toString().green}%
DISK: ${(disk.used / disk.total * 100).toString().rgb(255,131,0)}%
''');

// Use RGB colors in debug console or terminals that support it.
print('Yay for orange colored text!'.keyword('orange'));
print('Underlined reddish color'.rgb(123, 45, 67).underline);
print('Bold gray!'.hex('#DEADED').bold);
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

## ANSI Color Codes for .ansi() and .onAnsi()


<table style="font-size: 8px;">
<tbody>
<tr>
<th colspan="36" style="font-size:16px;text-align: center">256 Color Mode ANSI Color Codes for use with chalk.ansi() and chalk.onAnsi()</th>
</tr>
<tr>
<td colspan="18" style="font-size: 12px;text-align:center;">Standard colors
</td>
<td colspan="18" style="font-size: 12px;text-align:center;">'Bright' colors
</td></tr>
<tr>
<td colspan="36">
<table style="width:100%;text-align:center;font-weight:bold;">

<tbody><tr>
<td style="color:#ffffff;background:#000000;" title="#000000">&nbsp;0&nbsp;
</td>
<td style="color:#ffffff;background:#800000;" title="#800000">&nbsp;1&nbsp;
</td>
<td style="color:#ffffff;background:#008000;" title="#008000">&nbsp;2&nbsp;
</td>
<td style="color:#ffffff;background:#808000;" title="#808000">&nbsp;3&nbsp;
</td>
<td style="color:#ffffff;background:#000080;" title="#000080">&nbsp;4&nbsp;
</td>
<td style="color:#ffffff;background:#800080;" title="#800080">&nbsp;5&nbsp;
</td>
<td style="color:#ffffff;background:#008080;" title="#008080">&nbsp;6&nbsp;
</td>
<td style="color:#ffffff;background:#c0c0c0;" title="#c0c0c0">&nbsp;7&nbsp;
</td>
<td style="width:1em;">
</td>
<td style="color:#000000;background:#808080;" title="#808080">&nbsp;8&nbsp;
</td>
<td style="color:#000000;background:#ff0000;" title="#ff0000">&nbsp;9&nbsp;
</td>
<td style="color:#000000;background:#00ff00;" title="#00ff00">10
</td>
<td style="color:#000000;background:#ffff00;" title="#ffff00">11
</td>
<td style="color:#000000;background:#0000ff;" title="#0000ff">12
</td>
<td style="color:#000000;background:#ff00ff;" title="#ff00ff">13
</td>
<td style="color:#000000;background:#00ffff;" title="#00ffff">14
</td>
<td style="color:#000000;background:#ffffff;" title="#ffffff">15
</td></tr></tbody></table>
</td></tr>
<tr>
<td colspan="36" style="font-size: 12px;text-align:center;">216 colors
</td></tr>
<tr>
<td style="color:#ffffff;background:#000000;" title="#000000">16
</td>
<td style="color:#ffffff;background:#00005f;" title="#00005f">17
</td>
<td style="color:#ffffff;background:#000087;" title="#000087">18
</td>
<td style="color:#ffffff;background:#0000af;" title="#0000af">19
</td>
<td style="color:#ffffff;background:#0000d7;" title="#0000d7">20
</td>
<td style="color:#ffffff;background:#0000ff;" title="#0000ff">21
</td>
<td style="color:#ffffff;background:#005f00;" title="#005f00">22
</td>
<td style="color:#ffffff;background:#005f5f;" title="#005f5f">23
</td>
<td style="color:#ffffff;background:#005f87;" title="#005f87">24
</td>
<td style="color:#ffffff;background:#005faf;" title="#005faf">25
</td>
<td style="color:#ffffff;background:#005fd7;" title="#005fd7">26
</td>
<td style="color:#ffffff;background:#005fff;" title="#005fff">27
</td>
<td style="color:#ffffff;background:#008700;" title="#008700">28
</td>
<td style="color:#ffffff;background:#00875f;" title="#00875f">29
</td>
<td style="color:#ffffff;background:#008787;" title="#008787">30
</td>
<td style="color:#ffffff;background:#0087af;" title="#0087af">31
</td>
<td style="color:#ffffff;background:#0087d7;" title="#0087d7">32
</td>
<td style="color:#ffffff;background:#0087ff;" title="#0087ff">33
</td>
<td style="color:#000000;background:#00af00;" title="#00af00">34
</td>
<td style="color:#000000;background:#00af5f;" title="#00af5f">35
</td>
<td style="color:#000000;background:#00af87;" title="#00af87">36
</td>
<td style="color:#000000;background:#00afaf;" title="#00afaf">37
</td>
<td style="color:#000000;background:#00afd7;" title="#00afd7">38
</td>
<td style="color:#000000;background:#00afff;" title="#00afff">39
</td>
<td style="color:#000000;background:#00d700;" title="#00d700">40
</td>
<td style="color:#000000;background:#00d75f;" title="#00d75f">41
</td>
<td style="color:#000000;background:#00d787;" title="#00d787">42
</td>
<td style="color:#000000;background:#00d7af;" title="#00d7af">43
</td>
<td style="color:#000000;background:#00d7d7;" title="#00d7d7">44
</td>
<td style="color:#000000;background:#00d7ff;" title="#00d7ff">45
</td>
<td style="color:#000000;background:#00ff00;" title="#00ff00">46
</td>
<td style="color:#000000;background:#00ff5f;" title="#00ff5f">47
</td>
<td style="color:#000000;background:#00ff87;" title="#00ff87">48
</td>
<td style="color:#000000;background:#00ffaf;" title="#00ffaf">49
</td>
<td style="color:#000000;background:#00ffd7;" title="#00ffd7">50
</td>
<td style="color:#000000;background:#00ffff;" title="#00ffff">51
</td></tr>
<tr>
<td style="color:#ffffff;background:#5f0000;" title="#5f0000">52
</td>
<td style="color:#ffffff;background:#5f005f;" title="#5f005f">53
</td>
<td style="color:#ffffff;background:#5f0087;" title="#5f0087">54
</td>
<td style="color:#ffffff;background:#5f00af;" title="#5f00af">55
</td>
<td style="color:#ffffff;background:#5f00d7;" title="#5f00d7">56
</td>
<td style="color:#ffffff;background:#5f00ff;" title="#5f00ff">57
</td>
<td style="color:#ffffff;background:#5f5f00;" title="#5f5f00">58
</td>
<td style="color:#ffffff;background:#5f5f5f;" title="#5f5f5f">59
</td>
<td style="color:#ffffff;background:#5f5f87;" title="#5f5f87">60
</td>
<td style="color:#ffffff;background:#5f5faf;" title="#5f5faf">61
</td>
<td style="color:#ffffff;background:#5f5fd7;" title="#5f5fd7">62
</td>
<td style="color:#ffffff;background:#5f5fff;" title="#5f5fff">63
</td>
<td style="color:#ffffff;background:#5f8700;" title="#5f8700">64
</td>
<td style="color:#ffffff;background:#5f875f;" title="#5f875f">65
</td>
<td style="color:#ffffff;background:#5f8787;" title="#5f8787">66
</td>
<td style="color:#ffffff;background:#5f87af;" title="#5f87af">67
</td>
<td style="color:#ffffff;background:#5f87d7;" title="#5f87d7">68
</td>
<td style="color:#ffffff;background:#5f87ff;" title="#5f87ff">69
</td>
<td style="color:#000000;background:#5faf00;" title="#5faf00">70
</td>
<td style="color:#000000;background:#5faf5f;" title="#5faf5f">71
</td>
<td style="color:#000000;background:#5faf87;" title="#5faf87">72
</td>
<td style="color:#000000;background:#5fafaf;" title="#5fafaf">73
</td>
<td style="color:#000000;background:#5fafd7;" title="#5fafd7">74
</td>
<td style="color:#000000;background:#5fafff;" title="#5fafff">75
</td>
<td style="color:#000000;background:#5fd700;" title="#5fd700">76
</td>
<td style="color:#000000;background:#5fd75f;" title="#5fd75f">77
</td>
<td style="color:#000000;background:#5fd787;" title="#5fd787">78
</td>
<td style="color:#000000;background:#5fd7af;" title="#5fd7af">79
</td>
<td style="color:#000000;background:#5fd7d7;" title="#5fd7d7">80
</td>
<td style="color:#000000;background:#5fd7ff;" title="#5fd7ff">81
</td>
<td style="color:#000000;background:#5fff00;" title="#5fff00">82
</td>
<td style="color:#000000;background:#5fff5f;" title="#5fff5f">83
</td>
<td style="color:#000000;background:#5fff87;" title="#5fff87">84
</td>
<td style="color:#000000;background:#5fffaf;" title="#5fffaf">85
</td>
<td style="color:#000000;background:#5fffd7;" title="#5fffd7">86
</td>
<td style="color:#000000;background:#5fffff;" title="#5fffff">87
</td></tr>
<tr>
<td style="color:#ffffff;background:#870000;" title="#870000">88
</td>
<td style="color:#ffffff;background:#87005f;" title="#87005f">89
</td>
<td style="color:#ffffff;background:#870087;" title="#870087">90
</td>
<td style="color:#ffffff;background:#8700af;" title="#8700af">91
</td>
<td style="color:#ffffff;background:#8700d7;" title="#8700d7">92
</td>
<td style="color:#ffffff;background:#8700ff;" title="#8700ff">93
</td>
<td style="color:#ffffff;background:#875f00;" title="#875f00">94
</td>
<td style="color:#ffffff;background:#875f5f;" title="#875f5f">95
</td>
<td style="color:#ffffff;background:#875f87;" title="#875f87">96
</td>
<td style="color:#ffffff;background:#875faf;" title="#875faf">97
</td>
<td style="color:#ffffff;background:#875fd7;" title="#875fd7">98
</td>
<td style="color:#ffffff;background:#875fff;" title="#875fff">99
</td>
<td style="color:#ffffff;background:#878700;" title="#878700">100
</td>
<td style="color:#ffffff;background:#87875f;" title="#87875f">101
</td>
<td style="color:#ffffff;background:#878787;" title="#878787">102
</td>
<td style="color:#ffffff;background:#8787af;" title="#8787af">103
</td>
<td style="color:#ffffff;background:#8787d7;" title="#8787d7">104
</td>
<td style="color:#ffffff;background:#8787ff;" title="#8787ff">105
</td>
<td style="color:#000000;background:#87af00;" title="#87af00">106
</td>
<td style="color:#000000;background:#87af5f;" title="#87af5f">107
</td>
<td style="color:#000000;background:#87af87;" title="#87af87">108
</td>
<td style="color:#000000;background:#87afaf;" title="#87afaf">109
</td>
<td style="color:#000000;background:#87afd7;" title="#87afd7">110
</td>
<td style="color:#000000;background:#87afff;" title="#87afff">111
</td>
<td style="color:#000000;background:#87d700;" title="#87d700">112
</td>
<td style="color:#000000;background:#87d75f;" title="#87d75f">113
</td>
<td style="color:#000000;background:#87d787;" title="#87d787">114
</td>
<td style="color:#000000;background:#87d7af;" title="#87d7af">115
</td>
<td style="color:#000000;background:#87d7d7;" title="#87d7d7">116
</td>
<td style="color:#000000;background:#87d7ff;" title="#87d7ff">117
</td>
<td style="color:#000000;background:#87ff00;" title="#87ff00">118
</td>
<td style="color:#000000;background:#87ff5f;" title="#87ff5f">119
</td>
<td style="color:#000000;background:#87ff87;" title="#87ff87">120
</td>
<td style="color:#000000;background:#87ffaf;" title="#87ffaf">121
</td>
<td style="color:#000000;background:#87ffd7;" title="#87ffd7">122
</td>
<td style="color:#000000;background:#87ffff;" title="#87ffff">123
</td></tr>
<tr>
<td style="color:#ffffff;background:#af0000;" title="#af0000">124
</td>
<td style="color:#ffffff;background:#af005f;" title="#af005f">125
</td>
<td style="color:#ffffff;background:#af0087;" title="#af0087">126
</td>
<td style="color:#ffffff;background:#af00af;" title="#af00af">127
</td>
<td style="color:#ffffff;background:#af00d7;" title="#af00d7">128
</td>
<td style="color:#ffffff;background:#af00ff;" title="#af00ff">129
</td>
<td style="color:#ffffff;background:#af5f00;" title="#af5f00">130
</td>
<td style="color:#ffffff;background:#af5f5f;" title="#af5f5f">131
</td>
<td style="color:#ffffff;background:#af5f87;" title="#af5f87">132
</td>
<td style="color:#ffffff;background:#af5faf;" title="#af5faf">133
</td>
<td style="color:#ffffff;background:#af5fd7;" title="#af5fd7">134
</td>
<td style="color:#ffffff;background:#af5fff;" title="#af5fff">135
</td>
<td style="color:#ffffff;background:#af8700;" title="#af8700">136
</td>
<td style="color:#ffffff;background:#af875f;" title="#af875f">137
</td>
<td style="color:#ffffff;background:#af8787;" title="#af8787">138
</td>
<td style="color:#ffffff;background:#af87af;" title="#af87af">139
</td>
<td style="color:#ffffff;background:#af87d7;" title="#af87d7">140
</td>
<td style="color:#ffffff;background:#af87ff;" title="#af87ff">141
</td>
<td style="color:#000000;background:#afaf00;" title="#afaf00">142
</td>
<td style="color:#000000;background:#afaf5f;" title="#afaf5f">143
</td>
<td style="color:#000000;background:#afaf87;" title="#afaf87">144
</td>
<td style="color:#000000;background:#afafaf;" title="#afafaf">145
</td>
<td style="color:#000000;background:#afafd7;" title="#afafd7">146
</td>
<td style="color:#000000;background:#afafff;" title="#afafff">147
</td>
<td style="color:#000000;background:#afd700;" title="#afd700">148
</td>
<td style="color:#000000;background:#afd75f;" title="#afd75f">149
</td>
<td style="color:#000000;background:#afd787;" title="#afd787">150
</td>
<td style="color:#000000;background:#afd7af;" title="#afd7af">151
</td>
<td style="color:#000000;background:#afd7d7;" title="#afd7d7">152
</td>
<td style="color:#000000;background:#afd7ff;" title="#afd7ff">153
</td>
<td style="color:#000000;background:#afff00;" title="#afff00">154
</td>
<td style="color:#000000;background:#afff5f;" title="#afff5f">155
</td>
<td style="color:#000000;background:#afff87;" title="#afff87">156
</td>
<td style="color:#000000;background:#afffaf;" title="#afffaf">157
</td>
<td style="color:#000000;background:#afffd7;" title="#afffd7">158
</td>
<td style="color:#000000;background:#afffff;" title="#afffff">159
</td></tr>
<tr>
<td style="color:#ffffff;background:#d70000;" title="#d70000">160
</td>
<td style="color:#ffffff;background:#d7005f;" title="#d7005f">161
</td>
<td style="color:#ffffff;background:#d70087;" title="#d70087">162
</td>
<td style="color:#ffffff;background:#d700af;" title="#d700af">163
</td>
<td style="color:#ffffff;background:#d700d7;" title="#d700d7">164
</td>
<td style="color:#ffffff;background:#d700ff;" title="#d700ff">165
</td>
<td style="color:#ffffff;background:#d75f00;" title="#d75f00">166
</td>
<td style="color:#ffffff;background:#d75f5f;" title="#d75f5f">167
</td>
<td style="color:#ffffff;background:#d75f87;" title="#d75f87">168
</td>
<td style="color:#ffffff;background:#d75faf;" title="#d75faf">169
</td>
<td style="color:#ffffff;background:#d75fd7;" title="#d75fd7">170
</td>
<td style="color:#ffffff;background:#d75fff;" title="#d75fff">171
</td>
<td style="color:#ffffff;background:#d78700;" title="#d78700">172
</td>
<td style="color:#ffffff;background:#d7875f;" title="#d7875f">173
</td>
<td style="color:#ffffff;background:#d78787;" title="#d78787">174
</td>
<td style="color:#ffffff;background:#d787af;" title="#d787af">175
</td>
<td style="color:#ffffff;background:#d787d7;" title="#d787d7">176
</td>
<td style="color:#ffffff;background:#d787ff;" title="#d787ff">177
</td>
<td style="color:#000000;background:#d7af00;" title="#d7af00">178
</td>
<td style="color:#000000;background:#d7af5f;" title="#d7af5f">179
</td>
<td style="color:#000000;background:#d7af87;" title="#d7af87">180
</td>
<td style="color:#000000;background:#d7afaf;" title="#d7afaf">181
</td>
<td style="color:#000000;background:#d7afd7;" title="#d7afd7">182
</td>
<td style="color:#000000;background:#d7afff;" title="#d7afff">183
</td>
<td style="color:#000000;background:#d7d700;" title="#d7d700">184
</td>
<td style="color:#000000;background:#d7d75f;" title="#d7d75f">185
</td>
<td style="color:#000000;background:#d7d787;" title="#d7d787">186
</td>
<td style="color:#000000;background:#d7d7af;" title="#d7d7af">187
</td>
<td style="color:#000000;background:#d7d7d7;" title="#d7d7d7">188
</td>
<td style="color:#000000;background:#d7d7ff;" title="#d7d7ff">189
</td>
<td style="color:#000000;background:#d7ff00;" title="#d7ff00">190
</td>
<td style="color:#000000;background:#d7ff5f;" title="#d7ff5f">191
</td>
<td style="color:#000000;background:#d7ff87;" title="#d7ff87">192
</td>
<td style="color:#000000;background:#d7ffaf;" title="#d7ffaf">193
</td>
<td style="color:#000000;background:#d7ffd7;" title="#d7ffd7">194
</td>
<td style="color:#000000;background:#d7ffff;" title="#d7ffff">195
</td></tr>
<tr>
<td style="color:#ffffff;background:#ff0000;" title="#ff0000">196
</td>
<td style="color:#ffffff;background:#ff005f;" title="#ff005f">197
</td>
<td style="color:#ffffff;background:#ff0087;" title="#ff0087">198
</td>
<td style="color:#ffffff;background:#ff00af;" title="#ff00af">199
</td>
<td style="color:#ffffff;background:#ff00d7;" title="#ff00d7">200
</td>
<td style="color:#ffffff;background:#ff00ff;" title="#ff00ff">201
</td>
<td style="color:#ffffff;background:#ff5f00;" title="#ff5f00">202
</td>
<td style="color:#ffffff;background:#ff5f5f;" title="#ff5f5f">203
</td>
<td style="color:#ffffff;background:#ff5f87;" title="#ff5f87">204
</td>
<td style="color:#ffffff;background:#ff5faf;" title="#ff5faf">205
</td>
<td style="color:#ffffff;background:#ff5fd7;" title="#ff5fd7">206
</td>
<td style="color:#ffffff;background:#ff5fff;" title="#ff5fff">207
</td>
<td style="color:#ffffff;background:#ff8700;" title="#ff8700">208
</td>
<td style="color:#ffffff;background:#ff875f;" title="#ff875f">209
</td>
<td style="color:#ffffff;background:#ff8787;" title="#ff8787">210
</td>
<td style="color:#ffffff;background:#ff87af;" title="#ff87af">211
</td>
<td style="color:#ffffff;background:#ff87d7;" title="#ff87d7">212
</td>
<td style="color:#ffffff;background:#ff87ff;" title="#ff87ff">213
</td>
<td style="color:#000000;background:#ffaf00;" title="#ffaf00">214
</td>
<td style="color:#000000;background:#ffaf5f;" title="#ffaf5f">215
</td>
<td style="color:#000000;background:#ffaf87;" title="#ffaf87">216
</td>
<td style="color:#000000;background:#ffafaf;" title="#ffafaf">217
</td>
<td style="color:#000000;background:#ffafd7;" title="#ffafd7">218
</td>
<td style="color:#000000;background:#ffafff;" title="#ffafff">219
</td>
<td style="color:#000000;background:#ffd700;" title="#ffd700">220
</td>
<td style="color:#000000;background:#ffd75f;" title="#ffd75f">221
</td>
<td style="color:#000000;background:#ffd787;" title="#ffd787">222
</td>
<td style="color:#000000;background:#ffd7af;" title="#ffd7af">223
</td>
<td style="color:#000000;background:#ffd7d7;" title="#ffd7d7">224
</td>
<td style="color:#000000;background:#ffd7ff;" title="#ffd7ff">225
</td>
<td style="color:#000000;background:#ffff00;" title="#ffff00">226
</td>
<td style="color:#000000;background:#ffff5f;" title="#ffff5f">227
</td>
<td style="color:#000000;background:#ffff87;" title="#ffff87">228
</td>
<td style="color:#000000;background:#ffffaf;" title="#ffffaf">229
</td>
<td style="color:#000000;background:#ffffd7;" title="#ffffd7">230
</td>
<td style="color:#000000;background:#ffffff;" title="#ffffff">231
</td></tr>


<tr>
<td colspan="36" style="font-size: 12px;text-align:center;">Grayscale colors
</td></tr>
<tr>
<td colspan="36">
<table style="width:100%;text-align:center;font-weight:bold;">

<tbody><tr>
<td style="color:#ffffff;background:#080808;" title="#080808">232
</td>
<td style="color:#ffffff;background:#121212;" title="#121212">233
</td>
<td style="color:#ffffff;background:#1c1c1c;" title="#1c1c1c">234
</td>
<td style="color:#ffffff;background:#262626;" title="#262626">235
</td>
<td style="color:#ffffff;background:#303030;" title="#303030">236
</td>
<td style="color:#ffffff;background:#3a3a3a;" title="#3a3a3a">237
</td>
<td style="color:#ffffff;background:#444444;" title="#444444">238
</td>
<td style="color:#ffffff;background:#4e4e4e;" title="#4e4e4e">239
</td>
<td style="color:#ffffff;background:#585858;" title="#585858">240
</td>
<td style="color:#ffffff;background:#626262;" title="#626262">241
</td>
<td style="color:#ffffff;background:#6c6c6c;" title="#6c6c6c">242
</td>
<td style="color:#ffffff;background:#767676;" title="#767676">243
</td>
<td style="color:#000000;background:#808080;" title="#808080">244
</td>
<td style="color:#000000;background:#8a8a8a;" title="#8a8a8a">245
</td>
<td style="color:#000000;background:#949494;" title="#949494">246
</td>
<td style="color:#000000;background:#9e9e9e;" title="#9e9e9e">247
</td>
<td style="color:#000000;background:#a8a8a8;" title="#a8a8a8">248
</td>
<td style="color:#000000;background:#b2b2b2;" title="#b2b2b2">249
</td>
<td style="color:#000000;background:#bcbcbc;" title="#bcbcbc">250
</td>
<td style="color:#000000;background:#c6c6c6;" title="#c6c6c6">251
</td>
<td style="color:#000000;background:#d0d0d0;" title="#d0d0d0">252
</td>
<td style="color:#000000;background:#dadada;" title="#dadada">253
</td>
<td style="color:#000000;background:#e4e4e4;" title="#e4e4e4">254
</td>
<td style="color:#000000;background:#eeeeee;" title="#eeeeee">255
</td></tr></tbody></table>
</td></tr></tbody></table>

## X11/CSS/SVG Colors

This is reference table of the X11/CSS/SVG foreground/background colors and the method names to access them. 




  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:ital,wght@0,300;0,400;0,500;0,700;1,400&amp;display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<style>
body {
  -webkit-text-size-adjust: 100%;
  overflow-x: hidden;
  font-family: Roboto, sans-serif;
  font-size: 16px;
  line-height: 1.42857143;
  color: #111111;
  background-color: #fff;
}
.colortable {
  font-size: 14px;
}
</style>
<style type="text/css" media="all">
table {
	border-collapse: collapse;
	border-top: 1px solid #fff;
	font: 100 1em sans-serif;
  margin: auto;
  cursor: pointer;
}
#x11colors tr {
  border: grey solid 2px;
  outline:none;
}
tr.dark td {
	color: #fff;
  background-color: #fff;
}
tr.light td span {
  padding: 5px 5px;
	background-color: #000;
}
tr.dark td span {
  padding: 5px 5px;
	background-color: #fff;
}
th {
	text-align: center;
}
th, td {
	padding: 0.8em 0.75em 0.5em;
	border-bottom: 1px solid #fff;
}
thead th {
	border-bottom: 1px solid gray;
}
thead th a[href] {
	color: #000;
	text-decoration: none;
	display: block;
}
thead th[id] a:after {
	content: " ⬦";
	color: #CCC;
}
thead th.sortby a:after {
	font-size: 80%;
	color: #333;
}
thead th.sortby.asc a:after {
	content: " ▼";
}
thead th.sortby.dsc a:after {
	content: " ▲";
}
thead th.sortby {
	background: whitesmoke;
	background:
		-webkit-repeating-linear-gradient(
			0deg,
			transparent 3px,
			rgba(0,0,0,0.01) 6px,
			transparent 9px),
		whitesmoke;
	background:
		-moz-repeating-linear-gradient(
			0deg,
			transparent 3px,
			rgba(0,0,0,0.01) 6px,
			transparent 9px),
		whitesmoke;
	background:
		-o-repeating-linear-gradient(
			0deg,
			transparent 3px,
			rgba(0,0,0,0.01) 6px,
			transparent 9px),
		whitesmoke;
	background:
		repeating-linear-gradient(
			0deg,
			transparent 3px,
			rgba(0,0,0,0.01) 6px,
			transparent 9px),
		whitesmoke;
}

tbody th, td {
	font-weight: normal;
	font: 1.1em monospace;
	}
</style>
<script type="text/javascript">

var sortedAnsiIn = false;

function includeAnsiChange() {
  var ansiCheckBox = document.getElementById("includeAnsiBase");

  if(!sortedAnsiIn) {
    // We never showed ansi before so we need to sort into the current sort
    if(document.getElementsByClassName("sortby")) {
      // we are sorted by something
      var s = document.getElementsByClassName("sortby")[0];
      if(s) {
        // get the ID
        var id = s.id;
        var type = id.replace('Sort','');
        // now clear sorting and act like we never have
        resetSortClasses();
        sort(type);
        // var ascending = s.classList.contains(asc);

        // s.classList.remove("sortby");
        // s.classList.remove("asc");
        // s.classList.remove("dsc");
      }
    }
  }

  var hide = !ansiCheckBox.checked;
  ansiRows = document.querySelectorAll(".baseansicolor");
	for (i = 0; i < ansiRows.length; i++) {
		ansiRows[i].hidden = hide;
	}
}

function resetSortClasses() {
  if(document.getElementsByClassName("sortby")) {
    var s = document.getElementsByClassName("sortby")[0];
    if(s) {
      s.classList.remove("sortby");
      s.classList.remove("asc");
      s.classList.remove("dsc");
    }
  }
}

function rewriteTable() {
  function removeAllChildNodes(parent) {
    while (parent.firstChild) {
        parent.removeChild(parent.firstChild);
    }
}
  tbody = document.querySelector("#x11colors");
  removeAllChildNodes(tbody);
	var limit = sorter.length;
	for (i = 0; i < sorter.length; i++) {
    tbody.appendChild(sorter[i].tr);
	}
}

function nameSort(a,b) {
	return a.name.localeCompare(b.name);
}
function rgbSort(a,b) {
	return (a.red - b.red || a.green - b.green || a.blue - b.blue);
}
function hslSort(a,b) {
	return (a.hue - b.hue || a.sat - b.sat || a.light - b.light);
}
function luminSort(a,b) {
	return (a.lumin - b.lumin);
}

function sort(type) {
	if (!type) return false;
	var header = document.getElementById(type+"Sort");
	if (header.classList.contains("sortby")) {
    if(!sortedAnsiIn) {
      sorter.sort(window[type+"Sort"]);
      sortedAnsiIn = true;
    }
		sorter.reverse();
		header.classList.toggle("asc");
		header.classList.toggle("dsc");
	} else {
		sorter.sort(window[type+"Sort"]);
		resetSortClasses();
		header.classList.add("sortby");
		header.classList.add("asc");
	}
  sortedAnsiIn = true;
	rewriteTable();
}

function indexer(rows) {
	var array = [];
	var rownum = rows.length;
	var rgb = '';
	for (i = 0;  i < rownum; i++) {
    if(rows[i].getElementsByTagName("td").length==0) continue;
		var name = rows[i].getElementsByTagName("td")[0].textContent;
		var cells = rows[i].getElementsByTagName("td");
    var title = cells[0].title;
    var parts = title.split(' ');
		var rgbd = parts[1];
		var hsl = parts[2];

    window.console.log(`${title} ${parts}`);
		rgb = rgbd.substring(4,rgbd.length-1).split(",");
		hsl = hsl.substring(4,hsl.length-1).split(",")
		var bits = new Array();
		bits["row"] = i;
		bits["name"] = name;
		bits["red"] = parseInt(rgb[0]);
		bits["green"] = parseInt(rgb[1]);
		bits["blue"] = parseInt(rgb[2]);
		bits["hue"] = parseInt(hsl[0]);
		bits["sat"] = parseFloat(hsl[1]);
		bits["light"] = parseFloat(hsl[2]);
		bits["lumin"] = (rgb[0]*0.375) + (rgb[1]*0.5) + (rgb[2]*0.125);

window.console.log(`Lumin for ${name} is ${bits["lumin"]}`);

		bits["tr"] = rows[i];
		array.push(bits);
	}
	return array;
}

function startup() {
  tbody = document.querySelector("#x11colors");
  rows = tbody.getElementsByTagName("tr");
	sorter = indexer(rows);
}

var sorter = [];

</script>

<table class="colortable" style="border-style:none;
  width:90%;text-align:center;font-weight:bold; border-collapse: separate;">
<thead>
<tr><th style="font-size: 150%;" colspan="2">Chalk X11/CSS/SVG Color Style Methods
<span style="margin-left: 20px;"><label style="font-size:50%" for="includeAnsiBase">Include basic ansi colors</label>
<input type="checkbox" id="includeAnsiBase" name="includeAnsiBase" value="off" onchange="includeAnsiChange();"></span>
</th></tr>
<tr>
<th id="nameSort"  colspan="2"class="sortby asc"><a href="javascript:sort('name');">Name sort</a></th>
</tr>
<tr>
<th id="rgbSort" colspan="2"><a href="javascript:sort('rgb');">RGB sort</a></th>
</tr>
<tr>
<th id="hslSort" colspan="2"><a href="javascript:sort('hsl');">HSL sort</a></th>
</tr>
<tr>
<th id="luminSort" colspan="2"><a href="javascript:sort('lumin');">Brightness sort</a></th>
</tr>


<tr style="border-bottom: grey solid 2px;">
<th>Method name to set as forground color</th><th>Method name to set as background color</th>
</tr>
</thead>
<tbody id="x11colors">

<tr class="light" >
<td title="0xF0F8FF rgb(240,248,255) hsl(208,100,97)" style="outline:solid aliceblue 1px;  border: solid aliceblue 7px;color: aliceblue;background-color: aliceblue;"><span>.aliceBlue</span></td>
</td><td title="0xF0F8FF rgb(240,248,255) hsl(208,100,97)" style="outline:solid aliceblue 1px;border:solid aliceblue thick;background-color: aliceblue;">.onAliceBlue</td>
<tr>
<tr class="light" >
<td title="0xFAEBD7 rgb(250,235,215) hsl(34,78,91)" style="outline:solid antiquewhite 1px;  border: solid antiquewhite 7px;color: antiquewhite;background-color: antiquewhite;"><span>.antiqueWhite</span></td>
</td><td title="0xFAEBD7 rgb(250,235,215) hsl(34,78,91)" style="outline:solid antiquewhite 1px;border:solid antiquewhite thick;background-color: antiquewhite;">.onAntiqueWhite</td>
<tr>
<tr class="light" >
<td title="0x00FFFF rgb(0,255,255) hsl(180,100,50)" style="outline:solid aqua 1px;  border: solid aqua 7px;color: aqua;background-color: aqua;"><span>.aqua</span></td>
</td><td title="0x00FFFF rgb(0,255,255) hsl(180,100,50)" style="outline:solid aqua 1px;border:solid aqua thick;background-color: aqua;">.onAqua</td>
<tr>
<tr class="light" >
<td title="0x7FFFD4 rgb(127,255,212) hsl(160,100,75)" style="outline:solid aquamarine 1px;  border: solid aquamarine 7px;color: aquamarine;background-color: aquamarine;"><span>.aquamarine</span></td>
</td><td title="0x7FFFD4 rgb(127,255,212) hsl(160,100,75)" style="outline:solid aquamarine 1px;border:solid aquamarine thick;background-color: aquamarine;">.onAquamarine</td>
<tr>
<tr class="light" >
<td title="0xF0FFFF rgb(240,255,255) hsl(180,100,97)" style="outline:solid azure 1px;  border: solid azure 7px;color: azure;background-color: azure;"><span>.azure</span></td>
</td><td title="0xF0FFFF rgb(240,255,255) hsl(180,100,97)" style="outline:solid azure 1px;border:solid azure thick;background-color: azure;">.onAzure</td>
<tr>
<tr class="light" >
<td title="0xF5F5DC rgb(245,245,220) hsl(60,56,91)" style="outline:solid beige 1px;  border: solid beige 7px;color: beige;background-color: beige;"><span>.beige</span></td>
</td><td title="0xF5F5DC rgb(245,245,220) hsl(60,56,91)" style="outline:solid beige 1px;border:solid beige thick;background-color: beige;">.onBeige</td>
<tr>
<tr class="light" >
<td title="0xFFE4C4 rgb(255,228,196) hsl(33,100,88)" style="outline:solid bisque 1px;  border: solid bisque 7px;color: bisque;background-color: bisque;"><span>.bisque</span></td>
</td><td title="0xFFE4C4 rgb(255,228,196) hsl(33,100,88)" style="outline:solid bisque 1px;border:solid bisque thick;background-color: bisque;">.onBisque</td>
<tr>
<tr class="dark" >
<td title="0x000000 rgb(0,0,0) hsl(0,0,0)" style="outline:solid black 1px;  border: solid black 7px;color: black;background-color: black;"><span>.blackX11</span></td>
</td><td title="0x000000 rgb(0,0,0) hsl(0,0,0)" style="outline:solid black 1px;border:solid black thick;background-color: black;">.onBlackX11</td>
<tr>
<tr class="light" >
<td title="0xFFEBCD rgb(255,235,205) hsl(36,100,90)" style="outline:solid blanchedalmond 1px;  border: solid blanchedalmond 7px;color: blanchedalmond;background-color: blanchedalmond;"><span>.blanchedAlmond</span></td>
</td><td title="0xFFEBCD rgb(255,235,205) hsl(36,100,90)" style="outline:solid blanchedalmond 1px;border:solid blanchedalmond thick;background-color: blanchedalmond;">.onBlanchedAlmond</td>
<tr>
<tr class="dark" >
<td title="0x0000FF rgb(0,0,255) hsl(240,100,50)" style="outline:solid blue 1px;  border: solid blue 7px;color: blue;background-color: blue;"><span>.blueX11</span></td>
</td><td title="0x0000FF rgb(0,0,255) hsl(240,100,50)" style="outline:solid blue 1px;border:solid blue thick;background-color: blue;">.onBlueX11</td>
<tr>
<tr class="dark" >
<td title="0x8A2BE2 rgb(138,43,226) hsl(271,76,53)" style="outline:solid blueviolet 1px;  border: solid blueviolet 7px;color: blueviolet;background-color: blueviolet;"><span>.blueViolet</span></td>
</td><td title="0x8A2BE2 rgb(138,43,226) hsl(271,76,53)" style="outline:solid blueviolet 1px;border:solid blueviolet thick;background-color: blueviolet;">.onBlueViolet</td>
<tr>
<tr class="dark" >
<td title="0xA52A2A rgb(165,42,42) hsl(0,59,41)" style="outline:solid brown 1px;  border: solid brown 7px;color: brown;background-color: brown;"><span>.brown</span></td>
</td><td title="0xA52A2A rgb(165,42,42) hsl(0,59,41)" style="outline:solid brown 1px;border:solid brown thick;background-color: brown;">.onBrown</td>
<tr>
<tr class="light" >
<td title="0xDEB887 rgb(222,184,135) hsl(34,57,70)" style="outline:solid burlywood 1px;  border: solid burlywood 7px;color: burlywood;background-color: burlywood;"><span>.burlywood</span></td>
</td><td title="0xDEB887 rgb(222,184,135) hsl(34,57,70)" style="outline:solid burlywood 1px;border:solid burlywood thick;background-color: burlywood;">.onBurlywood</td>
<tr>
<tr class="light" >
<td title="0x5F9EA0 rgb(95,158,160) hsl(182,25,50)" style="outline:solid cadetblue 1px;  border: solid cadetblue 7px;color: cadetblue;background-color: cadetblue;"><span>.cadetBlue</span></td>
</td><td title="0x5F9EA0 rgb(95,158,160) hsl(182,25,50)" style="outline:solid cadetblue 1px;border:solid cadetblue thick;background-color: cadetblue;">.onCadetBlue</td>
<tr>
<tr class="light" >
<td title="0x7FFF00 rgb(127,255,0) hsl(90,100,50)" style="outline:solid chartreuse 1px;  border: solid chartreuse 7px;color: chartreuse;background-color: chartreuse;"><span>.chartreuse</span></td>
</td><td title="0x7FFF00 rgb(127,255,0) hsl(90,100,50)" style="outline:solid chartreuse 1px;border:solid chartreuse thick;background-color: chartreuse;">.onChartreuse</td>
<tr>
<tr class="light" >
<td title="0xD2691E rgb(210,105,30) hsl(25,75,47)" style="outline:solid chocolate 1px;  border: solid chocolate 7px;color: chocolate;background-color: chocolate;"><span>.chocolate</span></td>
</td><td title="0xD2691E rgb(210,105,30) hsl(25,75,47)" style="outline:solid chocolate 1px;border:solid chocolate thick;background-color: chocolate;">.onChocolate</td>
<tr>
<tr class="light" >
<td title="0xFF7F50 rgb(255,127,80) hsl(16,100,66)" style="outline:solid coral 1px;  border: solid coral 7px;color: coral;background-color: coral;"><span>.coral</span></td>
</td><td title="0xFF7F50 rgb(255,127,80) hsl(16,100,66)" style="outline:solid coral 1px;border:solid coral thick;background-color: coral;">.onCoral</td>
<tr>
<tr class="light" >
<td title="0x6495ED rgb(100,149,237) hsl(219,79,66)" style="outline:solid cornflowerblue 1px;  border: solid cornflowerblue 7px;color: cornflowerblue;background-color: cornflowerblue;"><span>.cornflowerBlue</span></td>
</td><td title="0x6495ED rgb(100,149,237) hsl(219,79,66)" style="outline:solid cornflowerblue 1px;border:solid cornflowerblue thick;background-color: cornflowerblue;">.onCornflowerBlue</td>
<tr>
<tr class="light" >
<td title="0xFFF8DC rgb(255,248,220) hsl(48,100,93)" style="outline:solid cornsilk 1px;  border: solid cornsilk 7px;color: cornsilk;background-color: cornsilk;"><span>.cornsilk</span></td>
</td><td title="0xFFF8DC rgb(255,248,220) hsl(48,100,93)" style="outline:solid cornsilk 1px;border:solid cornsilk thick;background-color: cornsilk;">.onCornsilk</td>
<tr>
<tr class="dark" >
<td title="0xDC143C rgb(220,20,60) hsl(348,83,47)" style="outline:solid crimson 1px;  border: solid crimson 7px;color: crimson;background-color: crimson;"><span>.crimson</span></td>
</td><td title="0xDC143C rgb(220,20,60) hsl(348,83,47)" style="outline:solid crimson 1px;border:solid crimson thick;background-color: crimson;">.onCrimson</td>
<tr>
<tr class="light" >
<td title="0x00FFFF rgb(0,255,255) hsl(180,100,50)" style="outline:solid cyan 1px;  border: solid cyan 7px;color: cyan;background-color: cyan;"><span>.cyanX11</span></td>
</td><td title="0x00FFFF rgb(0,255,255) hsl(180,100,50)" style="outline:solid cyan 1px;border:solid cyan thick;background-color: cyan;">.onCyanX11</td>
<tr>
<tr class="dark" >
<td title="0x00008B rgb(0,0,139) hsl(240,100,27)" style="outline:solid darkblue 1px;  border: solid darkblue 7px;color: darkblue;background-color: darkblue;"><span>.darkBlue</span></td>
</td><td title="0x00008B rgb(0,0,139) hsl(240,100,27)" style="outline:solid darkblue 1px;border:solid darkblue thick;background-color: darkblue;">.onDarkBlue</td>
<tr>
<tr class="dark" >
<td title="0x008B8B rgb(0,139,139) hsl(180,100,27)" style="outline:solid darkcyan 1px;  border: solid darkcyan 7px;color: darkcyan;background-color: darkcyan;"><span>.darkCyan</span></td>
</td><td title="0x008B8B rgb(0,139,139) hsl(180,100,27)" style="outline:solid darkcyan 1px;border:solid darkcyan thick;background-color: darkcyan;">.onDarkCyan</td>
<tr>
<tr class="light" >
<td title="0xB8860B rgb(184,134,11) hsl(43,89,38)" style="outline:solid darkgoldenrod 1px;  border: solid darkgoldenrod 7px;color: darkgoldenrod;background-color: darkgoldenrod;"><span>.darkGoldenrod</span></td>
</td><td title="0xB8860B rgb(184,134,11) hsl(43,89,38)" style="outline:solid darkgoldenrod 1px;border:solid darkgoldenrod thick;background-color: darkgoldenrod;">.onDarkGoldenrod</td>
<tr>
<tr class="light" >
<td title="0xA9A9A9 rgb(169,169,169) hsl(0,0,66)" style="outline:solid darkgray 1px;  border: solid darkgray 7px;color: darkgray;background-color: darkgray;"><span>.darkGray</span></td>
</td><td title="0xA9A9A9 rgb(169,169,169) hsl(0,0,66)" style="outline:solid darkgray 1px;border:solid darkgray thick;background-color: darkgray;">.onDarkGray</td>
<tr>
<tr class="dark" >
<td title="0x006400 rgb(0,100,0) hsl(120,100,20)" style="outline:solid darkgreen 1px;  border: solid darkgreen 7px;color: darkgreen;background-color: darkgreen;"><span>.darkGreen</span></td>
</td><td title="0x006400 rgb(0,100,0) hsl(120,100,20)" style="outline:solid darkgreen 1px;border:solid darkgreen thick;background-color: darkgreen;">.onDarkGreen</td>
<tr>
<tr class="light" >
<td title="0xA9A9A9 rgb(169,169,169) hsl(0,0,66)" style="outline:solid darkgrey 1px;  border: solid darkgrey 7px;color: darkgrey;background-color: darkgrey;"><span>.darkGrey</span></td>
</td><td title="0xA9A9A9 rgb(169,169,169) hsl(0,0,66)" style="outline:solid darkgrey 1px;border:solid darkgrey thick;background-color: darkgrey;">.onDarkGrey</td>
<tr>
<tr class="light" >
<td title="0xBDB76B rgb(189,183,107) hsl(56,38,58)" style="outline:solid darkkhaki 1px;  border: solid darkkhaki 7px;color: darkkhaki;background-color: darkkhaki;"><span>.darkKhaki</span></td>
</td><td title="0xBDB76B rgb(189,183,107) hsl(56,38,58)" style="outline:solid darkkhaki 1px;border:solid darkkhaki thick;background-color: darkkhaki;">.onDarkKhaki</td>
<tr>
<tr class="dark" >
<td title="0x8B008B rgb(139,0,139) hsl(300,100,27)" style="outline:solid darkmagenta 1px;  border: solid darkmagenta 7px;color: darkmagenta;background-color: darkmagenta;"><span>.darkMagenta</span></td>
</td><td title="0x8B008B rgb(139,0,139) hsl(300,100,27)" style="outline:solid darkmagenta 1px;border:solid darkmagenta thick;background-color: darkmagenta;">.onDarkMagenta</td>
<tr>
<tr class="dark" >
<td title="0x556B2F rgb(85,107,47) hsl(82,39,30)" style="outline:solid darkolivegreen 1px;  border: solid darkolivegreen 7px;color: darkolivegreen;background-color: darkolivegreen;"><span>.darkOliveGreen</span></td>
</td><td title="0x556B2F rgb(85,107,47) hsl(82,39,30)" style="outline:solid darkolivegreen 1px;border:solid darkolivegreen thick;background-color: darkolivegreen;">.onDarkOliveGreen</td>
<tr>
<tr class="light" >
<td title="0xFF8C00 rgb(255,140,0) hsl(33,100,50)" style="outline:solid darkorange 1px;  border: solid darkorange 7px;color: darkorange;background-color: darkorange;"><span>.darkOrange</span></td>
</td><td title="0xFF8C00 rgb(255,140,0) hsl(33,100,50)" style="outline:solid darkorange 1px;border:solid darkorange thick;background-color: darkorange;">.onDarkOrange</td>
<tr>
<tr class="dark" >
<td title="0x9932CC rgb(153,50,204) hsl(280,61,50)" style="outline:solid darkorchid 1px;  border: solid darkorchid 7px;color: darkorchid;background-color: darkorchid;"><span>.darkOrchid</span></td>
</td><td title="0x9932CC rgb(153,50,204) hsl(280,61,50)" style="outline:solid darkorchid 1px;border:solid darkorchid thick;background-color: darkorchid;">.onDarkOrchid</td>
<tr>
<tr class="dark" >
<td title="0x8B0000 rgb(139,0,0) hsl(0,100,27)" style="outline:solid darkred 1px;  border: solid darkred 7px;color: darkred;background-color: darkred;"><span>.darkRed</span></td>
</td><td title="0x8B0000 rgb(139,0,0) hsl(0,100,27)" style="outline:solid darkred 1px;border:solid darkred thick;background-color: darkred;">.onDarkRed</td>
<tr>
<tr class="light" >
<td title="0xE9967A rgb(233,150,122) hsl(15,72,70)" style="outline:solid darksalmon 1px;  border: solid darksalmon 7px;color: darksalmon;background-color: darksalmon;"><span>.darkSalmon</span></td>
</td><td title="0xE9967A rgb(233,150,122) hsl(15,72,70)" style="outline:solid darksalmon 1px;border:solid darksalmon thick;background-color: darksalmon;">.onDarkSalmon</td>
<tr>
<tr class="light" >
<td title="0x8FBC8F rgb(143,188,143) hsl(120,25,65)" style="outline:solid darkseagreen 1px;  border: solid darkseagreen 7px;color: darkseagreen;background-color: darkseagreen;"><span>.darkSeaGreen</span></td>
</td><td title="0x8FBC8F rgb(143,188,143) hsl(120,25,65)" style="outline:solid darkseagreen 1px;border:solid darkseagreen thick;background-color: darkseagreen;">.onDarkSeaGreen</td>
<tr>
<tr class="dark" >
<td title="0x483D8B rgb(72,61,139) hsl(248,39,39)" style="outline:solid darkslateblue 1px;  border: solid darkslateblue 7px;color: darkslateblue;background-color: darkslateblue;"><span>.darkSlateBlue</span></td>
</td><td title="0x483D8B rgb(72,61,139) hsl(248,39,39)" style="outline:solid darkslateblue 1px;border:solid darkslateblue thick;background-color: darkslateblue;">.onDarkSlateBlue</td>
<tr>
<tr class="dark" >
<td title="0x2F4F4F rgb(47,79,79) hsl(180,25,25)" style="outline:solid darkslategray 1px;  border: solid darkslategray 7px;color: darkslategray;background-color: darkslategray;"><span>.darkSlateGray</span></td>
</td><td title="0x2F4F4F rgb(47,79,79) hsl(180,25,25)" style="outline:solid darkslategray 1px;border:solid darkslategray thick;background-color: darkslategray;">.onDarkSlateGray</td>
<tr>
<tr class="dark" >
<td title="0x2F4F4F rgb(47,79,79) hsl(180,25,25)" style="outline:solid darkslategrey 1px;  border: solid darkslategrey 7px;color: darkslategrey;background-color: darkslategrey;"><span>.darkSlateGrey</span></td>
</td><td title="0x2F4F4F rgb(47,79,79) hsl(180,25,25)" style="outline:solid darkslategrey 1px;border:solid darkslategrey thick;background-color: darkslategrey;">.onDarkSlateGrey</td>
<tr>
<tr class="light" >
<td title="0x00CED1 rgb(0,206,209) hsl(181,100,41)" style="outline:solid darkturquoise 1px;  border: solid darkturquoise 7px;color: darkturquoise;background-color: darkturquoise;"><span>.darkTurquoise</span></td>
</td><td title="0x00CED1 rgb(0,206,209) hsl(181,100,41)" style="outline:solid darkturquoise 1px;border:solid darkturquoise thick;background-color: darkturquoise;">.onDarkTurquoise</td>
<tr>
<tr class="dark" >
<td title="0x9400D3 rgb(148,0,211) hsl(282,100,41)" style="outline:solid darkviolet 1px;  border: solid darkviolet 7px;color: darkviolet;background-color: darkviolet;"><span>.darkViolet</span></td>
</td><td title="0x9400D3 rgb(148,0,211) hsl(282,100,41)" style="outline:solid darkviolet 1px;border:solid darkviolet thick;background-color: darkviolet;">.onDarkViolet</td>
<tr>
<tr class="light" >
<td title="0xFF1493 rgb(255,20,147) hsl(328,100,54)" style="outline:solid deeppink 1px;  border: solid deeppink 7px;color: deeppink;background-color: deeppink;"><span>.deepPink</span></td>
</td><td title="0xFF1493 rgb(255,20,147) hsl(328,100,54)" style="outline:solid deeppink 1px;border:solid deeppink thick;background-color: deeppink;">.onDeepPink</td>
<tr>
<tr class="light" >
<td title="0x00BFFF rgb(0,191,255) hsl(195,100,50)" style="outline:solid deepskyblue 1px;  border: solid deepskyblue 7px;color: deepskyblue;background-color: deepskyblue;"><span>.deepSkyBlue</span></td>
</td><td title="0x00BFFF rgb(0,191,255) hsl(195,100,50)" style="outline:solid deepskyblue 1px;border:solid deepskyblue thick;background-color: deepskyblue;">.onDeepSkyBlue</td>
<tr>
<tr class="dark" >
<td title="0x696969 rgb(105,105,105) hsl(0,0,41)" style="outline:solid dimgray 1px;  border: solid dimgray 7px;color: dimgray;background-color: dimgray;"><span>.dimGray</span></td>
</td><td title="0x696969 rgb(105,105,105) hsl(0,0,41)" style="outline:solid dimgray 1px;border:solid dimgray thick;background-color: dimgray;">.onDimGray</td>
<tr>
<tr class="dark" >
<td title="0x696969 rgb(105,105,105) hsl(0,0,41)" style="outline:solid dimgrey 1px;  border: solid dimgrey 7px;color: dimgrey;background-color: dimgrey;"><span>.dimGrey</span></td>
</td><td title="0x696969 rgb(105,105,105) hsl(0,0,41)" style="outline:solid dimgrey 1px;border:solid dimgrey thick;background-color: dimgrey;">.onDimGrey</td>
<tr>
<tr class="dark" >
<td title="0x1E90FF rgb(30,144,255) hsl(210,100,56)" style="outline:solid dodgerblue 1px;  border: solid dodgerblue 7px;color: dodgerblue;background-color: dodgerblue;"><span>.dodgerBlue</span></td>
</td><td title="0x1E90FF rgb(30,144,255) hsl(210,100,56)" style="outline:solid dodgerblue 1px;border:solid dodgerblue thick;background-color: dodgerblue;">.onDodgerBlue</td>
<tr>
<tr class="dark" >
<td title="0xB22222 rgb(178,34,34) hsl(0,68,42)" style="outline:solid firebrick 1px;  border: solid firebrick 7px;color: firebrick;background-color: firebrick;"><span>.fireBrick</span></td>
</td><td title="0xB22222 rgb(178,34,34) hsl(0,68,42)" style="outline:solid firebrick 1px;border:solid firebrick thick;background-color: firebrick;">.onFireBrick</td>
<tr>
<tr class="light" >
<td title="0xFFFAF0 rgb(255,250,240) hsl(40,100,97)" style="outline:solid floralwhite 1px;  border: solid floralwhite 7px;color: floralwhite;background-color: floralwhite;"><span>.floralWhite</span></td>
</td><td title="0xFFFAF0 rgb(255,250,240) hsl(40,100,97)" style="outline:solid floralwhite 1px;border:solid floralwhite thick;background-color: floralwhite;">.onFloralWhite</td>
<tr>
<tr class="dark" >
<td title="0x228B22 rgb(34,139,34) hsl(120,61,34)" style="outline:solid forestgreen 1px;  border: solid forestgreen 7px;color: forestgreen;background-color: forestgreen;"><span>.forestGreen</span></td>
</td><td title="0x228B22 rgb(34,139,34) hsl(120,61,34)" style="outline:solid forestgreen 1px;border:solid forestgreen thick;background-color: forestgreen;">.onForestGreen</td>
<tr>
<tr class="light" >
<td title="0xFF00FF rgb(255,0,255) hsl(300,100,50)" style="outline:solid fuchsia 1px;  border: solid fuchsia 7px;color: fuchsia;background-color: fuchsia;"><span>.fuchsia</span></td>
</td><td title="0xFF00FF rgb(255,0,255) hsl(300,100,50)" style="outline:solid fuchsia 1px;border:solid fuchsia thick;background-color: fuchsia;">.onFuchsia</td>
<tr>
<tr class="light" >
<td title="0xDCDCDC rgb(220,220,220) hsl(0,0,86)" style="outline:solid gainsboro 1px;  border: solid gainsboro 7px;color: gainsboro;background-color: gainsboro;"><span>.gainsboro</span></td>
</td><td title="0xDCDCDC rgb(220,220,220) hsl(0,0,86)" style="outline:solid gainsboro 1px;border:solid gainsboro thick;background-color: gainsboro;">.onGainsboro</td>
<tr>
<tr class="light" >
<td title="0xF8F8FF rgb(248,248,255) hsl(240,100,99)" style="outline:solid ghostwhite 1px;  border: solid ghostwhite 7px;color: ghostwhite;background-color: ghostwhite;"><span>.ghostWhite</span></td>
</td><td title="0xF8F8FF rgb(248,248,255) hsl(240,100,99)" style="outline:solid ghostwhite 1px;border:solid ghostwhite thick;background-color: ghostwhite;">.onGhostWhite</td>
<tr>
<tr class="light" >
<td title="0xFFD700 rgb(255,215,0) hsl(51,100,50)" style="outline:solid gold 1px;  border: solid gold 7px;color: gold;background-color: gold;"><span>.gold</span></td>
</td><td title="0xFFD700 rgb(255,215,0) hsl(51,100,50)" style="outline:solid gold 1px;border:solid gold thick;background-color: gold;">.onGold</td>
<tr>
<tr class="light" >
<td title="0xDAA520 rgb(218,165,32) hsl(43,74,49)" style="outline:solid goldenrod 1px;  border: solid goldenrod 7px;color: goldenrod;background-color: goldenrod;"><span>.goldenrod</span></td>
</td><td title="0xDAA520 rgb(218,165,32) hsl(43,74,49)" style="outline:solid goldenrod 1px;border:solid goldenrod thick;background-color: goldenrod;">.onGoldenrod</td>
<tr>
<tr class="light" >
<td title="0x808080 rgb(128,128,128) hsl(0,0,50)" style="outline:solid gray 1px;  border: solid gray 7px;color: gray;background-color: gray;"><span>.grayX11</span></td>
</td><td title="0x808080 rgb(128,128,128) hsl(0,0,50)" style="outline:solid gray 1px;border:solid gray thick;background-color: gray;">.onGrayX11</td>
<tr>
<tr class="dark" >
<td title="0x008000 rgb(0,128,0) hsl(120,100,25)" style="outline:solid green 1px;  border: solid green 7px;color: green;background-color: green;"><span>.greenX11</span></td>
</td><td title="0x008000 rgb(0,128,0) hsl(120,100,25)" style="outline:solid green 1px;border:solid green thick;background-color: green;">.onGreenX11</td>
<tr>
<tr class="light" >
<td title="0xADFF2F rgb(173,255,47) hsl(84,100,59)" style="outline:solid greenyellow 1px;  border: solid greenyellow 7px;color: greenyellow;background-color: greenyellow;"><span>.greenYellow</span></td>
</td><td title="0xADFF2F rgb(173,255,47) hsl(84,100,59)" style="outline:solid greenyellow 1px;border:solid greenyellow thick;background-color: greenyellow;">.onGreenYellow</td>
<tr>
<tr class="light" >
<td title="0x808080 rgb(128,128,128) hsl(0,0,50)" style="outline:solid grey 1px;  border: solid grey 7px;color: grey;background-color: grey;"><span>.greyX11</span></td>
</td><td title="0x808080 rgb(128,128,128) hsl(0,0,50)" style="outline:solid grey 1px;border:solid grey thick;background-color: grey;">.onGreyX11</td>
<tr>
<tr class="light" >
<td title="0xF0FFF0 rgb(240,255,240) hsl(120,100,97)" style="outline:solid honeydew 1px;  border: solid honeydew 7px;color: honeydew;background-color: honeydew;"><span>.honeydew</span></td>
</td><td title="0xF0FFF0 rgb(240,255,240) hsl(120,100,97)" style="outline:solid honeydew 1px;border:solid honeydew thick;background-color: honeydew;">.onHoneydew</td>
<tr>
<tr class="light" >
<td title="0xFF69B4 rgb(255,105,180) hsl(330,100,71)" style="outline:solid hotpink 1px;  border: solid hotpink 7px;color: hotpink;background-color: hotpink;"><span>.hotPink</span></td>
</td><td title="0xFF69B4 rgb(255,105,180) hsl(330,100,71)" style="outline:solid hotpink 1px;border:solid hotpink thick;background-color: hotpink;">.onHotPink</td>
<tr>
<tr class="light" >
<td title="0xCD5C5C rgb(205,92,92) hsl(0,53,58)" style="outline:solid indianred 1px;  border: solid indianred 7px;color: indianred;background-color: indianred;"><span>.indianRed</span></td>
</td><td title="0xCD5C5C rgb(205,92,92) hsl(0,53,58)" style="outline:solid indianred 1px;border:solid indianred thick;background-color: indianred;">.onIndianRed</td>
<tr>
<tr class="dark" >
<td title="0x4B0082 rgb(75,0,130) hsl(275,100,25)" style="outline:solid indigo 1px;  border: solid indigo 7px;color: indigo;background-color: indigo;"><span>.indigo</span></td>
</td><td title="0x4B0082 rgb(75,0,130) hsl(275,100,25)" style="outline:solid indigo 1px;border:solid indigo thick;background-color: indigo;">.onIndigo</td>
<tr>
<tr class="light" >
<td title="0xFFFFF0 rgb(255,255,240) hsl(60,100,97)" style="outline:solid ivory 1px;  border: solid ivory 7px;color: ivory;background-color: ivory;"><span>.ivory</span></td>
</td><td title="0xFFFFF0 rgb(255,255,240) hsl(60,100,97)" style="outline:solid ivory 1px;border:solid ivory thick;background-color: ivory;">.onIvory</td>
<tr>
<tr class="light" >
<td title="0xF0E68C rgb(240,230,140) hsl(54,77,75)" style="outline:solid khaki 1px;  border: solid khaki 7px;color: khaki;background-color: khaki;"><span>.khaki</span></td>
</td><td title="0xF0E68C rgb(240,230,140) hsl(54,77,75)" style="outline:solid khaki 1px;border:solid khaki thick;background-color: khaki;">.onKhaki</td>
<tr>
<tr class="light" >
<td title="0xE6E6FA rgb(230,230,250) hsl(240,67,94)" style="outline:solid lavender 1px;  border: solid lavender 7px;color: lavender;background-color: lavender;"><span>.lavender</span></td>
</td><td title="0xE6E6FA rgb(230,230,250) hsl(240,67,94)" style="outline:solid lavender 1px;border:solid lavender thick;background-color: lavender;">.onLavender</td>
<tr>
<tr class="light" >
<td title="0xFFF0F5 rgb(255,240,245) hsl(340,100,97)" style="outline:solid lavenderblush 1px;  border: solid lavenderblush 7px;color: lavenderblush;background-color: lavenderblush;"><span>.lavenderBlush</span></td>
</td><td title="0xFFF0F5 rgb(255,240,245) hsl(340,100,97)" style="outline:solid lavenderblush 1px;border:solid lavenderblush thick;background-color: lavenderblush;">.onLavenderBlush</td>
<tr>
<tr class="light" >
<td title="0x7CFC00 rgb(124,252,0) hsl(90,100,49)" style="outline:solid lawngreen 1px;  border: solid lawngreen 7px;color: lawngreen;background-color: lawngreen;"><span>.lawnGreen</span></td>
</td><td title="0x7CFC00 rgb(124,252,0) hsl(90,100,49)" style="outline:solid lawngreen 1px;border:solid lawngreen thick;background-color: lawngreen;">.onLawnGreen</td>
<tr>
<tr class="light" >
<td title="0xFFFACD rgb(255,250,205) hsl(54,100,90)" style="outline:solid lemonchiffon 1px;  border: solid lemonchiffon 7px;color: lemonchiffon;background-color: lemonchiffon;"><span>.lemonChiffon</span></td>
</td><td title="0xFFFACD rgb(255,250,205) hsl(54,100,90)" style="outline:solid lemonchiffon 1px;border:solid lemonchiffon thick;background-color: lemonchiffon;">.onLemonChiffon</td>
<tr>
<tr class="light" >
<td title="0xADD8E6 rgb(173,216,230) hsl(195,53,79)" style="outline:solid lightblue 1px;  border: solid lightblue 7px;color: lightblue;background-color: lightblue;"><span>.lightBlue</span></td>
</td><td title="0xADD8E6 rgb(173,216,230) hsl(195,53,79)" style="outline:solid lightblue 1px;border:solid lightblue thick;background-color: lightblue;">.onLightBlue</td>
<tr>
<tr class="light" >
<td title="0xF08080 rgb(240,128,128) hsl(0,79,72)" style="outline:solid lightcoral 1px;  border: solid lightcoral 7px;color: lightcoral;background-color: lightcoral;"><span>.lightCoral</span></td>
</td><td title="0xF08080 rgb(240,128,128) hsl(0,79,72)" style="outline:solid lightcoral 1px;border:solid lightcoral thick;background-color: lightcoral;">.onLightCoral</td>
<tr>
<tr class="light" >
<td title="0xE0FFFF rgb(224,255,255) hsl(180,100,94)" style="outline:solid lightcyan 1px;  border: solid lightcyan 7px;color: lightcyan;background-color: lightcyan;"><span>.lightCyan</span></td>
</td><td title="0xE0FFFF rgb(224,255,255) hsl(180,100,94)" style="outline:solid lightcyan 1px;border:solid lightcyan thick;background-color: lightcyan;">.onLightCyan</td>
<tr>
<tr class="light" >
<td title="0xFAFAD2 rgb(250,250,210) hsl(60,80,90)" style="outline:solid lightgoldenrodyellow 1px;  border: solid lightgoldenrodyellow 7px;color: lightgoldenrodyellow;background-color: lightgoldenrodyellow;"><span>.lightGoldenrodYellow</span></td>
</td><td title="0xFAFAD2 rgb(250,250,210) hsl(60,80,90)" style="outline:solid lightgoldenrodyellow 1px;border:solid lightgoldenrodyellow thick;background-color: lightgoldenrodyellow;">.onLightGoldenrodYellow</td>
<tr>
<tr class="light" >
<td title="0xFAFAD2 rgb(250,250,210) hsl(60,80,90)" style="outline:solid rgb(250, 250, 210) 1px;  border: solid rgb(250, 250, 210) 7px;color: rgb(250, 250, 210);background-color: rgb(250, 250, 210);"><span>.lightGoldenrod</span></td>
</td><td title="0xFAFAD2 rgb(250,250,210) hsl(60,80,90)" style="outline:solid rgb(250, 250, 210) 1px;border:solid rgb(250, 250, 210) thick;background-color: rgb(250, 250, 210);">.onLightGoldenrod</td>
<tr>
<tr class="light" >
<td title="0xD3D3D3 rgb(211,211,211) hsl(0,0,83)" style="outline:solid lightgray 1px;  border: solid lightgray 7px;color: lightgray;background-color: lightgray;"><span>.lightGray</span></td>
</td><td title="0xD3D3D3 rgb(211,211,211) hsl(0,0,83)" style="outline:solid lightgray 1px;border:solid lightgray thick;background-color: lightgray;">.onLightGray</td>
<tr>
<tr class="light" >
<td title="0x90EE90 rgb(144,238,144) hsl(120,73,75)" style="outline:solid lightgreen 1px;  border: solid lightgreen 7px;color: lightgreen;background-color: lightgreen;"><span>.lightGreen</span></td>
</td><td title="0x90EE90 rgb(144,238,144) hsl(120,73,75)" style="outline:solid lightgreen 1px;border:solid lightgreen thick;background-color: lightgreen;">.onLightGreen</td>
<tr>
<tr class="light" >
<td title="0xD3D3D3 rgb(211,211,211) hsl(0,0,83)" style="outline:solid lightgrey 1px;  border: solid lightgrey 7px;color: lightgrey;background-color: lightgrey;"><span>.lightGrey</span></td>
</td><td title="0xD3D3D3 rgb(211,211,211) hsl(0,0,83)" style="outline:solid lightgrey 1px;border:solid lightgrey thick;background-color: lightgrey;">.onLightGrey</td>
<tr>
<tr class="light" >
<td title="0xFFB6C1 rgb(255,182,193) hsl(351,100,86)" style="outline:solid lightpink 1px;  border: solid lightpink 7px;color: lightpink;background-color: lightpink;"><span>.lightPink</span></td>
</td><td title="0xFFB6C1 rgb(255,182,193) hsl(351,100,86)" style="outline:solid lightpink 1px;border:solid lightpink thick;background-color: lightpink;">.onLightPink</td>
<tr>
<tr class="light" >
<td title="0xFFA07A rgb(255,160,122) hsl(17,100,74)" style="outline:solid lightsalmon 1px;  border: solid lightsalmon 7px;color: lightsalmon;background-color: lightsalmon;"><span>.lightSalmon</span></td>
</td><td title="0xFFA07A rgb(255,160,122) hsl(17,100,74)" style="outline:solid lightsalmon 1px;border:solid lightsalmon thick;background-color: lightsalmon;">.onLightSalmon</td>
<tr>
<tr class="light" >
<td title="0x20B2AA rgb(32,178,170) hsl(177,70,41)" style="outline:solid lightseagreen 1px;  border: solid lightseagreen 7px;color: lightseagreen;background-color: lightseagreen;"><span>.lightSeaGreen</span></td>
</td><td title="0x20B2AA rgb(32,178,170) hsl(177,70,41)" style="outline:solid lightseagreen 1px;border:solid lightseagreen thick;background-color: lightseagreen;">.onLightSeaGreen</td>
<tr>
<tr class="light" >
<td title="0x87CEFA rgb(135,206,250) hsl(203,92,75)" style="outline:solid lightskyblue 1px;  border: solid lightskyblue 7px;color: lightskyblue;background-color: lightskyblue;"><span>.lightSkyBlue</span></td>
</td><td title="0x87CEFA rgb(135,206,250) hsl(203,92,75)" style="outline:solid lightskyblue 1px;border:solid lightskyblue thick;background-color: lightskyblue;">.onLightSkyBlue</td>
<tr>
<tr class="light" >
<td title="0x778899 rgb(119,136,153) hsl(210,14,53)" style="outline:solid lightslategray 1px;  border: solid lightslategray 7px;color: lightslategray;background-color: lightslategray;"><span>.lightSlateGray</span></td>
</td><td title="0x778899 rgb(119,136,153) hsl(210,14,53)" style="outline:solid lightslategray 1px;border:solid lightslategray thick;background-color: lightslategray;">.onLightSlateGray</td>
<tr>
<tr class="light" >
<td title="0x778899 rgb(119,136,153) hsl(210,14,53)" style="outline:solid lightslategrey 1px;  border: solid lightslategrey 7px;color: lightslategrey;background-color: lightslategrey;"><span>.lightSlateGrey</span></td>
</td><td title="0x778899 rgb(119,136,153) hsl(210,14,53)" style="outline:solid lightslategrey 1px;border:solid lightslategrey thick;background-color: lightslategrey;">.onLightSlateGrey</td>
<tr>
<tr class="light" >
<td title="0xB0C4DE rgb(176,196,222) hsl(214,41,78)" style="outline:solid lightsteelblue 1px;  border: solid lightsteelblue 7px;color: lightsteelblue;background-color: lightsteelblue;"><span>.lightSteelBlue</span></td>
</td><td title="0xB0C4DE rgb(176,196,222) hsl(214,41,78)" style="outline:solid lightsteelblue 1px;border:solid lightsteelblue thick;background-color: lightsteelblue;">.onLightSteelBlue</td>
<tr>
<tr class="light" >
<td title="0xFFFFE0 rgb(255,255,224) hsl(60,100,94)" style="outline:solid lightyellow 1px;  border: solid lightyellow 7px;color: lightyellow;background-color: lightyellow;"><span>.lightYellow</span></td>
</td><td title="0xFFFFE0 rgb(255,255,224) hsl(60,100,94)" style="outline:solid lightyellow 1px;border:solid lightyellow thick;background-color: lightyellow;">.onLightYellow</td>
<tr>
<tr class="light" >
<td title="0x00FF00 rgb(0,255,0) hsl(120,100,50)" style="outline:solid lime 1px;  border: solid lime 7px;color: lime;background-color: lime;"><span>.lime</span></td>
</td><td title="0x00FF00 rgb(0,255,0) hsl(120,100,50)" style="outline:solid lime 1px;border:solid lime thick;background-color: lime;">.onLime</td>
<tr>
<tr class="light" >
<td title="0x32CD32 rgb(50,205,50) hsl(120,61,50)" style="outline:solid limegreen 1px;  border: solid limegreen 7px;color: limegreen;background-color: limegreen;"><span>.limeGreen</span></td>
</td><td title="0x32CD32 rgb(50,205,50) hsl(120,61,50)" style="outline:solid limegreen 1px;border:solid limegreen thick;background-color: limegreen;">.onLimeGreen</td>
<tr>
<tr class="light" >
<td title="0xFAF0E6 rgb(250,240,230) hsl(30,67,94)" style="outline:solid linen 1px;  border: solid linen 7px;color: linen;background-color: linen;"><span>.linen</span></td>
</td><td title="0xFAF0E6 rgb(250,240,230) hsl(30,67,94)" style="outline:solid linen 1px;border:solid linen thick;background-color: linen;">.onLinen</td>
<tr>
<tr class="light" >
<td title="0xFF00FF rgb(255,0,255) hsl(300,100,50)" style="outline:solid magenta 1px;  border: solid magenta 7px;color: magenta;background-color: magenta;"><span>.magentaX11</span></td>
</td><td title="0xFF00FF rgb(255,0,255) hsl(300,100,50)" style="outline:solid magenta 1px;border:solid magenta thick;background-color: magenta;">.onMagentaX11</td>
<tr>
<tr class="dark" >
<td title="0x800000 rgb(128,0,0) hsl(0,100,25)" style="outline:solid maroon 1px;  border: solid maroon 7px;color: maroon;background-color: maroon;"><span>.maroon</span></td>
</td><td title="0x800000 rgb(128,0,0) hsl(0,100,25)" style="outline:solid maroon 1px;border:solid maroon thick;background-color: maroon;">.onMaroon</td>
<tr>
<tr class="light" >
<td title="0x66CDAA rgb(102,205,170) hsl(160,51,60)" style="outline:solid mediumaquamarine 1px;  border: solid mediumaquamarine 7px;color: mediumaquamarine;background-color: mediumaquamarine;"><span>.mediumAquamarine</span></td>
</td><td title="0x66CDAA rgb(102,205,170) hsl(160,51,60)" style="outline:solid mediumaquamarine 1px;border:solid mediumaquamarine thick;background-color: mediumaquamarine;">.onMediumAquamarine</td>
<tr>
<tr class="dark" >
<td title="0x0000CD rgb(0,0,205) hsl(240,100,40)" style="outline:solid mediumblue 1px;  border: solid mediumblue 7px;color: mediumblue;background-color: mediumblue;"><span>.mediumBlue</span></td>
</td><td title="0x0000CD rgb(0,0,205) hsl(240,100,40)" style="outline:solid mediumblue 1px;border:solid mediumblue thick;background-color: mediumblue;">.onMediumBlue</td>
<tr>
<tr class="light" >
<td title="0xBA55D3 rgb(186,85,211) hsl(288,59,58)" style="outline:solid mediumorchid 1px;  border: solid mediumorchid 7px;color: mediumorchid;background-color: mediumorchid;"><span>.mediumOrchid</span></td>
</td><td title="0xBA55D3 rgb(186,85,211) hsl(288,59,58)" style="outline:solid mediumorchid 1px;border:solid mediumorchid thick;background-color: mediumorchid;">.onMediumOrchid</td>
<tr>
<tr class="light" >
<td title="0x9370DB rgb(147,112,219) hsl(260,60,65)" style="outline:solid mediumpurple 1px;  border: solid mediumpurple 7px;color: mediumpurple;background-color: mediumpurple;"><span>.mediumPurple</span></td>
</td><td title="0x9370DB rgb(147,112,219) hsl(260,60,65)" style="outline:solid mediumpurple 1px;border:solid mediumpurple thick;background-color: mediumpurple;">.onMediumPurple</td>
<tr>
<tr class="light" >
<td title="0x3CB371 rgb(60,179,113) hsl(147,50,47)" style="outline:solid mediumseagreen 1px;  border: solid mediumseagreen 7px;color: mediumseagreen;background-color: mediumseagreen;"><span>.mediumSeaGreen</span></td>
</td><td title="0x3CB371 rgb(60,179,113) hsl(147,50,47)" style="outline:solid mediumseagreen 1px;border:solid mediumseagreen thick;background-color: mediumseagreen;">.onMediumSeaGreen</td>
<tr>
<tr class="light" >
<td title="0x7B68EE rgb(123,104,238) hsl(249,80,67)" style="outline:solid mediumslateblue 1px;  border: solid mediumslateblue 7px;color: mediumslateblue;background-color: mediumslateblue;"><span>.mediumSlateBlue</span></td>
</td><td title="0x7B68EE rgb(123,104,238) hsl(249,80,67)" style="outline:solid mediumslateblue 1px;border:solid mediumslateblue thick;background-color: mediumslateblue;">.onMediumSlateBlue</td>
<tr>
<tr class="light" >
<td title="0x00FA9A rgb(0,250,154) hsl(157,100,49)" style="outline:solid mediumspringgreen 1px;  border: solid mediumspringgreen 7px;color: mediumspringgreen;background-color: mediumspringgreen;"><span>.mediumSpringGreen</span></td>
</td><td title="0x00FA9A rgb(0,250,154) hsl(157,100,49)" style="outline:solid mediumspringgreen 1px;border:solid mediumspringgreen thick;background-color: mediumspringgreen;">.onMediumSpringGreen</td>
<tr>
<tr class="light" >
<td title="0x48D1CC rgb(72,209,204) hsl(178,60,55)" style="outline:solid mediumturquoise 1px;  border: solid mediumturquoise 7px;color: mediumturquoise;background-color: mediumturquoise;"><span>.mediumTurquoise</span></td>
</td><td title="0x48D1CC rgb(72,209,204) hsl(178,60,55)" style="outline:solid mediumturquoise 1px;border:solid mediumturquoise thick;background-color: mediumturquoise;">.onMediumTurquoise</td>
<tr>
<tr class="dark" >
<td title="0xC71585 rgb(199,21,133) hsl(322,81,43)" style="outline:solid mediumvioletred 1px;  border: solid mediumvioletred 7px;color: mediumvioletred;background-color: mediumvioletred;"><span>.mediumVioletRed</span></td>
</td><td title="0xC71585 rgb(199,21,133) hsl(322,81,43)" style="outline:solid mediumvioletred 1px;border:solid mediumvioletred thick;background-color: mediumvioletred;">.onMediumVioletRed</td>
<tr>
<tr class="dark" >
<td title="0x191970 rgb(25,25,112) hsl(240,64,27)" style="outline:solid midnightblue 1px;  border: solid midnightblue 7px;color: midnightblue;background-color: midnightblue;"><span>.midnightBlue</span></td>
</td><td title="0x191970 rgb(25,25,112) hsl(240,64,27)" style="outline:solid midnightblue 1px;border:solid midnightblue thick;background-color: midnightblue;">.onMidnightBlue</td>
<tr>
<tr class="light" >
<td title="0xF5FFFA rgb(245,255,250) hsl(150,100,98)" style="outline:solid mintcream 1px;  border: solid mintcream 7px;color: mintcream;background-color: mintcream;"><span>.mintCream</span></td>
</td><td title="0xF5FFFA rgb(245,255,250) hsl(150,100,98)" style="outline:solid mintcream 1px;border:solid mintcream thick;background-color: mintcream;">.onMintCream</td>
<tr>
<tr class="light" >
<td title="0xFFE4E1 rgb(255,228,225) hsl(6,100,94)" style="outline:solid mistyrose 1px;  border: solid mistyrose 7px;color: mistyrose;background-color: mistyrose;"><span>.mistyRose</span></td>
</td><td title="0xFFE4E1 rgb(255,228,225) hsl(6,100,94)" style="outline:solid mistyrose 1px;border:solid mistyrose thick;background-color: mistyrose;">.onMistyRose</td>
<tr>
<tr class="light" >
<td title="0xFFE4B5 rgb(255,228,181) hsl(38,100,85)" style="outline:solid moccasin 1px;  border: solid moccasin 7px;color: moccasin;background-color: moccasin;"><span>.moccasin</span></td>
</td><td title="0xFFE4B5 rgb(255,228,181) hsl(38,100,85)" style="outline:solid moccasin 1px;border:solid moccasin thick;background-color: moccasin;">.onMoccasin</td>
<tr>
<tr class="light" >
<td title="0xFFDEAD rgb(255,222,173) hsl(36,100,84)" style="outline:solid navajowhite 1px;  border: solid navajowhite 7px;color: navajowhite;background-color: navajowhite;"><span>.navajoWhite</span></td>
</td><td title="0xFFDEAD rgb(255,222,173) hsl(36,100,84)" style="outline:solid navajowhite 1px;border:solid navajowhite thick;background-color: navajowhite;">.onNavajoWhite</td>
<tr>
<tr class="dark" >
<td title="0x000080 rgb(0,0,128) hsl(240,100,25)" style="outline:solid navy 1px;  border: solid navy 7px;color: navy;background-color: navy;"><span>.navy</span></td>
</td><td title="0x000080 rgb(0,0,128) hsl(240,100,25)" style="outline:solid navy 1px;border:solid navy thick;background-color: navy;">.onNavy</td>
<tr>
<tr class="light" >
<td title="0xFDF5E6 rgb(253,245,230) hsl(39,85,95)" style="outline:solid oldlace 1px;  border: solid oldlace 7px;color: oldlace;background-color: oldlace;"><span>.oldLace</span></td>
</td><td title="0xFDF5E6 rgb(253,245,230) hsl(39,85,95)" style="outline:solid oldlace 1px;border:solid oldlace thick;background-color: oldlace;">.onOldLace</td>
<tr>
<tr class="dark" >
<td title="0x808000 rgb(128,128,0) hsl(60,100,25)" style="outline:solid olive 1px;  border: solid olive 7px;color: olive;background-color: olive;"><span>.olive</span></td>
</td><td title="0x808000 rgb(128,128,0) hsl(60,100,25)" style="outline:solid olive 1px;border:solid olive thick;background-color: olive;">.onOlive</td>
<tr>
<tr class="dark" >
<td title="0x6B8E23 rgb(107,142,35) hsl(80,60,35)" style="outline:solid olivedrab 1px;  border: solid olivedrab 7px;color: olivedrab;background-color: olivedrab;"><span>.oliveDrab</span></td>
</td><td title="0x6B8E23 rgb(107,142,35) hsl(80,60,35)" style="outline:solid olivedrab 1px;border:solid olivedrab thick;background-color: olivedrab;">.onOliveDrab</td>
<tr>
<tr class="light" >
<td title="0xFFA500 rgb(255,165,0) hsl(39,100,50)" style="outline:solid orange 1px;  border: solid orange 7px;color: orange;background-color: orange;"><span>.orange</span></td>
</td><td title="0xFFA500 rgb(255,165,0) hsl(39,100,50)" style="outline:solid orange 1px;border:solid orange thick;background-color: orange;">.onOrange</td>
<tr>
<tr class="light" >
<td title="0xFF4500 rgb(255,69,0) hsl(16,100,50)" style="outline:solid orangered 1px;  border: solid orangered 7px;color: orangered;background-color: orangered;"><span>.orangeRed</span></td>
</td><td title="0xFF4500 rgb(255,69,0) hsl(16,100,50)" style="outline:solid orangered 1px;border:solid orangered thick;background-color: orangered;">.onOrangeRed</td>
<tr>
<tr class="light" >
<td title="0xDA70D6 rgb(218,112,214) hsl(302,59,65)" style="outline:solid orchid 1px;  border: solid orchid 7px;color: orchid;background-color: orchid;"><span>.orchid</span></td>
</td><td title="0xDA70D6 rgb(218,112,214) hsl(302,59,65)" style="outline:solid orchid 1px;border:solid orchid thick;background-color: orchid;">.onOrchid</td>
<tr>
<tr class="light" >
<td title="0xEEE8AA rgb(238,232,170) hsl(55,67,80)" style="outline:solid palegoldenrod 1px;  border: solid palegoldenrod 7px;color: palegoldenrod;background-color: palegoldenrod;"><span>.paleGoldenrod</span></td>
</td><td title="0xEEE8AA rgb(238,232,170) hsl(55,67,80)" style="outline:solid palegoldenrod 1px;border:solid palegoldenrod thick;background-color: palegoldenrod;">.onPaleGoldenrod</td>
<tr>
<tr class="light" >
<td title="0x98FB98 rgb(152,251,152) hsl(120,93,79)" style="outline:solid palegreen 1px;  border: solid palegreen 7px;color: palegreen;background-color: palegreen;"><span>.paleGreen</span></td>
</td><td title="0x98FB98 rgb(152,251,152) hsl(120,93,79)" style="outline:solid palegreen 1px;border:solid palegreen thick;background-color: palegreen;">.onPaleGreen</td>
<tr>
<tr class="light" >
<td title="0xAFEEEE rgb(175,238,238) hsl(180,65,81)" style="outline:solid paleturquoise 1px;  border: solid paleturquoise 7px;color: paleturquoise;background-color: paleturquoise;"><span>.paleTurquoise</span></td>
</td><td title="0xAFEEEE rgb(175,238,238) hsl(180,65,81)" style="outline:solid paleturquoise 1px;border:solid paleturquoise thick;background-color: paleturquoise;">.onPaleTurquoise</td>
<tr>
<tr class="light" >
<td title="0xDB7093 rgb(219,112,147) hsl(340,60,65)" style="outline:solid palevioletred 1px;  border: solid palevioletred 7px;color: palevioletred;background-color: palevioletred;"><span>.paleVioletRed</span></td>
</td><td title="0xDB7093 rgb(219,112,147) hsl(340,60,65)" style="outline:solid palevioletred 1px;border:solid palevioletred thick;background-color: palevioletred;">.onPaleVioletRed</td>
<tr>
<tr class="light" >
<td title="0xFFEFD5 rgb(255,239,213) hsl(37,100,92)" style="outline:solid papayawhip 1px;  border: solid papayawhip 7px;color: papayawhip;background-color: papayawhip;"><span>.papayaWhip</span></td>
</td><td title="0xFFEFD5 rgb(255,239,213) hsl(37,100,92)" style="outline:solid papayawhip 1px;border:solid papayawhip thick;background-color: papayawhip;">.onPapayaWhip</td>
<tr>
<tr class="light" >
<td title="0xFFDAB9 rgb(255,218,185) hsl(28,100,86)" style="outline:solid peachpuff 1px;  border: solid peachpuff 7px;color: peachpuff;background-color: peachpuff;"><span>.peachPuff</span></td>
</td><td title="0xFFDAB9 rgb(255,218,185) hsl(28,100,86)" style="outline:solid peachpuff 1px;border:solid peachpuff thick;background-color: peachpuff;">.onPeachPuff</td>
<tr>
<tr class="light" >
<td title="0xCD853F rgb(205,133,63) hsl(30,59,53)" style="outline:solid peru 1px;  border: solid peru 7px;color: peru;background-color: peru;"><span>.peru</span></td>
</td><td title="0xCD853F rgb(205,133,63) hsl(30,59,53)" style="outline:solid peru 1px;border:solid peru thick;background-color: peru;">.onPeru</td>
<tr>
<tr class="light" >
<td title="0xFFC0CB rgb(255,192,203) hsl(350,100,88)" style="outline:solid pink 1px;  border: solid pink 7px;color: pink;background-color: pink;"><span>.pink</span></td>
</td><td title="0xFFC0CB rgb(255,192,203) hsl(350,100,88)" style="outline:solid pink 1px;border:solid pink thick;background-color: pink;">.onPink</td>
<tr>
<tr class="light" >
<td title="0xDDA0DD rgb(221,160,221) hsl(300,47,75)" style="outline:solid plum 1px;  border: solid plum 7px;color: plum;background-color: plum;"><span>.plum</span></td>
</td><td title="0xDDA0DD rgb(221,160,221) hsl(300,47,75)" style="outline:solid plum 1px;border:solid plum thick;background-color: plum;">.onPlum</td>
<tr>
<tr class="light" >
<td title="0xB0E0E6 rgb(176,224,230) hsl(187,52,80)" style="outline:solid powderblue 1px;  border: solid powderblue 7px;color: powderblue;background-color: powderblue;"><span>.powderBlue</span></td>
</td><td title="0xB0E0E6 rgb(176,224,230) hsl(187,52,80)" style="outline:solid powderblue 1px;border:solid powderblue thick;background-color: powderblue;">.onPowderBlue</td>
<tr>
<tr class="dark" >
<td title="0x800080 rgb(128,0,128) hsl(300,100,25)" style="outline:solid purple 1px;  border: solid purple 7px;color: purple;background-color: purple;"><span>.purple</span></td>
</td><td title="0x800080 rgb(128,0,128) hsl(300,100,25)" style="outline:solid purple 1px;border:solid purple thick;background-color: purple;">.onPurple</td>
<tr>
<tr class="dark" >
<td title="0x663399 rgb(102,51,153) hsl(270,50,40)" style="outline:solid rgb(102, 51, 153) 1px;  border: solid rgb(102, 51, 153) 7px;color: rgb(102, 51, 153);background-color: rgb(102, 51, 153);"><span>.rebeccaPurple</span></td>
</td><td title="0x663399 rgb(102,51,153) hsl(270,50,40)" style="outline:solid rgb(102, 51, 153) 1px;border:solid rgb(102, 51, 153) thick;background-color: rgb(102, 51, 153);">.onRebeccaPurple</td>
<tr>
<tr class="dark" >
<td title="0xFF0000 rgb(255,0,0) hsl(0,100,50)" style="outline:solid red 1px;  border: solid red 7px;color: red;background-color: red;"><span>.redX11</span></td>
</td><td title="0xFF0000 rgb(255,0,0) hsl(0,100,50)" style="outline:solid red 1px;border:solid red thick;background-color: red;">.onRedX11</td>
<tr>
<tr class="light" >
<td title="0xBC8F8F rgb(188,143,143) hsl(0,25,65)" style="outline:solid rosybrown 1px;  border: solid rosybrown 7px;color: rosybrown;background-color: rosybrown;"><span>.rosyBrown</span></td>
</td><td title="0xBC8F8F rgb(188,143,143) hsl(0,25,65)" style="outline:solid rosybrown 1px;border:solid rosybrown thick;background-color: rosybrown;">.onRosyBrown</td>
<tr>
<tr class="dark" >
<td title="0x4169E1 rgb(65,105,225) hsl(225,73,57)" style="outline:solid royalblue 1px;  border: solid royalblue 7px;color: royalblue;background-color: royalblue;"><span>.royalBlue</span></td>
</td><td title="0x4169E1 rgb(65,105,225) hsl(225,73,57)" style="outline:solid royalblue 1px;border:solid royalblue thick;background-color: royalblue;">.onRoyalBlue</td>
<tr>
<tr class="dark" >
<td title="0x8B4513 rgb(139,69,19) hsl(25,76,31)" style="outline:solid saddlebrown 1px;  border: solid saddlebrown 7px;color: saddlebrown;background-color: saddlebrown;"><span>.saddleBrown</span></td>
</td><td title="0x8B4513 rgb(139,69,19) hsl(25,76,31)" style="outline:solid saddlebrown 1px;border:solid saddlebrown thick;background-color: saddlebrown;">.onSaddleBrown</td>
<tr>
<tr class="light" >
<td title="0xFA8072 rgb(250,128,114) hsl(6,93,71)" style="outline:solid salmon 1px;  border: solid salmon 7px;color: salmon;background-color: salmon;"><span>.salmon</span></td>
</td><td title="0xFA8072 rgb(250,128,114) hsl(6,93,71)" style="outline:solid salmon 1px;border:solid salmon thick;background-color: salmon;">.onSalmon</td>
<tr>
<tr class="light" >
<td title="0xF4A460 rgb(244,164,96) hsl(28,87,67)" style="outline:solid sandybrown 1px;  border: solid sandybrown 7px;color: sandybrown;background-color: sandybrown;"><span>.sandyBrown</span></td>
</td><td title="0xF4A460 rgb(244,164,96) hsl(28,87,67)" style="outline:solid sandybrown 1px;border:solid sandybrown thick;background-color: sandybrown;">.onSandyBrown</td>
<tr>
<tr class="dark" >
<td title="0x2E8B57 rgb(46,139,87) hsl(146,50,36)" style="outline:solid seagreen 1px;  border: solid seagreen 7px;color: seagreen;background-color: seagreen;"><span>.seaGreen</span></td>
</td><td title="0x2E8B57 rgb(46,139,87) hsl(146,50,36)" style="outline:solid seagreen 1px;border:solid seagreen thick;background-color: seagreen;">.onSeaGreen</td>
<tr>
<tr class="light" >
<td title="0xFFF5EE rgb(255,245,238) hsl(25,100,97)" style="outline:solid seashell 1px;  border: solid seashell 7px;color: seashell;background-color: seashell;"><span>.seashell</span></td>
</td><td title="0xFFF5EE rgb(255,245,238) hsl(25,100,97)" style="outline:solid seashell 1px;border:solid seashell thick;background-color: seashell;">.onSeashell</td>
<tr>
<tr class="dark" >
<td title="0xA0522D rgb(160,82,45) hsl(19,56,40)" style="outline:solid sienna 1px;  border: solid sienna 7px;color: sienna;background-color: sienna;"><span>.sienna</span></td>
</td><td title="0xA0522D rgb(160,82,45) hsl(19,56,40)" style="outline:solid sienna 1px;border:solid sienna thick;background-color: sienna;">.onSienna</td>
<tr>
<tr class="light" >
<td title="0xC0C0C0 rgb(192,192,192) hsl(0,0,75)" style="outline:solid silver 1px;  border: solid silver 7px;color: silver;background-color: silver;"><span>.silver</span></td>
</td><td title="0xC0C0C0 rgb(192,192,192) hsl(0,0,75)" style="outline:solid silver 1px;border:solid silver thick;background-color: silver;">.onSilver</td>
<tr>
<tr class="light" >
<td title="0x87CEEB rgb(135,206,235) hsl(197,71,73)" style="outline:solid skyblue 1px;  border: solid skyblue 7px;color: skyblue;background-color: skyblue;"><span>.skyBlue</span></td>
</td><td title="0x87CEEB rgb(135,206,235) hsl(197,71,73)" style="outline:solid skyblue 1px;border:solid skyblue thick;background-color: skyblue;">.onSkyBlue</td>
<tr>
<tr class="dark" >
<td title="0x6A5ACD rgb(106,90,205) hsl(248,53,58)" style="outline:solid slateblue 1px;  border: solid slateblue 7px;color: slateblue;background-color: slateblue;"><span>.slateBlue</span></td>
</td><td title="0x6A5ACD rgb(106,90,205) hsl(248,53,58)" style="outline:solid slateblue 1px;border:solid slateblue thick;background-color: slateblue;">.onSlateBlue</td>
<tr>
<tr class="light" >
<td title="0x708090 rgb(112,128,144) hsl(210,13,50)" style="outline:solid slategray 1px;  border: solid slategray 7px;color: slategray;background-color: slategray;"><span>.slateGray</span></td>
</td><td title="0x708090 rgb(112,128,144) hsl(210,13,50)" style="outline:solid slategray 1px;border:solid slategray thick;background-color: slategray;">.onSlateGray</td>
<tr>
<tr class="light" >
<td title="0x708090 rgb(112,128,144) hsl(210,13,50)" style="outline:solid slategrey 1px;  border: solid slategrey 7px;color: slategrey;background-color: slategrey;"><span>.slateGrey</span></td>
</td><td title="0x708090 rgb(112,128,144) hsl(210,13,50)" style="outline:solid slategrey 1px;border:solid slategrey thick;background-color: slategrey;">.onSlateGrey</td>
<tr>
<tr class="light" >
<td title="0xFFFAFA rgb(255,250,250) hsl(0,100,99)" style="outline:solid snow 1px;  border: solid snow 7px;color: snow;background-color: snow;"><span>.snow</span></td>
</td><td title="0xFFFAFA rgb(255,250,250) hsl(0,100,99)" style="outline:solid snow 1px;border:solid snow thick;background-color: snow;">.onSnow</td>
<tr>
<tr class="light" >
<td title="0x00FF7F rgb(0,255,127) hsl(150,100,50)" style="outline:solid springgreen 1px;  border: solid springgreen 7px;color: springgreen;background-color: springgreen;"><span>.springGreen</span></td>
</td><td title="0x00FF7F rgb(0,255,127) hsl(150,100,50)" style="outline:solid springgreen 1px;border:solid springgreen thick;background-color: springgreen;">.onSpringGreen</td>
<tr>
<tr class="dark" >
<td title="0x4682B4 rgb(70,130,180) hsl(207,44,49)" style="outline:solid steelblue 1px;  border: solid steelblue 7px;color: steelblue;background-color: steelblue;"><span>.steelBlue</span></td>
</td><td title="0x4682B4 rgb(70,130,180) hsl(207,44,49)" style="outline:solid steelblue 1px;border:solid steelblue thick;background-color: steelblue;">.onSteelBlue</td>
<tr>
<tr class="light" >
<td title="0xD2B48C rgb(210,180,140) hsl(34,44,69)" style="outline:solid tan 1px;  border: solid tan 7px;color: tan;background-color: tan;"><span>.tan</span></td>
</td><td title="0xD2B48C rgb(210,180,140) hsl(34,44,69)" style="outline:solid tan 1px;border:solid tan thick;background-color: tan;">.onTan</td>
<tr>
<tr class="dark" >
<td title="0x008080 rgb(0,128,128) hsl(180,100,25)" style="outline:solid teal 1px;  border: solid teal 7px;color: teal;background-color: teal;"><span>.teal</span></td>
</td><td title="0x008080 rgb(0,128,128) hsl(180,100,25)" style="outline:solid teal 1px;border:solid teal thick;background-color: teal;">.onTeal</td>
<tr>
<tr class="light" >
<td title="0xD8BFD8 rgb(216,191,216) hsl(300,24,80)" style="outline:solid thistle 1px;  border: solid thistle 7px;color: thistle;background-color: thistle;"><span>.thistle</span></td>
</td><td title="0xD8BFD8 rgb(216,191,216) hsl(300,24,80)" style="outline:solid thistle 1px;border:solid thistle thick;background-color: thistle;">.onThistle</td>
<tr>
<tr class="light" >
<td title="0xFF6347 rgb(255,99,71) hsl(9,100,64)" style="outline:solid tomato 1px;  border: solid tomato 7px;color: tomato;background-color: tomato;"><span>.tomato</span></td>
</td><td title="0xFF6347 rgb(255,99,71) hsl(9,100,64)" style="outline:solid tomato 1px;border:solid tomato thick;background-color: tomato;">.onTomato</td>
<tr>
<tr class="light" >
<td title="0x40E0D0 rgb(64,224,208) hsl(174,72,56)" style="outline:solid turquoise 1px;  border: solid turquoise 7px;color: turquoise;background-color: turquoise;"><span>.turquoise</span></td>
</td><td title="0x40E0D0 rgb(64,224,208) hsl(174,72,56)" style="outline:solid turquoise 1px;border:solid turquoise thick;background-color: turquoise;">.onTurquoise</td>
<tr>
<tr class="light" >
<td title="0xEE82EE rgb(238,130,238) hsl(300,76,72)" style="outline:solid violet 1px;  border: solid violet 7px;color: violet;background-color: violet;"><span>.violet</span></td>
</td><td title="0xEE82EE rgb(238,130,238) hsl(300,76,72)" style="outline:solid violet 1px;border:solid violet thick;background-color: violet;">.onViolet</td>
<tr>
<tr class="light" >
<td title="0xF5DEB3 rgb(245,222,179) hsl(39,77,83)" style="outline:solid wheat 1px;  border: solid wheat 7px;color: wheat;background-color: wheat;"><span>.wheat</span></td>
</td><td title="0xF5DEB3 rgb(245,222,179) hsl(39,77,83)" style="outline:solid wheat 1px;border:solid wheat thick;background-color: wheat;">.onWheat</td>
<tr>
<tr class="light" >
<td title="0xFFFFFF rgb(255,255,255) hsl(0,0,100)" style="outline:solid white 1px;  border: solid white 7px;color: white;background-color: white;"><span>.whiteX11</span></td>
</td><td title="0xFFFFFF rgb(255,255,255) hsl(0,0,100)" style="outline:solid white 1px;border:solid white thick;background-color: white;">.onWhiteX11</td>
<tr>
<tr class="light" >
<td title="0xF5F5F5 rgb(245,245,245) hsl(0,0,96)" style="outline:solid whitesmoke 1px;  border: solid whitesmoke 7px;color: whitesmoke;background-color: whitesmoke;"><span>.whiteSmoke</span></td>
</td><td title="0xF5F5F5 rgb(245,245,245) hsl(0,0,96)" style="outline:solid whitesmoke 1px;border:solid whitesmoke thick;background-color: whitesmoke;">.onWhiteSmoke</td>
<tr>
<tr class="light" >
<td title="0xFFFF00 rgb(255,255,0) hsl(60,100,50)" style="outline:solid yellow 1px;  border: solid yellow 7px;color: yellow;background-color: yellow;"><span>.yellowX11</span></td>
</td><td title="0xFFFF00 rgb(255,255,0) hsl(60,100,50)" style="outline:solid yellow 1px;border:solid yellow thick;background-color: yellow;">.onYellowX11</td>
<tr>
<tr class="light" >
<td title="0x9ACD32 rgb(154,205,50) hsl(80,61,50)" style="outline:solid yellowgreen 1px;  border: solid yellowgreen 7px;color: yellowgreen;background-color: yellowgreen;"><span>.yellowGreen</span></td>
</td><td title="0x9ACD32 rgb(154,205,50) hsl(80,61,50)" style="outline:solid yellowgreen 1px;border:solid yellowgreen thick;background-color: yellowgreen;">.onYellowGreen</td>
<tr>
<tr class="dark baseansicolor" hidden>
<td title="0xFF0000 rgb(255,0,0) hsl(0,100,50)" style="outline:solid rgb(255, 0, 0) 1px;  border: solid rgb(255, 0, 0) 7px;color: rgb(255, 0, 0);background-color: rgb(255, 0, 0);"><span>.brightRed</span></td>
</td><td title="0xFF0000 rgb(255,0,0) hsl(0,100,50)" style="outline:solid rgb(255, 0, 0) 1px;border:solid rgb(255, 0, 0) thick;background-color: rgb(255, 0, 0);">.onBrightRed</td>
<tr>
<tr class="light baseansicolor" hidden>
<td title="0x00FF00 rgb(0,255,0) hsl(120,100,50)" style="outline:solid rgb(0, 255, 0) 1px;  border: solid rgb(0, 255, 0) 7px;color: rgb(0, 255, 0);background-color: rgb(0, 255, 0);"><span>.brightGreen</span></td>
</td><td title="0x00FF00 rgb(0,255,0) hsl(120,100,50)" style="outline:solid rgb(0, 255, 0) 1px;border:solid rgb(0, 255, 0) thick;background-color: rgb(0, 255, 0);">.onBrightGreen</td>
<tr>
<tr class="dark baseansicolor" hidden>
<td title="0x0000FF rgb(0,0,255) hsl(240,100,50)" style="outline:solid rgb(0, 0, 255) 1px;  border: solid rgb(0, 0, 255) 7px;color: rgb(0, 0, 255);background-color: rgb(0, 0, 255);"><span>.brightBlue</span></td>
</td><td title="0x0000FF rgb(0,0,255) hsl(240,100,50)" style="outline:solid rgb(0, 0, 255) 1px;border:solid rgb(0, 0, 255) thick;background-color: rgb(0, 0, 255);">.onBrightBlue</td>
<tr>
<tr class="light baseansicolor" hidden>
<td title="0x00FFFF rgb(0,255,255) hsl(180,100,50)" style="outline:solid rgb(0, 255, 255) 1px;  border: solid rgb(0, 255, 255) 7px;color: rgb(0, 255, 255);background-color: rgb(0, 255, 255);"><span>.brightCyan</span></td>
</td><td title="0x00FFFF rgb(0,255,255) hsl(180,100,50)" style="outline:solid rgb(0, 255, 255) 1px;border:solid rgb(0, 255, 255) thick;background-color: rgb(0, 255, 255);">.onBrightCyan</td>
<tr>
<tr class="light baseansicolor" hidden>
<td title="0xFFFF00 rgb(255,255,0) hsl(60,100,50)" style="outline:solid rgb(255, 255, 0) 1px;  border: solid rgb(255, 255, 0) 7px;color: rgb(255, 255, 0);background-color: rgb(255, 255, 0);"><span>.brightYellow</span></td>
</td><td title="0xFFFF00 rgb(255,255,0) hsl(60,100,50)" style="outline:solid rgb(255, 255, 0) 1px;border:solid rgb(255, 255, 0) thick;background-color: rgb(255, 255, 0);">.onBrightYellow</td>
<tr>
<tr class="light baseansicolor" hidden>
<td title="0xFF00FF rgb(255,0,255) hsl(300,100,50)" style="outline:solid rgb(255, 0, 255) 1px;  border: solid rgb(255, 0, 255) 7px;color: rgb(255, 0, 255);background-color: rgb(255, 0, 255);"><span>.brightMagenta</span></td>
</td><td title="0xFF00FF rgb(255,0,255) hsl(300,100,50)" style="outline:solid rgb(255, 0, 255) 1px;border:solid rgb(255, 0, 255) thick;background-color: rgb(255, 0, 255);">.onBrightMagenta</td>
<tr>
<tr class="light baseansicolor" hidden>
<td title="0xFFFFFF rgb(255,255,255) hsl(0,0,100)" style="outline:solid rgb(255, 255, 255) 1px;  border: solid rgb(255, 255, 255) 7px;color: rgb(255, 255, 255);background-color: rgb(255, 255, 255);"><span>.brightWhite</span></td>
</td><td title="0xFFFFFF rgb(255,255,255) hsl(0,0,100)" style="outline:solid rgb(255, 255, 255) 1px;border:solid rgb(255, 255, 255) thick;background-color: rgb(255, 255, 255);">.onBrightWhite</td>
<tr>
<tr class="light baseansicolor" hidden>
<td title="0x888888 rgb(136,136,136) hsl(0,0,53)" style="outline:solid rgb(136, 136, 136) 1px;  border: solid rgb(136, 136, 136) 7px;color: rgb(136, 136, 136);background-color: rgb(136, 136, 136);"><span>.brightBlack</span></td>
</td><td title="0x888888 rgb(136,136,136) hsl(0,0,53)" style="outline:solid rgb(136, 136, 136) 1px;border:solid rgb(136, 136, 136) thick;background-color: rgb(136, 136, 136);">.onBrightBlack</td>
<tr>
<tr class="dark baseansicolor" hidden>
<td title="0x880000 rgb(136,0,0) hsl(0,100,27)" style="outline:solid rgb(136, 0, 0) 1px;  border: solid rgb(136, 0, 0) 7px;color: rgb(136, 0, 0);background-color: rgb(136, 0, 0);"><span>.red</span></td>
</td><td title="0x880000 rgb(136,0,0) hsl(0,100,27)" style="outline:solid rgb(136, 0, 0) 1px;border:solid rgb(136, 0, 0) thick;background-color: rgb(136, 0, 0);">.onRed</td>
<tr>
<tr class="dark baseansicolor" hidden>
<td title="0x008800 rgb(0,136,0) hsl(120,100,27)" style="outline:solid rgb(0, 136, 0) 1px;  border: solid rgb(0, 136, 0) 7px;color: rgb(0, 136, 0);background-color: rgb(0, 136, 0);"><span>.green</span></td>
</td><td title="0x008800 rgb(0,136,0) hsl(120,100,27)" style="outline:solid rgb(0, 136, 0) 1px;border:solid rgb(0, 136, 0) thick;background-color: rgb(0, 136, 0);">.onGreen</td>
<tr>
<tr class="dark baseansicolor" hidden>
<td title="0x000088 rgb(0,0,136) hsl(240,100,27)" style="outline:solid rgb(0, 0, 136) 1px;  border: solid rgb(0, 0, 136) 7px;color: rgb(0, 0, 136);background-color: rgb(0, 0, 136);"><span>.blue</span></td>
</td><td title="0x000088 rgb(0,0,136) hsl(240,100,27)" style="outline:solid rgb(0, 0, 136) 1px;border:solid rgb(0, 0, 136) thick;background-color: rgb(0, 0, 136);">.onBlue</td>
<tr>
<tr class="dark baseansicolor" hidden>
<td title="0x008888 rgb(0,136,136) hsl(180,100,27)" style="outline:solid rgb(0, 136, 136) 1px;  border: solid rgb(0, 136, 136) 7px;color: rgb(0, 136, 136);background-color: rgb(0, 136, 136);"><span>.cyan</span></td>
</td><td title="0x008888 rgb(0,136,136) hsl(180,100,27)" style="outline:solid rgb(0, 136, 136) 1px;border:solid rgb(0, 136, 136) thick;background-color: rgb(0, 136, 136);">.onCyan</td>
<tr>
<tr class="dark baseansicolor" hidden>
<td title="0x888800 rgb(136,136,0) hsl(60,100,27)" style="outline:solid rgb(136, 136, 0) 1px;  border: solid rgb(136, 136, 0) 7px;color: rgb(136, 136, 0);background-color: rgb(136, 136, 0);"><span>.yellow</span></td>
</td><td title="0x888800 rgb(136,136,0) hsl(60,100,27)" style="outline:solid rgb(136, 136, 0) 1px;border:solid rgb(136, 136, 0) thick;background-color: rgb(136, 136, 0);">.onYellow</td>
<tr>
<tr class="dark baseansicolor" hidden>
<td title="0x880088 rgb(136,0,136) hsl(300,100,27)" style="outline:solid rgb(136, 0, 136) 1px;  border: solid rgb(136, 0, 136) 7px;color: rgb(136, 0, 136);background-color: rgb(136, 0, 136);"><span>.magenta</span></td>
</td><td title="0x880088 rgb(136,0,136) hsl(300,100,27)" style="outline:solid rgb(136, 0, 136) 1px;border:solid rgb(136, 0, 136) thick;background-color: rgb(136, 0, 136);">.onMagenta</td>
<tr>
<tr class="light baseansicolor" hidden>
<td title="0x888888 rgb(136,136,136) hsl(0,0,53)" style="outline:solid rgb(136, 136, 136) 1px;  border: solid rgb(136, 136, 136) 7px;color: rgb(136, 136, 136);background-color: rgb(136, 136, 136);"><span>.white</span></td>
</td><td title="0x888888 rgb(136,136,136) hsl(0,0,53)" style="outline:solid rgb(136, 136, 136) 1px;border:solid rgb(136, 136, 136) thick;background-color: rgb(136, 136, 136);">.onWhite</td>
<tr>
<tr class="dark baseansicolor" hidden>
<td title="0x000000 rgb(0,0,0) hsl(0,0,0)" style="outline:solid rgb(0, 0, 0) 1px;  border: solid rgb(0, 0, 0) 7px;color: rgb(0, 0, 0);background-color: rgb(0, 0, 0);"><span>.black</span></td>
</td><td title="0x000000 rgb(0,0,0) hsl(0,0,0)" style="outline:solid rgb(0, 0, 0) 1px;border:solid rgb(0, 0, 0) thick;background-color: rgb(0, 0, 0);">.onBlack</td>
<tr>
</tbody></table>
<script>startup();</script>


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

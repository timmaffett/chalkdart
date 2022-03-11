<h1 align="center">
	<br>
	<br>
	<img width="320" src="media/chalkdart.svg" alt="Chalk">
	<br>
	<br>
	<br>
</h1>

> A library for Dart developers.

## Usage

A simple usage example:

```dart
import 'package:chalkdart/chalkdart.dart';

main() {
  var awesome = new Awesome();
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme

<h1 align="center">
	<br>
	<br>
	<img width="320" src="media/chalkdart.svg" alt="Chalk">
	<br>
	<br>
	<br>
</h1>

> Terminal string styling done right

[![Coverage Status](https://coveralls.io/repos/github/chalk/chalk/badge.svg?branch=main)](https://coveralls.io/github/chalk/chalk?branch=main)
[![npm dependents](https://badgen.net/npm/dependents/chalk)](https://www.npmjs.com/package/chalk?activeTab=dependents) [![Downloads](https://badgen.net/npm/dt/chalk)](https://www.npmjs.com/package/chalk)
[![run on repl.it](https://repl.it/badge/github/chalk/chalk)](https://repl.it/github/chalk/chalk)
[![Support Chalk on DEV](https://badge.devprotocol.xyz/0x44d871aebF0126Bf646753E2C976Aa7e68A66c15/descriptive)](https://stakes.social/0x44d871aebF0126Bf646753E2C976Aa7e68A66c15)

<img src="media/chalkdart.svg" width="900">

## Highlights

- Expressive API
- Highly performant
- Ability to nest styles
- [256/Truecolor color support](#256-and-truecolor-color-support)
- Ignores Auto-detected ANSI color support/as common Dart/Flutter IDE's report this incorrectly.
- Not an extentension of the `String` class - (this might be nice for Dart though ?)
- Clean and focused
- Actively maintained

## Install

```console
$ dart pub add chalkdart
```

## Usage

```js
const chalk = require('chalk');

print(chalk.blue('Hello world!'));
```

Chalk comes with an easy to use composable API where you just chain and nest the styles you want.

```dart
const chalk = require('chalk');
const log = print;

// Combine styled and normal strings
print(chalk.blue('Hello') + ' World' + chalk.red('!'));

// Compose multiple styles using the chainable API
print(chalk.blue.bgRed.bold('Hello world!'));

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

// use in multiline string and in templating
print('''
      CPU: ${chalk.red('90%')}
      RAM: ${chalk.green('40%')}
      DISK: ${chalk.yellow('70%')}
   ''');

// ES2015 tagged template literal
print(chalk`
CPU: {red ${cpu.totalPercent}%}
RAM: {green ${ram.used / ram.total * 100}%}
DISK: {rgb(255,131,0) ${disk.used / disk.total * 100}%}
`);

// Use RGB colors in terminal emulators that support it.
print(chalk.keyword('orange')('Yay for orange colored text!'));
print(chalk.rgb(123, 45, 67).underline('Underlined reddish color'));
print(chalk.hex('#DEADED').bold('Bold gray!'));
```

Easily define your own themes:

```js
const chalk = require('chalk');

const error = chalk.bold.red;
const warning = chalk.keyword('orange');

print(error('Error!'));
print(warning('Warning!'));
```


```dart
const name = 'Sindre';
print(chalk.green('Hello %s'), name);
//=> 'Hello Sindre'
```

## API

### chalk.`<style>[.<style>...](string, [string...])`

Example: `chalk.red.bold.underline('Hello', 'world');`

Chain [styles](#styles) and call the last one as a method with a string argument. Order doesn't matter, and later styles take precedent in case of a conflict. This simply means that `chalk.red.yellow.green` is equivalent to `chalk.green`.

Multiple arguments will be separated by space.

### chalk.level

Specifies the level of color support.

Color support is automatically detected, but you can override it by setting the `level` property. You should however only do this in your own code as it applies globally to all Chalk consumers.

If you need to change this in a reusable module, create a new instance:

```js
const ctx = new chalk.Instance({level: 0});
```

| Level | Description |
| :---: | :--- |
| `0` | All colors disabled |
| `1` | Basic color support (16 colors) |
| `2` | 256 color support |
| `3` | Truecolor support (16 million colors) |

### chalk.supportsColor

Detect whether the terminal [supports color](https://github.com/chalk/supports-color). Used internally and handled for you, but exposed for convenience.

Can be overridden by the user with the flags `--color` and `--no-color`. For situations where using `--color` is not possible, use the environment variable `FORCE_COLOR=1` (level 1), `FORCE_COLOR=2` (level 2), or `FORCE_COLOR=3` (level 3) to forcefully enable color, or `FORCE_COLOR=0` to forcefully disable. The use of `FORCE_COLOR` overrides all other color support checks.

Explicit 256/Truecolor mode can be enabled using the `--color=256` and `--color=16m` flags, respectively.

### chalk.stderr and chalk.stderr.supportsColor

`chalk.stderr` contains a separate instance configured with color support detected for `stderr` stream instead of `stdout`. Override rules from `chalk.supportsColor` apply to this too. `chalk.stderr.supportsColor` is exposed for convenience.

## Styles

### Modifiers

- `reset` - Resets the current color chain.
- `bold` - Make text bold.
- `dim` - Emitting only a small amount of light.
- `italic` - Make text italic.
- `underline` - Make text underline.
- `doubleunderline` - Thicker text underline. *(Not widely supported)*
- `overline` - Make text overline. *(Not widely supported)*
- `inverse`- Inverse background and foreground colors.
- `hidden` - Prints the text, but makes it invisible.
- `strikethrough` - Puts a horizontal line through the center of the text. *(Not widely supported)*
- `visible`- Prints the text only when Chalk has a color level > 0. Can be useful for things that are purely cosmetic.

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

## Tagged template literal

Chalk can be used as a [tagged template literal](https://exploringjs.com/es6/ch_template-literals.html#_tagged-template-literals).

```js
const chalk = require('chalk');

const miles = 18;
const calculateFeet = miles => miles * 5280;

print(chalk`
	There are {bold 5280 feet} in a mile.
	In {bold ${miles} miles}, there are {green.bold ${calculateFeet(miles)} feet}.
`);
```

Blocks are delimited by an opening curly brace (`{`), a style, some content, and a closing curly brace (`}`).

Template styles are chained exactly like normal Chalk styles. The following three statements are equivalent:

```dart
print(chalk.bold.rgb(10, 100, 200)('Hello!'));
print(chalk.bold.rgb(10, 100, 200)`Hello!`);
print(`{chalk.bold.rgb(10,100,200) Hello!}`);
```

Note that function styles (`rgb()`, `hsl()`, `keyword()`, etc.) may not contain spaces between parameters.

All interpolated values (`` chalk`${foo}` ``) are converted to strings via the `.toString()` method. All curly braces (`{` and `}`) in interpolated value strings are escaped.

## 256 and Truecolor color support

Chalk supports 256 colors and [Truecolor](https://gist.github.com/XVilka/8346728) (16 million colors) on supported terminal apps.

Colors are downsampled from 16 million RGB values to an ANSI color format that is supported by the terminal emulator (or by specifying `{level: n}` as a Chalk option). For example, Chalk configured to run at level 1 (basic color support) will downsample an RGB value of #FF0000 (red) to 31 (ANSI escape for red).

Examples:

- `chalk.hex('#DEADED').underline('Hello, world!')`
- `chalk.keyword('orange')('Some orange text')`
- `chalk.rgb(15, 100, 204).inverse('Hello!')`

Background versions of these models are prefixed with `bg` and the first level of the module capitalized (e.g. `keyword` for foreground colors and `bgKeyword` for background colors).

- `chalk.bgHex('#DEADED').underline('Hello, world!')`
- `chalk.bgKeyword('orange')('Some orange text')`
- `chalk.bgRgb(15, 100, 204).inverse('Hello!')`

The following color models can be used:

- [`rgb`](https://en.wikipedia.org/wiki/RGB_color_model) - Example: `chalk.rgb(255, 136, 0).bold('Orange!')`
- [`hex`](https://en.wikipedia.org/wiki/Web_colors#Hex_triplet) - Example: `chalk.hex('#FF8800').bold('Orange!')`
- [`hsl`](https://en.wikipedia.org/wiki/HSL_and_HSV) - Example: `chalk.hsl(32, 100, 50).bold('Orange!')`
- [`hsv`](https://en.wikipedia.org/wiki/HSL_and_HSV) - Example: `chalk.hsv(32, 100, 100).bold('Orange!')`
- [`hwb`](https://en.wikipedia.org/wiki/HWB_color_model) - Example: `chalk.hwb(32, 0, 50).bold('Orange!')`
- [`ansi`](https://en.wikipedia.org/wiki/ANSI_escape_code#3/4_bit) - Example: `chalk.ansi(31).bgAnsi(93)('red on yellowBright')`
- [`ansi256`](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit) - Example: `chalk.bgAnsi256(194)('Honeydew, more or less')`
- [`keyword`](https://www.w3.org/wiki/CSS/Properties/color/keywords) (X11/CSS keywords) - Example: `chalk.cornFlowerBlue.onBeige` or `chalk.keyword('orange').bold('Orange!')`
            The keyword table can be extended via and the new keywords can be accessed via
               ` Chalk.addColorKeywordHex('myfavorite', 0x6495ED ); // using hex int`
                `chalk.color.myfavorite('This is my favorite color');`
                `Chalk.addColorKeywordHex('my2ndFavorite', '#6A5ACD' );  // or using string`
                `chalk.color.my2ndfavorite('This is my 2nd favorite color');`
            or
                `chalk.keyword('myfavorite)('Using the keyword() method');`
                    `chalk.color.XXXX`, `chalk.x11.XXXX`, 

## IDE Support

The terminals and debug consoles in current versions of both Android Studio, IntelliJ and 
Visual Studio Code support 24bit/16M color ansi codes and most attributes.  However, they
both report that they DO NOT support ANSI codes.  For this reason Chalk'Dart defaults to
supporting full level 3 (24 bit) ANSI codes.

## VSCode

I have extended the support for ANSI SGR codes within VSCode to support essentially EVERY ANSI SGR code, and correspondingly every feature of Chalk'Dart.
These are now available in the release version of VSCode.  The font commands are also supported,
but currently you must add font-family definitions to the VSCode stylesheets using the
'Customize UI' extension.

When using VSCode it is possible to Enable full font support for the 10 fonts
by installing the extension "Customize UI" and adding the following to your VSCode settings.json
file.
For the value for each of these CSS selectors you place the font-family of the font you want to use,
and any other css font directives, such as font-style, font-weight, font-size, font-stretch, etc.
In the example below I have including using some common coding font.

Add these to VSCode settings.json, after enabling the "Customize UI" extension:

```json
    "customizeUI.stylesheet": {
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-1" :
               "font-family: Verdana,Arial,sans-serif;",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-2" :
               "font-style: italic; font-size: 16px; padding: 0px; font-family: 'Cascadia Code PL';",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-3" :
               "font-family: 'Segoe WPC', 'Segoe UI';",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-4" : 
               "font-family: 'Cascadia Mono';",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-5" : 
               "font-family: 'Courier New', 'Courier', monospace;",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-6" : 
               "font-size: 16px; padding: 0px; font-family: 'Cascadia Code PL';",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-7" : 
               "font-family: 'Cascadia Mono PL';",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-8" : 
               "font-size: 14px; padding: 0px; font-family: 'Cascadia Code PL';",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-9" : 
               "font-size: 16px; font-family: 'JetBrains Mono';",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-10" : 
               "font-stretch: ultra-expanded; font-weight: bold; font-family: 'League Mono';",
    },
```

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

## X11/CSS Colors

This is reference table of the X11/CSS foreground/background colors and the method names to access them. 




<table style="border-style:none;width:100%;text-align:center;font-weight:bold; border-collapse: separate;"><tbody>
<tr><th style="text-align: center;" colspan="6">Chalk X11/CSS Color Methods</th></tr>
<tr style="border-bottom: grey solid 2px;>
<th>forground style</th><th>background style</th>
<th>forground style</th><th>background style</th>
<th>forground style</th><th>background style</th>
</tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xF0F8FF" style="outline:solid aliceblue 1px;background:transparent;border: solid aliceblue thick;color: aliceblue;">.aliceBlue</td>
</td><td style="outline:solid aliceblue 1px;border:solid aliceblue thick;background-color: aliceblue;color: black;">.onAliceBlue</td>       
<td title="0xFAEBD7" style="outline:solid antiquewhite 1px;background:transparent;border: solid antiquewhite thick;color: antiquewhite;">.antiqueWhite</td>
</td><td style="outline:solid antiquewhite 1px;border:solid antiquewhite thick;background-color: antiquewhite;color: black;">.onAntiqueWhite</td>
<td title="0x00FFFF" style="outline:solid aqua 1px;background:transparent;border: solid aqua thick;color: aqua;">.aqua</td>
</td><td style="outline:solid aqua 1px;border:solid aqua thick;background-color: aqua;color: black;">.onAqua</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x7FFFD4" style="outline:solid aquamarine 1px;background:transparent;border: solid aquamarine thick;color: aquamarine;">.aquamarine</td>
</td><td style="outline:solid aquamarine 1px;border:solid aquamarine thick;background-color: aquamarine;color: black;">.onAquamarine</td>   
<td title="0xF0FFFF" style="outline:solid azure 1px;background:transparent;border: solid azure thick;color: azure;">.azure</td>
</td><td style="outline:solid azure 1px;border:solid azure thick;background-color: azure;color: black;">.onAzure</td>
<td title="0xF5F5DC" style="outline:solid beige 1px;background:transparent;border: solid beige thick;color: beige;">.beige</td>
</td><td style="outline:solid beige 1px;border:solid beige thick;background-color: beige;color: black;">.onBeige</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFFE4C4" style="outline:solid bisque 1px;background:transparent;border: solid bisque thick;color: bisque;">.bisque</td>
</td><td style="outline:solid bisque 1px;border:solid bisque thick;background-color: bisque;color: black;">.onBisque</td>
<td title="0x000000" style="outline:solid black 1px;background:transparent;border: solid black thick;color: black;">.blackX11</td>
</td><td style="outline:solid black 1px;border:solid black thick;background-color: black;color: white;">.onBlackX11</td>
<td title="0xFFEBCD" style="outline:solid blanchedalmond 1px;background:transparent;border: solid blanchedalmond thick;color: blanchedalmond;">.blanchedAlmond</td>
</td><td style="outline:solid blanchedalmond 1px;border:solid blanchedalmond thick;background-color: blanchedalmond;color: black;">.onBlanchedAlmond</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x0000FF" style="outline:solid blue 1px;background:transparent;border: solid blue thick;color: blue;">.blueX11</td>
</td><td style="outline:solid blue 1px;border:solid blue thick;background-color: blue;color: black;">.onBlueX11</td>
<td title="0x8A2BE2" style="outline:solid blueviolet 1px;background:transparent;border: solid blueviolet thick;color: blueviolet;">.blueViolet</td>
</td><td style="outline:solid blueviolet 1px;border:solid blueviolet thick;background-color: blueviolet;color: black;">.onBlueViolet</td>   
<td title="0xA52A2A" style="outline:solid brown 1px;background:transparent;border: solid brown thick;color: brown;">.brown</td>
</td><td style="outline:solid brown 1px;border:solid brown thick;background-color: brown;color: black;">.onBrown</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xDEB887" style="outline:solid burlywood 1px;background:transparent;border: solid burlywood thick;color: burlywood;">.burlywood</td>
</td><td style="outline:solid burlywood 1px;border:solid burlywood thick;background-color: burlywood;color: black;">.onBurlywood</td>       
<td title="0x5F9EA0" style="outline:solid cadetblue 1px;background:transparent;border: solid cadetblue thick;color: cadetblue;">.cadetBlue</td>
</td><td style="outline:solid cadetblue 1px;border:solid cadetblue thick;background-color: cadetblue;color: black;">.onCadetBlue</td>       
<td title="0x7FFF00" style="outline:solid chartreuse 1px;background:transparent;border: solid chartreuse thick;color: chartreuse;">.chartreuse</td>
</td><td style="outline:solid chartreuse 1px;border:solid chartreuse thick;background-color: chartreuse;color: black;">.onChartreuse</td>   
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xD2691E" style="outline:solid chocolate 1px;background:transparent;border: solid chocolate thick;color: chocolate;">.chocolate</td>
</td><td style="outline:solid chocolate 1px;border:solid chocolate thick;background-color: chocolate;color: black;">.onChocolate</td>       
<td title="0xFF7F50" style="outline:solid coral 1px;background:transparent;border: solid coral thick;color: coral;">.coral</td>
</td><td style="outline:solid coral 1px;border:solid coral thick;background-color: coral;color: black;">.onCoral</td>
<td title="0x6495ED" style="outline:solid cornflowerblue 1px;background:transparent;border: solid cornflowerblue thick;color: cornflowerblue;">.cornflowerBlue</td>
</td><td style="outline:solid cornflowerblue 1px;border:solid cornflowerblue thick;background-color: cornflowerblue;color: black;">.onCornflowerBlue</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFFF8DC" style="outline:solid cornsilk 1px;background:transparent;border: solid cornsilk thick;color: cornsilk;">.cornsilk</td> 
</td><td style="outline:solid cornsilk 1px;border:solid cornsilk thick;background-color: cornsilk;color: black;">.onCornsilk</td>
<td title="0xDC143C" style="outline:solid crimson 1px;background:transparent;border: solid crimson thick;color: crimson;">.crimson</td>     
</td><td style="outline:solid crimson 1px;border:solid crimson thick;background-color: crimson;color: black;">.onCrimson</td>
<td title="0x00FFFF" style="outline:solid cyan 1px;background:transparent;border: solid cyan thick;color: cyan;">.cyanX11</td>
</td><td style="outline:solid cyan 1px;border:solid cyan thick;background-color: cyan;color: black;">.onCyanX11</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x00008B" style="outline:solid darkblue 1px;background:transparent;border: solid darkblue thick;color: darkblue;">.darkBlue</td> 
</td><td style="outline:solid darkblue 1px;border:solid darkblue thick;background-color: darkblue;color: black;">.onDarkBlue</td>
<td title="0x008B8B" style="outline:solid darkcyan 1px;background:transparent;border: solid darkcyan thick;color: darkcyan;">.darkCyan</td> 
</td><td style="outline:solid darkcyan 1px;border:solid darkcyan thick;background-color: darkcyan;color: black;">.onDarkCyan</td>
<td title="0xB8860B" style="outline:solid darkgoldenrod 1px;background:transparent;border: solid darkgoldenrod thick;color: darkgoldenrod;">.darkGoldenrod</td>
</td><td style="outline:solid darkgoldenrod 1px;border:solid darkgoldenrod thick;background-color: darkgoldenrod;color: black;">.onDarkGoldenrod</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xA9A9A9" style="outline:solid darkgray 1px;background:transparent;border: solid darkgray thick;color: darkgray;">.darkGray</td> 
</td><td style="outline:solid darkgray 1px;border:solid darkgray thick;background-color: darkgray;color: black;">.onDarkGray</td>
<td title="0x006400" style="outline:solid darkgreen 1px;background:transparent;border: solid darkgreen thick;color: darkgreen;">.darkGreen</td>
</td><td style="outline:solid darkgreen 1px;border:solid darkgreen thick;background-color: darkgreen;color: black;">.onDarkGreen</td>       
<td title="0xA9A9A9" style="outline:solid darkgrey 1px;background:transparent;border: solid darkgrey thick;color: darkgrey;">.darkGrey</td> 
</td><td style="outline:solid darkgrey 1px;border:solid darkgrey thick;background-color: darkgrey;color: black;">.onDarkGrey</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xBDB76B" style="outline:solid darkkhaki 1px;background:transparent;border: solid darkkhaki thick;color: darkkhaki;">.darkKhaki</td>
</td><td style="outline:solid darkkhaki 1px;border:solid darkkhaki thick;background-color: darkkhaki;color: black;">.onDarkKhaki</td>       
<td title="0x8B008B" style="outline:solid darkmagenta 1px;background:transparent;border: solid darkmagenta thick;color: darkmagenta;">.darkMagenta</td>
</td><td style="outline:solid darkmagenta 1px;border:solid darkmagenta thick;background-color: darkmagenta;color: black;">.onDarkMagenta</td>
<td title="0x556B2F" style="outline:solid darkolivegreen 1px;background:transparent;border: solid darkolivegreen thick;color: darkolivegreen;">.darkOliveGreen</td>
</td><td style="outline:solid darkolivegreen 1px;border:solid darkolivegreen thick;background-color: darkolivegreen;color: black;">.onDarkOliveGreen</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFF8C00" style="outline:solid darkorange 1px;background:transparent;border: solid darkorange thick;color: darkorange;">.darkOrange</td>
</td><td style="outline:solid darkorange 1px;border:solid darkorange thick;background-color: darkorange;color: black;">.onDarkOrange</td>   
<td title="0x9932CC" style="outline:solid darkorchid 1px;background:transparent;border: solid darkorchid thick;color: darkorchid;">.darkOrchid</td>
</td><td style="outline:solid darkorchid 1px;border:solid darkorchid thick;background-color: darkorchid;color: black;">.onDarkOrchid</td>   
<td title="0x8B0000" style="outline:solid darkred 1px;background:transparent;border: solid darkred thick;color: darkred;">.darkRed</td>     
</td><td style="outline:solid darkred 1px;border:solid darkred thick;background-color: darkred;color: black;">.onDarkRed</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xE9967A" style="outline:solid darksalmon 1px;background:transparent;border: solid darksalmon thick;color: darksalmon;">.darkSalmon</td>
</td><td style="outline:solid darksalmon 1px;border:solid darksalmon thick;background-color: darksalmon;color: black;">.onDarkSalmon</td>   
<td title="0x8FBC8F" style="outline:solid darkseagreen 1px;background:transparent;border: solid darkseagreen thick;color: darkseagreen;">.darkSeaGreen</td>
</td><td style="outline:solid darkseagreen 1px;border:solid darkseagreen thick;background-color: darkseagreen;color: black;">.onDarkSeaGreen</td>
<td title="0x483D8B" style="outline:solid darkslateblue 1px;background:transparent;border: solid darkslateblue thick;color: darkslateblue;">.darkSlateBlue</td>
</td><td style="outline:solid darkslateblue 1px;border:solid darkslateblue thick;background-color: darkslateblue;color: black;">.onDarkSlateBlue</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x2F4F4F" style="outline:solid darkslategray 1px;background:transparent;border: solid darkslategray thick;color: darkslategray;">.darkSlateGray</td>
</td><td style="outline:solid darkslategray 1px;border:solid darkslategray thick;background-color: darkslategray;color: black;">.onDarkSlateGray</td>
<td title="0x2F4F4F" style="outline:solid darkslategrey 1px;background:transparent;border: solid darkslategrey thick;color: darkslategrey;">.darkSlateGrey</td>
</td><td style="outline:solid darkslategrey 1px;border:solid darkslategrey thick;background-color: darkslategrey;color: black;">.onDarkSlateGrey</td>
<td title="0x00CED1" style="outline:solid darkturquoise 1px;background:transparent;border: solid darkturquoise thick;color: darkturquoise;">.darkTurquoise</td>
</td><td style="outline:solid darkturquoise 1px;border:solid darkturquoise thick;background-color: darkturquoise;color: black;">.onDarkTurquoise</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x9400D3" style="outline:solid darkviolet 1px;background:transparent;border: solid darkviolet thick;color: darkviolet;">.darkViolet</td>
</td><td style="outline:solid darkviolet 1px;border:solid darkviolet thick;background-color: darkviolet;color: black;">.onDarkViolet</td>   
<td title="0xFF1493" style="outline:solid deeppink 1px;background:transparent;border: solid deeppink thick;color: deeppink;">.deepPink</td> 
</td><td style="outline:solid deeppink 1px;border:solid deeppink thick;background-color: deeppink;color: black;">.onDeepPink</td>
<td title="0x00BFFF" style="outline:solid deepskyblue 1px;background:transparent;border: solid deepskyblue thick;color: deepskyblue;">.deepSkyBlue</td>
</td><td style="outline:solid deepskyblue 1px;border:solid deepskyblue thick;background-color: deepskyblue;color: black;">.onDeepSkyBlue</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x696969" style="outline:solid dimgray 1px;background:transparent;border: solid dimgray thick;color: dimgray;">.dimGray</td>     
</td><td style="outline:solid dimgray 1px;border:solid dimgray thick;background-color: dimgray;color: black;">.onDimGray</td>
<td title="0x696969" style="outline:solid dimgrey 1px;background:transparent;border: solid dimgrey thick;color: dimgrey;">.dimGrey</td>     
</td><td style="outline:solid dimgrey 1px;border:solid dimgrey thick;background-color: dimgrey;color: black;">.onDimGrey</td>
<td title="0x1E90FF" style="outline:solid dodgerblue 1px;background:transparent;border: solid dodgerblue thick;color: dodgerblue;">.dodgerBlue</td>
</td><td style="outline:solid dodgerblue 1px;border:solid dodgerblue thick;background-color: dodgerblue;color: black;">.onDodgerBlue</td>   
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xB22222" style="outline:solid firebrick 1px;background:transparent;border: solid firebrick thick;color: firebrick;">.fireBrick</td>
</td><td style="outline:solid firebrick 1px;border:solid firebrick thick;background-color: firebrick;color: black;">.onFireBrick</td>       
<td title="0xFFFAF0" style="outline:solid floralwhite 1px;background:transparent;border: solid floralwhite thick;color: floralwhite;">.floralWhite</td>
</td><td style="outline:solid floralwhite 1px;border:solid floralwhite thick;background-color: floralwhite;color: black;">.onFloralWhite</td>
<td title="0x228B22" style="outline:solid forestgreen 1px;background:transparent;border: solid forestgreen thick;color: forestgreen;">.forestGreen</td>
</td><td style="outline:solid forestgreen 1px;border:solid forestgreen thick;background-color: forestgreen;color: black;">.onForestGreen</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFF00FF" style="outline:solid fuchsia 1px;background:transparent;border: solid fuchsia thick;color: fuchsia;">.fuchsia</td>     
</td><td style="outline:solid fuchsia 1px;border:solid fuchsia thick;background-color: fuchsia;color: black;">.onFuchsia</td>
<td title="0xDCDCDC" style="outline:solid gainsboro 1px;background:transparent;border: solid gainsboro thick;color: gainsboro;">.gainsboro</td>
</td><td style="outline:solid gainsboro 1px;border:solid gainsboro thick;background-color: gainsboro;color: black;">.onGainsboro</td>       
<td title="0xF8F8FF" style="outline:solid ghostwhite 1px;background:transparent;border: solid ghostwhite thick;color: ghostwhite;">.ghostWhite</td>
</td><td style="outline:solid ghostwhite 1px;border:solid ghostwhite thick;background-color: ghostwhite;color: black;">.onGhostWhite</td>   
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFFD700" style="outline:solid gold 1px;background:transparent;border: solid gold thick;color: gold;">.gold</td>
</td><td style="outline:solid gold 1px;border:solid gold thick;background-color: gold;color: black;">.onGold</td>
<td title="0xDAA520" style="outline:solid goldenrod 1px;background:transparent;border: solid goldenrod thick;color: goldenrod;">.goldenrod</td>
</td><td style="outline:solid goldenrod 1px;border:solid goldenrod thick;background-color: goldenrod;color: black;">.onGoldenrod</td>       
<td title="0x808080" style="outline:solid gray 1px;background:transparent;border: solid gray thick;color: gray;">.grayX11</td>
</td><td style="outline:solid gray 1px;border:solid gray thick;background-color: gray;color: black;">.onGrayX11</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x008000" style="outline:solid green 1px;background:transparent;border: solid green thick;color: green;">.greenX11</td>
</td><td style="outline:solid green 1px;border:solid green thick;background-color: green;color: black;">.onGreenX11</td>
<td title="0xADFF2F" style="outline:solid greenyellow 1px;background:transparent;border: solid greenyellow thick;color: greenyellow;">.greenYellow</td>
</td><td style="outline:solid greenyellow 1px;border:solid greenyellow thick;background-color: greenyellow;color: black;">.onGreenYellow</td>
<td title="0x808080" style="outline:solid grey 1px;background:transparent;border: solid grey thick;color: grey;">.greyX11</td>
</td><td style="outline:solid grey 1px;border:solid grey thick;background-color: grey;color: black;">.onGreyX11</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xF0FFF0" style="outline:solid honeydew 1px;background:transparent;border: solid honeydew thick;color: honeydew;">.honeydew</td> 
</td><td style="outline:solid honeydew 1px;border:solid honeydew thick;background-color: honeydew;color: black;">.onHoneydew</td>
<td title="0xFF69B4" style="outline:solid hotpink 1px;background:transparent;border: solid hotpink thick;color: hotpink;">.hotPink</td>     
</td><td style="outline:solid hotpink 1px;border:solid hotpink thick;background-color: hotpink;color: black;">.onHotPink</td>
<td title="0xCD5C5C" style="outline:solid indianred 1px;background:transparent;border: solid indianred thick;color: indianred;">.indianRed</td>
</td><td style="outline:solid indianred 1px;border:solid indianred thick;background-color: indianred;color: black;">.onIndianRed</td>       
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x4B0082" style="outline:solid indigo 1px;background:transparent;border: solid indigo thick;color: indigo;">.indigo</td>
</td><td style="outline:solid indigo 1px;border:solid indigo thick;background-color: indigo;color: black;">.onIndigo</td>
<td title="0xFFFFF0" style="outline:solid ivory 1px;background:transparent;border: solid ivory thick;color: ivory;">.ivory</td>
</td><td style="outline:solid ivory 1px;border:solid ivory thick;background-color: ivory;color: black;">.onIvory</td>
<td title="0xF0E68C" style="outline:solid khaki 1px;background:transparent;border: solid khaki thick;color: khaki;">.khaki</td>
</td><td style="outline:solid khaki 1px;border:solid khaki thick;background-color: khaki;color: black;">.onKhaki</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xE6E6FA" style="outline:solid lavender 1px;background:transparent;border: solid lavender thick;color: lavender;">.lavender</td> 
</td><td style="outline:solid lavender 1px;border:solid lavender thick;background-color: lavender;color: black;">.onLavender</td>
<td title="0xFFF0F5" style="outline:solid lavenderblush 1px;background:transparent;border: solid lavenderblush thick;color: lavenderblush;">.lavenderBlush</td>
</td><td style="outline:solid lavenderblush 1px;border:solid lavenderblush thick;background-color: lavenderblush;color: black;">.onLavenderBlush</td>
<td title="0x7CFC00" style="outline:solid lawngreen 1px;background:transparent;border: solid lawngreen thick;color: lawngreen;">.lawnGreen</td>
</td><td style="outline:solid lawngreen 1px;border:solid lawngreen thick;background-color: lawngreen;color: black;">.onLawnGreen</td>       
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFFFACD" style="outline:solid lemonchiffon 1px;background:transparent;border: solid lemonchiffon thick;color: lemonchiffon;">.lemonChiffon</td>
</td><td style="outline:solid lemonchiffon 1px;border:solid lemonchiffon thick;background-color: lemonchiffon;color: black;">.onLemonChiffon</td>
<td title="0xADD8E6" style="outline:solid lightblue 1px;background:transparent;border: solid lightblue thick;color: lightblue;">.lightBlue</td>
</td><td style="outline:solid lightblue 1px;border:solid lightblue thick;background-color: lightblue;color: black;">.onLightBlue</td>       
<td title="0xF08080" style="outline:solid lightcoral 1px;background:transparent;border: solid lightcoral thick;color: lightcoral;">.lightCoral</td>
</td><td style="outline:solid lightcoral 1px;border:solid lightcoral thick;background-color: lightcoral;color: black;">.onLightCoral</td>   
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xE0FFFF" style="outline:solid lightcyan 1px;background:transparent;border: solid lightcyan thick;color: lightcyan;">.lightCyan</td>
</td><td style="outline:solid lightcyan 1px;border:solid lightcyan thick;background-color: lightcyan;color: black;">.onLightCyan</td>       
<td title="0xFAFAD2" style="outline:solid lightgoldenrodyellow 1px;background:transparent;border: solid lightgoldenrodyellow thick;color: lightgoldenrodyellow;">.lightGoldenrodYellow</td>
</td><td style="outline:solid lightgoldenrodyellow 1px;border:solid lightgoldenrodyellow thick;background-color: lightgoldenrodyellow;color: black;">.onLightGoldenrodYellow</td>
<td title="0xFAFAD2" style="outline:solid rgb(250, 250, 210) 1px;background:transparent;border: solid rgb(250, 250, 210) thick;color: rgb(250, 250, 210);">.lightGoldenrod</td>
</td><td style="outline:solid rgb(250, 250, 210) 1px;border:solid rgb(250, 250, 210) thick;background-color: rgb(250, 250, 210);color: black;">.onLightGoldenrod</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xD3D3D3" style="outline:solid lightgray 1px;background:transparent;border: solid lightgray thick;color: lightgray;">.lightGray</td>
</td><td style="outline:solid lightgray 1px;border:solid lightgray thick;background-color: lightgray;color: black;">.onLightGray</td>       
<td title="0x90EE90" style="outline:solid lightgreen 1px;background:transparent;border: solid lightgreen thick;color: lightgreen;">.lightGreen</td>
</td><td style="outline:solid lightgreen 1px;border:solid lightgreen thick;background-color: lightgreen;color: black;">.onLightGreen</td>   
<td title="0xD3D3D3" style="outline:solid lightgrey 1px;background:transparent;border: solid lightgrey thick;color: lightgrey;">.lightGrey</td>
</td><td style="outline:solid lightgrey 1px;border:solid lightgrey thick;background-color: lightgrey;color: black;">.onLightGrey</td>       
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFFB6C1" style="outline:solid lightpink 1px;background:transparent;border: solid lightpink thick;color: lightpink;">.lightPink</td>
</td><td style="outline:solid lightpink 1px;border:solid lightpink thick;background-color: lightpink;color: black;">.onLightPink</td>       
<td title="0xFFA07A" style="outline:solid lightsalmon 1px;background:transparent;border: solid lightsalmon thick;color: lightsalmon;">.lightSalmon</td>
</td><td style="outline:solid lightsalmon 1px;border:solid lightsalmon thick;background-color: lightsalmon;color: black;">.onLightSalmon</td>
<td title="0x20B2AA" style="outline:solid lightseagreen 1px;background:transparent;border: solid lightseagreen thick;color: lightseagreen;">.lightSeaGreen</td>
</td><td style="outline:solid lightseagreen 1px;border:solid lightseagreen thick;background-color: lightseagreen;color: black;">.onLightSeaGreen</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x87CEFA" style="outline:solid lightskyblue 1px;background:transparent;border: solid lightskyblue thick;color: lightskyblue;">.lightSkyBlue</td>
</td><td style="outline:solid lightskyblue 1px;border:solid lightskyblue thick;background-color: lightskyblue;color: black;">.onLightSkyBlue</td>
<td title="0x778899" style="outline:solid lightslategray 1px;background:transparent;border: solid lightslategray thick;color: lightslategray;">.lightSlateGray</td>
</td><td style="outline:solid lightslategray 1px;border:solid lightslategray thick;background-color: lightslategray;color: black;">.onLightSlateGray</td>
<td title="0x778899" style="outline:solid lightslategrey 1px;background:transparent;border: solid lightslategrey thick;color: lightslategrey;">.lightSlateGrey</td>
</td><td style="outline:solid lightslategrey 1px;border:solid lightslategrey thick;background-color: lightslategrey;color: black;">.onLightSlateGrey</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xB0C4DE" style="outline:solid lightsteelblue 1px;background:transparent;border: solid lightsteelblue thick;color: lightsteelblue;">.lightSteelBlue</td>
</td><td style="outline:solid lightsteelblue 1px;border:solid lightsteelblue thick;background-color: lightsteelblue;color: black;">.onLightSteelBlue</td>
<td title="0xFFFFE0" style="outline:solid lightyellow 1px;background:transparent;border: solid lightyellow thick;color: lightyellow;">.lightYellow</td>
</td><td style="outline:solid lightyellow 1px;border:solid lightyellow thick;background-color: lightyellow;color: black;">.onLightYellow</td>
<td title="0x00FF00" style="outline:solid lime 1px;background:transparent;border: solid lime thick;color: lime;">.lime</td>
</td><td style="outline:solid lime 1px;border:solid lime thick;background-color: lime;color: black;">.onLime</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x32CD32" style="outline:solid limegreen 1px;background:transparent;border: solid limegreen thick;color: limegreen;">.limeGreen</td>
</td><td style="outline:solid limegreen 1px;border:solid limegreen thick;background-color: limegreen;color: black;">.onLimeGreen</td>       
<td title="0xFAF0E6" style="outline:solid linen 1px;background:transparent;border: solid linen thick;color: linen;">.linen</td>
</td><td style="outline:solid linen 1px;border:solid linen thick;background-color: linen;color: black;">.onLinen</td>
<td title="0xFF00FF" style="outline:solid magenta 1px;background:transparent;border: solid magenta thick;color: magenta;">.magentaX11</td>  
</td><td style="outline:solid magenta 1px;border:solid magenta thick;background-color: magenta;color: black;">.onMagentaX11</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x800000" style="outline:solid maroon 1px;background:transparent;border: solid maroon thick;color: maroon;">.maroon</td>
</td><td style="outline:solid maroon 1px;border:solid maroon thick;background-color: maroon;color: black;">.onMaroon</td>
<td title="0x66CDAA" style="outline:solid mediumaquamarine 1px;background:transparent;border: solid mediumaquamarine thick;color: mediumaquamarine;">.mediumAquamarine</td>
</td><td style="outline:solid mediumaquamarine 1px;border:solid mediumaquamarine thick;background-color: mediumaquamarine;color: black;">.onMediumAquamarine</td>
<td title="0x0000CD" style="outline:solid mediumblue 1px;background:transparent;border: solid mediumblue thick;color: mediumblue;">.mediumBlue</td>
</td><td style="outline:solid mediumblue 1px;border:solid mediumblue thick;background-color: mediumblue;color: black;">.onMediumBlue</td>   
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xBA55D3" style="outline:solid mediumorchid 1px;background:transparent;border: solid mediumorchid thick;color: mediumorchid;">.mediumOrchid</td>
</td><td style="outline:solid mediumorchid 1px;border:solid mediumorchid thick;background-color: mediumorchid;color: black;">.onMediumOrchid</td>
<td title="0x9370DB" style="outline:solid mediumpurple 1px;background:transparent;border: solid mediumpurple thick;color: mediumpurple;">.mediumPurple</td>
</td><td style="outline:solid mediumpurple 1px;border:solid mediumpurple thick;background-color: mediumpurple;color: black;">.onMediumPurple</td>
<td title="0x3CB371" style="outline:solid mediumseagreen 1px;background:transparent;border: solid mediumseagreen thick;color: mediumseagreen;">.mediumSeaGreen</td>
</td><td style="outline:solid mediumseagreen 1px;border:solid mediumseagreen thick;background-color: mediumseagreen;color: black;">.onMediumSeaGreen</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x7B68EE" style="outline:solid mediumslateblue 1px;background:transparent;border: solid mediumslateblue thick;color: mediumslateblue;">.mediumSlateBlue</td>
</td><td style="outline:solid mediumslateblue 1px;border:solid mediumslateblue thick;background-color: mediumslateblue;color: black;">.onMediumSlateBlue</td>
<td title="0x00FA9A" style="outline:solid mediumspringgreen 1px;background:transparent;border: solid mediumspringgreen thick;color: mediumspringgreen;">.mediumSpringGreen</td>
</td><td style="outline:solid mediumspringgreen 1px;border:solid mediumspringgreen thick;background-color: mediumspringgreen;color: black;">.onMediumSpringGreen</td>
<td title="0x48D1CC" style="outline:solid mediumturquoise 1px;background:transparent;border: solid mediumturquoise thick;color: mediumturquoise;">.mediumTurquoise</td>
</td><td style="outline:solid mediumturquoise 1px;border:solid mediumturquoise thick;background-color: mediumturquoise;color: black;">.onMediumTurquoise</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xC71585" style="outline:solid mediumvioletred 1px;background:transparent;border: solid mediumvioletred thick;color: mediumvioletred;">.mediumVioletRed</td>
</td><td style="outline:solid mediumvioletred 1px;border:solid mediumvioletred thick;background-color: mediumvioletred;color: black;">.onMediumVioletRed</td>
<td title="0x191970" style="outline:solid midnightblue 1px;background:transparent;border: solid midnightblue thick;color: midnightblue;">.midnightBlue</td>
</td><td style="outline:solid midnightblue 1px;border:solid midnightblue thick;background-color: midnightblue;color: black;">.onMidnightBlue</td>
<td title="0xF5FFFA" style="outline:solid mintcream 1px;background:transparent;border: solid mintcream thick;color: mintcream;">.mintCream</td>
</td><td style="outline:solid mintcream 1px;border:solid mintcream thick;background-color: mintcream;color: black;">.onMintCream</td>       
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFFE4E1" style="outline:solid mistyrose 1px;background:transparent;border: solid mistyrose thick;color: mistyrose;">.mistyRose</td>
</td><td style="outline:solid mistyrose 1px;border:solid mistyrose thick;background-color: mistyrose;color: black;">.onMistyRose</td>       
<td title="0xFFE4B5" style="outline:solid moccasin 1px;background:transparent;border: solid moccasin thick;color: moccasin;">.moccasin</td> 
</td><td style="outline:solid moccasin 1px;border:solid moccasin thick;background-color: moccasin;color: black;">.onMoccasin</td>
<td title="0xFFDEAD" style="outline:solid navajowhite 1px;background:transparent;border: solid navajowhite thick;color: navajowhite;">.navajoWhite</td>
</td><td style="outline:solid navajowhite 1px;border:solid navajowhite thick;background-color: navajowhite;color: black;">.onNavajoWhite</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x000080" style="outline:solid navy 1px;background:transparent;border: solid navy thick;color: navy;">.navy</td>
</td><td style="outline:solid navy 1px;border:solid navy thick;background-color: navy;color: black;">.onNavy</td>
<td title="0xFDF5E6" style="outline:solid oldlace 1px;background:transparent;border: solid oldlace thick;color: oldlace;">.oldLace</td>     
</td><td style="outline:solid oldlace 1px;border:solid oldlace thick;background-color: oldlace;color: black;">.onOldLace</td>
<td title="0x808000" style="outline:solid olive 1px;background:transparent;border: solid olive thick;color: olive;">.olive</td>
</td><td style="outline:solid olive 1px;border:solid olive thick;background-color: olive;color: black;">.onOlive</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x6B8E23" style="outline:solid olivedrab 1px;background:transparent;border: solid olivedrab thick;color: olivedrab;">.oliveDrab</td>
</td><td style="outline:solid olivedrab 1px;border:solid olivedrab thick;background-color: olivedrab;color: black;">.onOliveDrab</td>       
<td title="0xFFA500" style="outline:solid orange 1px;background:transparent;border: solid orange thick;color: orange;">.orange</td>
</td><td style="outline:solid orange 1px;border:solid orange thick;background-color: orange;color: black;">.onOrange</td>
<td title="0xFF4500" style="outline:solid orangered 1px;background:transparent;border: solid orangered thick;color: orangered;">.orangeRed</td>
</td><td style="outline:solid orangered 1px;border:solid orangered thick;background-color: orangered;color: black;">.onOrangeRed</td>       
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xDA70D6" style="outline:solid orchid 1px;background:transparent;border: solid orchid thick;color: orchid;">.orchid</td>
</td><td style="outline:solid orchid 1px;border:solid orchid thick;background-color: orchid;color: black;">.onOrchid</td>
<td title="0xEEE8AA" style="outline:solid palegoldenrod 1px;background:transparent;border: solid palegoldenrod thick;color: palegoldenrod;">.paleGoldenrod</td>
</td><td style="outline:solid palegoldenrod 1px;border:solid palegoldenrod thick;background-color: palegoldenrod;color: black;">.onPaleGoldenrod</td>
<td title="0x98FB98" style="outline:solid palegreen 1px;background:transparent;border: solid palegreen thick;color: palegreen;">.paleGreen</td>
</td><td style="outline:solid palegreen 1px;border:solid palegreen thick;background-color: palegreen;color: black;">.onPaleGreen</td>       
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xAFEEEE" style="outline:solid paleturquoise 1px;background:transparent;border: solid paleturquoise thick;color: paleturquoise;">.paleTurquoise</td>
</td><td style="outline:solid paleturquoise 1px;border:solid paleturquoise thick;background-color: paleturquoise;color: black;">.onPaleTurquoise</td>
<td title="0xDB7093" style="outline:solid palevioletred 1px;background:transparent;border: solid palevioletred thick;color: palevioletred;">.paleVioletRed</td>
</td><td style="outline:solid palevioletred 1px;border:solid palevioletred thick;background-color: palevioletred;color: black;">.onPaleVioletRed</td>
<td title="0xFFEFD5" style="outline:solid papayawhip 1px;background:transparent;border: solid papayawhip thick;color: papayawhip;">.papayaWhip</td>
</td><td style="outline:solid papayawhip 1px;border:solid papayawhip thick;background-color: papayawhip;color: black;">.onPapayaWhip</td>   
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFFDAB9" style="outline:solid peachpuff 1px;background:transparent;border: solid peachpuff thick;color: peachpuff;">.peachPuff</td>
</td><td style="outline:solid peachpuff 1px;border:solid peachpuff thick;background-color: peachpuff;color: black;">.onPeachPuff</td>       
<td title="0xCD853F" style="outline:solid peru 1px;background:transparent;border: solid peru thick;color: peru;">.peru</td>
</td><td style="outline:solid peru 1px;border:solid peru thick;background-color: peru;color: black;">.onPeru</td>
<td title="0xFFC0CB" style="outline:solid pink 1px;background:transparent;border: solid pink thick;color: pink;">.pink</td>
</td><td style="outline:solid pink 1px;border:solid pink thick;background-color: pink;color: black;">.onPink</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xDDA0DD" style="outline:solid plum 1px;background:transparent;border: solid plum thick;color: plum;">.plum</td>
</td><td style="outline:solid plum 1px;border:solid plum thick;background-color: plum;color: black;">.onPlum</td>
<td title="0xB0E0E6" style="outline:solid powderblue 1px;background:transparent;border: solid powderblue thick;color: powderblue;">.powderBlue</td>
</td><td style="outline:solid powderblue 1px;border:solid powderblue thick;background-color: powderblue;color: black;">.onPowderBlue</td>   
<td title="0x800080" style="outline:solid purple 1px;background:transparent;border: solid purple thick;color: purple;">.purple</td>
</td><td style="outline:solid purple 1px;border:solid purple thick;background-color: purple;color: black;">.onPurple</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x663399" style="outline:solid rgb(102, 51, 153) 1px;background:transparent;border: solid rgb(102, 51, 153) thick;color: rgb(102, 51, 153);">.rebeccaPurple</td>
</td><td style="outline:solid rgb(102, 51, 153) 1px;border:solid rgb(102, 51, 153) thick;background-color: rgb(102, 51, 153);color: black;">.onRebeccaPurple</td>
<td title="0xFF0000" style="outline:solid red 1px;background:transparent;border: solid red thick;color: red;">.RedX11</td>
</td><td style="outline:solid red 1px;border:solid red thick;background-color: red;color: black;">.onRedX11</td>
<td title="0xBC8F8F" style="outline:solid rosybrown 1px;background:transparent;border: solid rosybrown thick;color: rosybrown;">.rosyBrown</td>
</td><td style="outline:solid rosybrown 1px;border:solid rosybrown thick;background-color: rosybrown;color: black;">.onRosyBrown</td>       
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x4169E1" style="outline:solid royalblue 1px;background:transparent;border: solid royalblue thick;color: royalblue;">.royalBlue</td>
</td><td style="outline:solid royalblue 1px;border:solid royalblue thick;background-color: royalblue;color: black;">.onRoyalBlue</td>       
<td title="0x8B4513" style="outline:solid saddlebrown 1px;background:transparent;border: solid saddlebrown thick;color: saddlebrown;">.saddleBrown</td>
</td><td style="outline:solid saddlebrown 1px;border:solid saddlebrown thick;background-color: saddlebrown;color: black;">.onSaddleBrown</td>
<td title="0xFA8072" style="outline:solid salmon 1px;background:transparent;border: solid salmon thick;color: salmon;">.salmon</td>
</td><td style="outline:solid salmon 1px;border:solid salmon thick;background-color: salmon;color: black;">.onSalmon</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xF4A460" style="outline:solid sandybrown 1px;background:transparent;border: solid sandybrown thick;color: sandybrown;">.sandyBrown</td>
</td><td style="outline:solid sandybrown 1px;border:solid sandybrown thick;background-color: sandybrown;color: black;">.onSandyBrown</td>   
<td title="0x2E8B57" style="outline:solid seagreen 1px;background:transparent;border: solid seagreen thick;color: seagreen;">.seaGreen</td> 
</td><td style="outline:solid seagreen 1px;border:solid seagreen thick;background-color: seagreen;color: black;">.onSeaGreen</td>
<td title="0xFFF5EE" style="outline:solid seashell 1px;background:transparent;border: solid seashell thick;color: seashell;">.seashell</td> 
</td><td style="outline:solid seashell 1px;border:solid seashell thick;background-color: seashell;color: black;">.onSeashell</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xA0522D" style="outline:solid sienna 1px;background:transparent;border: solid sienna thick;color: sienna;">.sienna</td>
</td><td style="outline:solid sienna 1px;border:solid sienna thick;background-color: sienna;color: black;">.onSienna</td>
<td title="0xC0C0C0" style="outline:solid silver 1px;background:transparent;border: solid silver thick;color: silver;">.silver</td>
</td><td style="outline:solid silver 1px;border:solid silver thick;background-color: silver;color: black;">.onSilver</td>
<td title="0x87CEEB" style="outline:solid skyblue 1px;background:transparent;border: solid skyblue thick;color: skyblue;">.skyBlue</td>     
</td><td style="outline:solid skyblue 1px;border:solid skyblue thick;background-color: skyblue;color: black;">.onSkyBlue</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0x6A5ACD" style="outline:solid slateblue 1px;background:transparent;border: solid slateblue thick;color: slateblue;">.slateBlue</td>
</td><td style="outline:solid slateblue 1px;border:solid slateblue thick;background-color: slateblue;color: black;">.onSlateBlue</td>       
<td title="0x708090" style="outline:solid slategray 1px;background:transparent;border: solid slategray thick;color: slategray;">.slateGray</td>
</td><td style="outline:solid slategray 1px;border:solid slategray thick;background-color: slategray;color: black;">.onSlateGray</td>       
<td title="0x708090" style="outline:solid slategrey 1px;background:transparent;border: solid slategrey thick;color: slategrey;">.slateGrey</td>
</td><td style="outline:solid slategrey 1px;border:solid slategrey thick;background-color: slategrey;color: black;">.onSlateGrey</td>       
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFFFAFA" style="outline:solid snow 1px;background:transparent;border: solid snow thick;color: snow;">.snow</td>
</td><td style="outline:solid snow 1px;border:solid snow thick;background-color: snow;color: black;">.onSnow</td>
<td title="0x00FF7F" style="outline:solid springgreen 1px;background:transparent;border: solid springgreen thick;color: springgreen;">.springGreen</td>
</td><td style="outline:solid springgreen 1px;border:solid springgreen thick;background-color: springgreen;color: black;">.onSpringGreen</td>
<td title="0x4682B4" style="outline:solid steelblue 1px;background:transparent;border: solid steelblue thick;color: steelblue;">.steelBlue</td>
</td><td style="outline:solid steelblue 1px;border:solid steelblue thick;background-color: steelblue;color: black;">.onSteelBlue</td>       
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xD2B48C" style="outline:solid tan 1px;background:transparent;border: solid tan thick;color: tan;">.tan</td>
</td><td style="outline:solid tan 1px;border:solid tan thick;background-color: tan;color: black;">.onTan</td>
<td title="0x008080" style="outline:solid teal 1px;background:transparent;border: solid teal thick;color: teal;">.teal</td>
</td><td style="outline:solid teal 1px;border:solid teal thick;background-color: teal;color: black;">.onTeal</td>
<td title="0xD8BFD8" style="outline:solid thistle 1px;background:transparent;border: solid thistle thick;color: thistle;">.thistle</td>     
</td><td style="outline:solid thistle 1px;border:solid thistle thick;background-color: thistle;color: black;">.onThistle</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFF6347" style="outline:solid tomato 1px;background:transparent;border: solid tomato thick;color: tomato;">.tomato</td>
</td><td style="outline:solid tomato 1px;border:solid tomato thick;background-color: tomato;color: black;">.onTomato</td>
<td title="0x40E0D0" style="outline:solid turquoise 1px;background:transparent;border: solid turquoise thick;color: turquoise;">.turquoise</td>
</td><td style="outline:solid turquoise 1px;border:solid turquoise thick;background-color: turquoise;color: black;">.onTurquoise</td>       
<td title="0xEE82EE" style="outline:solid violet 1px;background:transparent;border: solid violet thick;color: violet;">.violet</td>
</td><td style="outline:solid violet 1px;border:solid violet thick;background-color: violet;color: black;">.onViolet</td>
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xF5DEB3" style="outline:solid wheat 1px;background:transparent;border: solid wheat thick;color: wheat;">.wheat</td>
</td><td style="outline:solid wheat 1px;border:solid wheat thick;background-color: wheat;color: black;">.onWheat</td>
<td title="0xFFFFFF" style="outline:solid white 1px;background:black;border: solid white thick;color: white;">.whiteX11</td>
</td><td style="outline:solid white 1px;border:solid white thick;background-color: white;color: black;">.onWhiteX11</td>
<td title="0xF5F5F5" style="outline:solid whitesmoke 1px;background:transparent;border: solid whitesmoke thick;color: whitesmoke;">.whiteSmoke</td>
</td><td style="outline:solid whitesmoke 1px;border:solid whitesmoke thick;background-color: whitesmoke;color: black;">.onWhiteSmoke</td>   
<tr>
<tr style="border: grey solid 2px;outline:none;">
<td title="0xFFFF00" style="outline:solid yellow 1px;background:transparent;border: solid yellow thick;color: yellow;">.yellowX11</td>      
</td><td style="outline:solid yellow 1px;border:solid yellow thick;background-color: yellow;color: black;">.onYellowX11</td>
<td title="0x9ACD32" style="outline:solid yellowgreen 1px;background:transparent;border: solid yellowgreen thick;color: yellowgreen;">.yellowGreen</td>
</td><td style="outline:solid yellowgreen 1px;border:solid yellowgreen thick;background-color: yellowgreen;color: black;">.onYellowGreen</td>
<td></td><td></td>
<tr>
</tbody></table>


## Browser support

Chrome, Firefox and Edge natively support ANSI escape codes in their respective developer consoles.

## Windows

If you're on Windows, do yourself a favor and use [Windows Terminal](https://github.com/microsoft/terminal) instead of `cmd.exe`.


## Related

- [chalk-js](https://github.com/chalk/chalk) - The original Chalk library module for javascript
  
## Author/Maintainer

- [Tim Maffett](https://github.com/timmaffett)
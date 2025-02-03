import 'package:chalkdart/chalkstrings.dart';
import 'package:chalkdart/chalkstrings_x11.dart';

void main() {
  print("            Chalk'Dart example program           "
      .cornflowerBlue
      .onBisque);

  print(
      'SGR (Select Graphic Rendition) parameters test (see https://en.wikipedia.org/wiki/ANSI_escape_code#SGR )');
  print('Testing Chalk`Dart!!!  red'.red);
  print(
      'Testing Chalk`Dart!!! DIM DIM red'.red.dim + ' then back to blue'.blue);

  // Nest styles
  print(('Hello' + 'world'.underline.bgBlue + '!').red);

  // Nest styles of the same type even (color, underline, background)
  print(('I am a green line ' +
          'with a blue substring'.blue.underline.bold +
          ' that becomes green again!')
      .green);

  print('Testing Chalk`Dart!!! DIM blue'.blue.dim + ' then back to blue'.blue);

  print('Testing Chalk`Dart!!! DIM yellow'.yellow.dim +
      ' then back to yellow'.yellow);
  print('Testing Chalk`Dart!!! DIM green'.green.dim +
      ' then back to green'.green);
  print('Testing Chalk`Dart!!! DIM bright green'.brightGreen.dim +
      ' then back to bright green'.brightGreen);

  print('Testing Chalk`Dart!!! BLINK yellow'.yellow.blink);
  print('Testing Chalk`Dart!!! FASTBLINK  blue'.blue.rapidblink);
  print('Testing Chalk`Dart!!! ITALIC  blue bgGreen'.blue.bgGreen.italic);
  print('Testing Chalk`Dart!!!  blueBright.onBlue'.blueBright.onBlue);
  print(('Testing Chalk`Dart!!! ' +
          'THIS IS INVERTED COLOR'.inverse +
          ' of magenta.onGrey')
      .magenta
      .onGrey);
  print(('Testing Chalk`Dart!!! ' +
          'THIS IS (${'(THIS IS NESTED INVERTED COLOR)'.inverse})  INVERTED COLOR'
              .inverse +
          ' of white.onGrey')
      .white
      .onGrey);

  // make a chalk that will join wrap print with newline
  var chalkNL = chalk.wrap('\n', '');

  print('Testing Chalk`Dart!!!  onGreenBright.redBright.strikethrough'
      .onBrightGreen
      .redBright
      .strikethrough);
  print('Testing Chalk`Dart!!! OVERLINE red.onCyan'.red.onCyan.overline);

  print('Testing Chalk`Dart!!! blueBright.onGreen'.blueBright.onGreen);
  print('Testing Chalk`Dart!!! blue.x11.onDarkSalmon'.blue.onDarkSalmon);
  print('Testing Chalk`Dart!!! .bgBrightYellow.blue'.bgYellowBright.blue);
  print('Testing Chalk`Dart!!! yellow.onBlack'.yellow.onBlack);
  print('rgb(244,232,122).onBlack !!!'.rgb(244, 232, 122).onBlack);

  print('Testing Chalk`Dart!!! blue WITH Red underline'
      .blue
      .underlineRgb(255, 0, 0)
      .underline);
  print('Testing Chalk`Dart!!! yellow WITH Green underline'
      .yellow
      .underlineRgb16m(0, 255, 0)
      .underline);

  print('Testing Chalk`Dart!!! yellow WITH blue strikethrough'
      .yellow
      .underlineRgb16m(0, 0, 255)
      .strikethrough);

  print(
      'Testing Chalk`Dart!!! yellow WITH magenta overline underline AND strikethrough\n'
          .yellow
          .underlineRgb16m(255, 0, 255)
          .underline
          .overline
          .strikethrough);

  print('Testing Chalk`Dart With - This is #1!!! DIM blue'.slateBlue.onWhite +
      ' and this is the return from #2 then back to blue'.white.onPurple);

  // test adding strings and reset
  print(('I am a green line ' +
          'with a blue bold underline substring '.blue.underline.bold +
          ''.reset +
          'with a red italic overline substring'.red.overline.italic +
          ' that becomes green again!')
      .green);

  // test joining array
  print(([
    'I am a purple line',
    'with a blue bold underline substring'.blue.underline.bold,
    'with a yellow italic g doubleunderline substring'
        .brightYellow
        .doubleUnderline
        .italic,
    'that becomes purple again!'
  ].join())
      .purple);

  print('Hello this is a blink test'.blink);
  print('Hello this is a doublenderline test'.doubleunderline);

  // test joinWith
  print([
    'Hello',
    'World!',
    'Foo',
    'bar',
    'biz',
    'baz',
    '(This Array joined with ",")'
  ].join(',').red);

  // nesting mulitple args
  print(['Hello', 'World!'.underline, 'Foo', 'bar', 'biz'.blue, 'baz']
      .join()
      .orangeRed);
  print(['Hello', 'World!', 'Foo', 'bar', 'biz', 'baz'].join(' ').darkOrange);

  // Nest styles
  print(('Hello' + 'world'.underline.bgBlue + '!').red);

  print(([
    'These will all have a \n after each line from joinWith()',
    () =>
        'Array of Closures #1 Testing Chalk`Dart With Closures - This is return from closure #1!!! DIM blue'
            .onBlue,
    () =>
        'Array of Closures #2 and this is the return from closure #2 then back to blue'
            .brightBlue,
    () => 'This closure called chalk and makes this red'.red,
    () =>
        'And this closure ${"Nest calls to chalk".black.onYellow} inside the closure'
            .white
            .onBlue,
  ].join('\n'))
      .goldenrod
      .onBlack);

  print('Hey There using X11 extensions'.lightGoldenrodYellow.onCornflowerBlue);

  print(
      'Following under/overline color test will only work in vscode. Will be white in terminal.'
          .red);
  print('Testing Chalk`Dart!!! blue WITH Red double underline'
      .blue
      .underlineRgb(255, 0, 0)
      .doubleunderline);
  print('Testing Chalk`Dart!!! cornflowerblue WITH Green double underline'
      .cornflowerBlue
      .underlineRgb16m(0, 255, 0)
      .doubleunderline);

  print(
      'Testing Chalk`Dart!!! cornflowerblue WITH blue overline and strikethrough'
          .cornflowerBlue
          .underlineRgb16m(0, 0, 255)
          .overline
          .strikethrough);
  print('\n');
  print(
      'Testing Chalk`Dart!!! cornflowerblue WITH white double underline, overline'
          .cornflowerBlue
          .underlineRgb16m(255, 255, 255)
          .doubleunderline
          .overline);

  print(('here is some yellow text, black BG color ' +
          'and then switch to inverse colors'.inverse +
          ' and back to regular')
      .yellow
      .onBlack);
  print(('here is some yellow text, w/ default BG color ' +
          'and then switch to inverse colors'.inverse +
          ' and back to regular')
      .yellow);

  print(('here is some yellow text, no BG color HIDDEN>>>> ' +
          'Here is our secret message ChalkDart ROCKS'.hidden +
          ' <<< HIDDEN (still selectable) and back to regular')
      .yellow);

  print('\n');
  print('21 to 24 double underline'.hsl(150, 1, 0.5).ansiSgr(21, 24));

  String fontTestString =
      "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#\$%^&*()_+'\"`~";

  // Combine styled and normal strings
  print('Hello BLUE font 1'.reset.blue + ' World' + '! font 3 RED'.reset.red);

  print(("FONT 1  " + fontTestString + '\n').reset.font1.white);

  print(("FONT 2  " + fontTestString + '\n').reset.font2.white);

  print(("FONT 3  " + fontTestString + '\n').reset.font3.white);

  print(("FONT 4  " + fontTestString + '\n').reset.font4.white);

  print(("FONT 5  " + fontTestString + '\n').reset.font5.white);

  print(("FONT 6  " + fontTestString + '\n').reset.font6.white);

  print("  Cascadia Code Ligatures  <> |=> ++ -> <!-- ~~> ->> /= <= ### |>"
      .reset
      .font6
      .blueBright);

  print(("FONT 7  " + fontTestString + '\n').reset.font7.white);
  print("  JetBrains Ligatures  <> |=> ++ -> <!-- ~~> ->> /= <= ### |>"
      .reset
      .font7
      .white);

  print(("FONT 8  " + fontTestString + '\n').reset.font8.white);

  print(("FONT 9  " + fontTestString + '\n').reset.font9.white);
  print("  JetBrains Ligatures  <> |=> ++ -> <!-- ~~> ->> /= <= ### |>"
      .reset
      .font9
      .blue);

  print(("FONT 10  -extra wide font - no ligatures " + fontTestString)
      .reset
      .font10
      .white);

  print('Hello BLUE font 1'.reset.blue.font1 +
      ' World' +
      '! <same line font change)     font 3 RED'.reset.red.font3);

  // Compose multiple styles using the chainable API
  print('Hello World! Font 1'.hsl(180, 1, 0.5).font1);
  print('Hello world! Font 2'.hsl(210, 1, 0.5).font2);
  print('Hello world! Font 3'.hsl(240, 1, 0.5).onGreyscale(.7).font3);
  print('Hello world! Font 4'.hsl(270, 1, 0.5).onGreyscale(.1).font4 +
      ' (on same line) Hello world! Font 3'.font3);
  print('Hello world! Font 5'.hsl(300, 1, 0.5).onGreyscale(.2).font5);
  print('Hello world! Font 6'.hsl(330, 1, 0.5).onGreyscale(.3).font6);
  print('Hello world! Font 7'.hsl(0, 1, 0.5).onGreyscale(.4).font7);
  print('Hello world! Font 8'.hsl(30, 1, 0.5).onGreyscale(.5).font8);
  print('Hello world! Font 9'.hsl(60, 1, 0.5).onGreyscale(.5).font9);
  print('Hello world! Font blackletter (font 10)'
      .hsl(90, 1, 0.5)
      .onGreyscale(.5)
      .blackletter);
  print('Hello world! Font 10'.hsl(90, 1, 0.5).onGreyscale(.5).blackletter);
  print('\n');

  print(
      'Following under/overline color test will only work in vscode. Will be white in terminal.'
          .red);

  print('Hello world! green text on magenta with green OVERLINE'
      .hsl(120, 1, 0.5)
      .onMagenta
      .underlineRgb16m(0, 255, 0)
      .overline);

  print(
      'TIMTEST Hello world! .underlineRgb16m KILL STYLE on Android green text on grey with green OVERLINE'
          .hsl(120, 1, 0.5)
          .onGrey
          .underlineRgb16m(0, 255, 0)
          .overline);

  print(
      'TIMTEST Hello world! .underlineRgb KILL STYLE on Android green text on grey with green OVERLINE'
          .hsl(120, 1, 0.5)
          .onGrey
          .underlineRgb(0, 255, 0)
          .overline);

  print('\n');
  print('Hello world! bright white w/ green OVERLINE'
      .overline
      .brightWhite
      .underlineRgb16m(0, 255, 0));
  print('\n');

  print(
      'this is ${'red superscript txet'.red.superscript} and back to regular text'
          .brightBlue);
  print(
      'this is ${'yellow subscript text'.yellow.subscript} and back to regular text'
          .brightBlue);

  print(
      'this is underlined ${'red superscript text'.red.superscript} and back to regular text'
          .underlined
          .brightBlue);
  print(
      'this is underlined ${'yellow subscript text'.yellow.subscript} and back to regular text'
          .underlined
          .brightBlue);

  print(
      'this is overlined ${'red superscript text'.red.superscript} and back to regular text'
          .overlined
          .brightBlue);
  print(
      'this is overlined ${'yellow subscript text'.yellow.subscript} and back to regular text'
          .overlined
          .brightBlue);

  print(
      'Yay for ${'red'.red} on dynamically called orange colored text!'.orange);
  print('Yay for ${'chartreuse'.chartreuse} on cornflowerblue colored text!'
      .chartreuse
      .onCornflowerBlue);
  print('Yay for underline.color.peachpuff.onPurple colored text!'
      .underline
      .peachPuff
      .onPurple);
  print(
      'Yay for x11.MediumSlateBlue.bgMediumVioletRed colored DOUBLE UNDERLINED text!'
          .doubleUnderline
          .mediumSlateBlue
          .onMediumVioletRed);

  var testtim = "Super Way";

  print(
      'Yay for .orangeRed background to ${("purple $testtim inside").purple} back to orangeRed colored text!'
          .orangeRed);
  print('Yay for lightskyblue colored text!'.lightSkyBlue);

  // Use RGB colors in terminal emulators that support it.
  print('Yay for olive colored text!'.keyword('olive'));
  print(
      'Yay for red on yellow colored text!'.keyword('red').onKeyword('yellow'));
  print('Yay for lightskyblue colored text!'.keyword('lightskyblue'));
  print('Yay for cornflowerblue on darkseagreen colored text!'
      .keyword('cornflowerblue')
      .bgKeyword('darkseagreen'));
  print('Underlined reddish color rgb(123, 45, 67)'.rgb(123, 45, 67).underline);
  print('hextest Bold #DEADED'.hex('#DEADED').bold);
  print('hex test underline 0xDEADED'.hex(0xDEADED).underline);
  print('hex test italic 0xbed'.italic.hex('0xbed').underline);
  print('hex test bold #BBeedd'.hex('#BBeedd').bold);
  print('hex test 0xb0d'.hex('0xb0d'));
  print('hex test 0xbb00dd'.hex('0xbb00dd'));

  // use in multiline string and in templating
  print('''
CPU: ${'90%'.red}
RAM: ${'40%'.green}
DISK: ${'70%'.yellow}
''');

  print('''
CPU: ${(344).toString().red}%
RAM: ${(0.47 * 100).toString().green}%
DISK: ${(0.76 * 100).toString().rgb(255, 131, 0)}%
''');
}

/*
League Mono  (the variable version) supports   CSS font-stretch: 200%, so you can make it wide
  https://www.theleagueofmoveabletype.com/league-mono   download the font package here
    within the archive you are looking for the variable font 
        'LeagueMono-2.300\variable\TTF\LeagueMono-VF.ttf'
  github ( https://github.com/theleagueof/league-mono  )

Cascadia Code and other fonts found here:
  https://github.com/microsoft/cascadia-code/releases
  main github:  https://github.com/microsoft/cascadia-code
  and more information about the fonts and ligatures
  https://docs.microsoft.com/en-us/windows/terminal/cascadia-code
  CSS Font Family: 'Cascadia Code', 'Cascadia Mono', 'Cascadia Code PL', 'Cascadia Mono PL'
  Information on PowerLine Extra Characters (PL versions of Cascadia fonts)
  https://github.com/ryanoasis/powerline-extra-symbols

JetBrains Mono
  https://www.jetbrains.com/lp/mono/?ref=betterwebtype
  looking for variable font
  'C:\src\fonts\LeagueMono-2.300\variable\TTF\LeagueMono-VF.ttf'
  css font-family  'JetBrains Mono Thin'
  Using Customize UI extension you can place custom CSS in settings.json and you need to add this:

Lots more 'Nerd' fonts (with various features)
  https://github.com/ryanoasis/nerd-fonts


When using VSCode it is possible to Enable full font support for the 10 fonts
by installing the extension "Customize UI" and adding the following to your VSCode settings.json
file.
For the value for each of these CSS selectors you place the font-family of the font you want to use.
In the example below I have including using some of the fonts listed above. 

Add this to VSCode settings.json, after enabling the "Customize UI" extension:

    "customizeUI.stylesheet": {
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-1" : "font-family: Verdana,Arial,sans-serif;",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-2" : "font-style: italic; font-size: 16px; padding: 0px; font-family: 'Cascadia Code PL', Georgia,'Times New Roman',serif; ",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-3" : "font-family: 'Segoe WPC', 'Segoe UI', Papyrus, Impact,fantasy; ",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-4" : "font-family: 'Cascadia Mono', 'Apple Chancery','Lucida Calligraphy',cursive;",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-5" : "font-family: 'Courier New', 'Courier', monospace;",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-6" : "font-size: 16px; padding: 0px; font-family: 'Cascadia Code PL', 'Segoe WPC', 'Segoe UI',-apple-system, BlinkMacSystemFont, system-ui, 'Ubuntu', 'Droid Sans', sans-serif;",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-7" : "font-family: 'Cascadia Mono PL', Menlo, Monaco, Consolas,'Droid Sans Mono', 'Inconsolata', 'Courier New', monospace, 'Droid Sans Fallback';",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-8" : "font-size: 14px; padding: 0px; font-family: 'Cascadia Code PL' var(--monaco-monospace-font), 'SF Mono', Monaco, Menlo, Consolas, 'Ubuntu Mono', 'Liberation Mono', 'DejaVu Sans Mono', 'Courier New', monospace;",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-9" : "font-size: 16px; font-family: 'JetBrains Mono';", //"font-family: 'JetBrains Mono', var(--vscode-editor-font-family), 'SF Mono', Monaco, Menlo, Consolas, 'Ubuntu Mono', 'Liberation Mono', 'DejaVu Sans Mono', 'Courier New', monospace;",
        ".monaco-workbench .repl .repl-tree .output.expression .code-font-10" : "font-stretch: ultra-expanded; font-weight: bold; font-family: 'League Mono', 'F25 BlackletterTypewriter', UnifrakturCook, Luminari, Apple Chancery, fantasy, Papyrus;",
    },

*/

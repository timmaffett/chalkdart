/*
  @author: tim maffett
*/
import 'package:chalkdart/chalkdart.dart';
import 'chalkdart_charts.dart';

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
void main() {
  final includeFonts = true;

  Chalk chalk = Chalk();

  print(chalk.cornflowerBlue
      .onBisque("            Chalk'Dart example program           "));

  print('supportsAnsiColor = $dartSupportsAnsiColor');
  print('usedAnsiInclude = $chalkUsedAnsiInclude');

  Chalk.ansiColorLevelForNewInstances = 3;
  Chalk.useFullResetToClose = true;

  chalk = Chalk.Instance(level: 3);

  print(chalk.green('I am a green line ' +
      chalk.blue.underline.bold('with a blue bold underline substring ') +
      chalk.reset('') +
      chalk.red.overline.italic('with a red italic overline substring') +
      ' that becomes green again!'));

  print(chalk.x11.purple([
    'I am a purple line',
    chalk.blue.underline.bold('with a blue bold underline substring'),
    chalk.brightYellow.doubleUnderline
        .italic('with a yellow italic g doubleunderline substring'),
    'that becomes purple again!'
  ]));

// Pass in multiple arguments
  print(chalk.blue(
      'Hello',
      'chalk.red.doubleunderline.onBrightBlue=',
      chalk.red.doubleunderline.onBrightBlue,
      45,
      45.6,
      true,
      {'mymap': 23.4},
      'Foo',
      'bar',
      'biz',
      'baz'));
  print(chalk.blink('Hello this is a blink test'));
  print(chalk.doubleunderline('Hello this is a doublenderline test'));
  print(chalk.blue(
      'Hello',
      'chalk.red.doubleunderline.onBrightBlue=',
      chalk.red.doubleunderline.onBrightBlue,
      45,
      45.6,
      true,
      {'mymap': 23.4},
      'Foo',
      'bar',
      'biz',
      'baz'));

  print(chalk.joinWith(',').red([
    'Hello',
    'World!',
    'Foo',
    'bar',
    'biz',
    'baz',
    '(This Array joined with ",")'
  ]));

  print(chalk.x11.orangeRed('Hello', chalk.underline('World!'), 'Foo', 'bar',
      chalk.blue('biz'), 'baz'));
  print(chalk.x11.DarkOrange(['Hello', 'World!', 'Foo', 'bar', 'biz', 'baz']));

// Nest styles
  print(chalk.red('Hello', chalk.underline.bgBlue('world') + '!'));

  print(chalk.blue('Hello', 'World!', chalk.red, 45, 45.6, true,
      {'mymap': 23.4}, 'Foo', 'bar', 'biz', 'baz'));

  var demolines = ChalkDartCharts.demo();
  print('\n\nChalkDart colorLevel 2 DEMO:');
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }

/*
  Chalk.colorLevel = 3;
  demolines = ChalkDartCharts.demo();
  print('\n\nChalkDart colorLevel 3 DEMO:');
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }

  Chalk.colorLevel = 3;
  //Chalk.DEBUG_CODES = true;
  demolines = ChalkDartCharts.demo16M();
  print('\n\nChalkDart force 16m with colorLevel 2 DEMO:');
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }
  */

  var chalkNL = chalk.wrap('\n', '');

  //Chalk chalk = Chalk();
  //PieceOfChalk chalk = PieceOfChalk();
  print(
      'SGR (Select Graphic Rendition) parameters test (see https://en.wikipedia.org/wiki/ANSI_escape_code#SGR )');
  print(chalk.red('Testing Chalk`Dart!!!  red'));
  print(chalk.red.dim('Testing Chalk`Dart!!! DIM DIM red') +
      chalk.blue(' then back to blue'));

  print(chalk.blue.dim('Testing Chalk`Dart!!! DIM blue') +
      chalk.blue(' then back to blue'));

  print(chalk.yellow.dim('Testing Chalk`Dart!!! DIM yellow') +
      chalk.yellow(' then back to yellow'));
  print(chalk.green.dim('Testing Chalk`Dart!!! DIM green') +
      chalk.green(' then back to green'));
  print(chalk.brightGreen.dim('Testing Chalk`Dart!!! DIM bright green') +
      chalk.brightGreen(' then back to bright green'));

  print(chalk.yellow.blink('Testing Chalk`Dart!!! BLINK yellow'));
  print(chalk.blue.rapidblink('Testing Chalk`Dart!!! FASTBLINK  blue'));
  print(
      chalk.blue.bgGreen.italic('Testing Chalk`Dart!!! ITALIC  blue bgGreen'));
  print(chalk.blueBright.onBlue('Testing Chalk`Dart!!!  blueBright.onBlue'));
  print(chalk.magenta.onGrey('Testing Chalk`Dart!!! ' +
      chalk.inverse('THIS IS INVERTED COLOR') +
      ' of magenta.onGrey'));
  print(chalk.white.onGrey('Testing Chalk`Dart!!! ' +
      chalk.inverse(
          'THIS IS (${chalk.inverse('(THIS IS NESTED INVERTED COLOR)')})  INVERTED COLOR') +
      ' of magenta.onGrey'));
  print(chalkNL.onBrightGreen.redBright.strikethrough(
      'Testing Chalk`Dart!!!  onGreenBright.redBright.strikethrough'));
  print(
      chalkNL.red.onCyan.overline('Testing Chalk`Dart!!! OVERLINE red.onCyan'));

  print(chalk.blueBright.onGreen('Testing Chalk`Dart!!! blueBright.onGreen'));
  print(chalk.blue.x11
      .onDarkSalmon('Testing Chalk`Dart!!! blue.x11.onDarkSalmon'));
  print(
      chalk.bgYellowBright.blue('Testing Chalk`Dart!!! .bgBrightYellow.blue'));
  print(chalk.yellow.onBlack('Testing Chalk`Dart!!! yellow.onBlack'));
  print(chalk.rgb(244, 232, 122).onBlack('rgb(244,232,122).onBlack !!!'));

  print(chalk.blue
      .underlineRgb(255, 0, 0)
      .underline('Testing Chalk`Dart!!! blue WITH Red underline'));
  print(chalk.yellow
      .underlineRgb16m(0, 255, 0)
      .underline('Testing Chalk`Dart!!! yellow WITH Green underline'));

  print(chalk.yellow
      .underlineRgb16m(0, 0, 255)
      .strikethrough('Testing Chalk`Dart!!! yellow WITH blue strikethrough'));

  print(chalk.yellow.underlineRgb16m(255, 0, 255).underline.overline.strikethrough(
      'Testing Chalk`Dart!!! yellow WITH magenta overline underline AND strikethrough\n'));

  print(chalkNL.x11.slateblue.onWhite(() =>
          'Testing Chalk`Dart With Closures - This is return from closure #1!!! DIM blue') +
      chalk.white.x11.onPurple(
          () => ' and this is the return from closure #2 then back to blue'));

  print(chalk.joinWith('\n').x11.goldenrod.onBlack([
    'These will all have a \n after each line from joinWith()',
    () => chalk.onBlue(
        'Array of Closures #1 Testing Chalk`Dart With Closures - This is return from closure #1!!! DIM blue'),
    () => chalk.brightBlue(
        'Array of Closures #2 and this is the return from closure #2 then back to blue'),
    () => chalk.red('This closure called chalk and makes this red'),
    () => chalk.white.onBlue(
        'And this closure ${chalk.black.onYellow("Nest calls to chalk")} inside the closure'),
  ]));

/*
  print(chalk.blue
      .underlineRgb(255, 0, 0)
      .doubleunderline('Testing Chalk`Dart!!! blue WITH Red double underline'));
  print(chalk.x11.cornFlowerBlue
      .underlineRgb16m(0, 255, 0)
      .doubleunderline('Testing Chalk`Dart!!! cornflowerblue WITH Green double underline'));

  print(chalk.x11.cornFlowerBlue
      .underlineRgb16m(0, 0, 255)
      .overline
      .strikethrough('Testing Chalk`Dart!!! cornflowerblue WITH blue overline and strikethrough'));
  print('\n');
  print(chalk.x11.cornFlowerBlue.underlineRgb16m(255, 255, 255).doubleunderline.overline(
      'Testing Chalk`Dart!!! cornflowerblue WITH white double underline, overline'));
*/

  print(chalk.yellow.onBlack('here is some yellow text, black BG color ' +
      chalk.inverse('and then switch to inverse colors') +
      ' and back to regular'));
  print(chalk.yellow('here is some yellow text, w/ default BG color ' +
      chalk.inverse('and then switch to inverse colors') +
      ' and back to regular'));

  print(chalk.yellow('here is some yellow text, no BG color HIDDEN>>>> ' +
      chalk.hidden('Here is our secret message ChalkDart ROCKS') +
      ' <<< HIDDEN (still selectable) and back to regular'));

  print('\n');
  print(chalk
      .hsl(150, 1, 0.5)
      //.onGreyscale(0.05)
      .ansiSgr(21, 24)('21 to 24 double underline'));

  if (includeFonts) {
    String fontTestString =
        "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#\$\%^&*()_+\'\"`~";
    String ligatureTest =
        chalk.blue("\n" + "--> ~~> *** != !== <||| |||> ++ .= >= <= ~= *= /= ");
    String ligatureTest2 = chalk.brightBlue(
        "<<-----<<-----||----->>----->> <===<===||===>===> >---||---< \n  <==<==||==>==> /===/===//===/===/ //===:===!===//" +
            "|---<>>-----|| ||-----<< \/ /\ <> <~> </>");
    // Combine styled and normal strings
    print(chalk.reset.blue('Hello BLUE font 1') +
        ' World' +
        chalk.reset.red('! font 3 RED'));

    //chalk = chalk.font6;

    print(chalk.reset.font1
        .white("FONT 1  ", fontTestString, ligatureTest, '\n', ligatureTest2));

    print(chalk.reset.font2
        .white("FONT 2  ", fontTestString, ligatureTest, '\n', ligatureTest2));

    print(chalk.reset.font3
        .white("FONT 3  ", fontTestString, ligatureTest, '\n', ligatureTest2));

    print(chalk.reset.font4
        .white("FONT 4  ", fontTestString, ligatureTest, '\n', ligatureTest2));

    print(chalk.reset.font5
        .white("FONT 5  ", fontTestString, ligatureTest, '\n', ligatureTest2));

    print(chalk.reset.font6
        .white("FONT 6  ", fontTestString, ligatureTest, '\n', ligatureTest2));
    outputThePowerSymbols(chalk.font6);
    print(chalk.reset.font6.blueBright(
        "  Cascadia Code Ligatures  <> |=> ++ -> <!-- ~~> ->> /= <= ### |>"));

    print(chalk.reset.font7
        .white("FONT 7  ", fontTestString, ligatureTest, '\n', ligatureTest2));
    print(chalk.reset.font7.white(
        "  JetBrains Ligatures  <> |=> ++ -> <!-- ~~> ->> /= <= ### |>"));

    outputThePowerSymbols(chalk.font7);
    print(chalk.reset.font8
        .white("FONT 8  ", fontTestString, ligatureTest, '\n', ligatureTest2));

    print(chalk.reset.font9
        .white("FONT 9  ", fontTestString, ligatureTest, '\n', ligatureTest2));
    print(chalk.reset.font9
        .blue("  JetBrains Ligatures  <> |=> ++ -> <!-- ~~> ->> /= <= ### |>"));

    print(chalk.reset.font10
        .white("FONT 10  -extra wide font - no ligatures ", fontTestString));

    print(chalk.reset.blue.font1('Hello BLUE font 1') +
        ' World' +
        chalk.reset.red.font3('! <same line font change)     font 3 RED'));

    // Compose multiple styles using the chainable API
    print(chalk
        .hsl(180, 1, 0.5)
        //.onGreyscale(.5)
        .font1('Hello World! Font 1'));
    print(chalk
        .hsl(210, 1, 0.5)
        //.onGreyscale(.6)
        .font2('Hello world! Font 2'));
    print(chalk.hsl(240, 1, 0.5).onGreyscale(.7).font3('Hello world! Font 3'));
    print(chalk.hsl(270, 1, 0.5).onGreyscale(.1).font4('Hello world! Font 4') +
        chalk.font3(' (on same line) Hello world! Font 3'));
    print(chalk.hsl(300, 1, 0.5).onGreyscale(.2).font5('Hello world! Font 5'));
    print(chalk.hsl(330, 1, 0.5).onGreyscale(.3).font6('Hello world! Font 6'));
    print(chalk.hsl(0, 1, 0.5).onGreyscale(.4).font7('Hello world! Font 7'));
    print(chalk.hsl(30, 1, 0.5).onGreyscale(.5).font8('Hello world! Font 8'));
    print(chalk.hsl(60, 1, 0.5).onGreyscale(.5).font9('Hello world! Font 9'));
    print(chalk
        .hsl(90, 1, 0.5)
        .onGreyscale(.5)
        .blackletter('Hello world! Font blackletter (font 10)'));
    print(chalk
        .hsl(90, 1, 0.5)
        .onGreyscale(.5)
        .blackletter('Hello world! Font 10'));
    print('\n');
  }

  print(chalk
      .hsl(120, 1, 0.5)
      .onMagenta
      .underlineRgb16m(0, 255, 0)
      .overline('Hello world! green text on magenta with green OVERLINE'));

  print(chalk
      .hsl(120, 1, 0.5)
      .onGrey
      //.underlineRgb16m(0, 255, 0)
      .overline(
          'TIMTEST Hello world! .underlineRgb16m KILL STYLE on Android green text on magenta with green OVERLINE'));

  print(chalk
      .hsl(120, 1, 0.5)
      .onGrey
      //.underlineRgb(0, 255, 0)
      .overline(
          'TIMTEST Hello world! .underlineRgb KILL STYLE on Android green text on magenta with green OVERLINE'));

  print('\n');
  print(chalk.overline.brightWhite.underlineRgb16m(0, 255, 0)(
      'Hello world! bright white w/ green OVERLINE'));
  print('\n');

  Chalk chalkWithReset = chalk.reset;
/*
  print(chalk.blueBright.onWhite
      .ansiSgr('4:1', '4:0')('ECMA-48 sub-parameters/VTE52 codes: alt solid underline Hello world!'));
  print(chalk.blueBright.onGray
      .ansiSgr('4:2', '4:0')('ECMA-48 sub-parametersVTE52 codes: alt double underline Hello world!'));
  print(chalk.blueBright.bgBrightWhite
      .ansiSgr('4:3', '4:0')('ECMA-48 sub-parameters/VTE52 codes: Wavy/Curly underline Hello world!'));
  print(chalk.blueBright.bgBrightWhite
      .ansiSgr('4:4', '4:0')('ECMA-48 sub-parameters/VTE52 codes: Dotted underline Hello world!'));
  print(chalk.blueBright.bgBrightWhite
      .ansiSgr('4:5', '4:0')('ECMA-48 sub-parameters/VTE52 codes: Dashed underline Hello world!'));
*/
  print(chalkWithReset.brightBlue(
      'this is ${chalk.red.superscript('red superscript text')} and back to regular text'));
  print(chalkWithReset.brightBlue(
      'this is ${chalk.yellow.subscript('yellow subscript text')} and back to regular text'));

  print(chalkWithReset.underlined.brightBlue(
      'this is underlined ${chalk.red.superscript('red superscript text')} and back to regular text'));
  print(chalkWithReset.underlined.brightBlue(
      'this is underlined ${chalk.yellow.subscript('yellow subscript text')} and back to regular text'));

  print(chalkWithReset.overlined.brightBlue(
      'this is overlined ${chalk.red.superscript('red superscript text')} and back to regular text'));
  print(chalkWithReset.overlined.brightBlue(
      'this is overlined ${chalk.yellow.subscript('yellow subscript text')} and back to regular text'));

  print(chalkWithReset.color
      .orange('Yay for red on dynamically called orange colored text!'));
  print(chalkWithReset.color.chartreuse.onCornflowerblue(
      'Yay for lightskyblue on cornflowerblue colored text!'));
  print(chalkWithReset.underline.csscolor.peachpuff
      .onPurple('Yay for underline.color.peachpuff.onPurple colored text!'));
  print(chalkWithReset.doubleUnderline.x11.MediumSlateBlue.bgMediumVioletRed(
      'Yay for x11.MediumSlateBlue.bgMediumVioletRed colored DOUBLE UNDERLINED text!'));

  var testtim = "Super Way";
  dynamic chalk2 =
      Chalk(); // put chalk in dynamic variable so we can directly access X11/CSS color names as 'virtual' methods
  print(chalk2.orangeRed(
      'Yay for .orangeRed background to ${chalk.x11.purple("purple $testtim inside")} back to orangeRed colored text!'));
  print(chalk2.lightskyblue('Yay for lightskyblue colored text!'));

  // Use RGB colors in terminal emulators that support it.
  print(chalk.keyword('olive')('Yay for olive colored text!'));
  print(chalk
      .keyword('red')
      .onKeyword('yellow')('Yay for red on yellow colored text!'));
  print(chalk.keyword('lightskyblue')('Yay for lightskyblue colored text!'));
  print(chalk.keyword('cornflowerblue').bgKeyword('darkseagreen')(
      'Yay for cornflowerblue on darkseagreen colored text!'));
  print(chalk
      .rgb(123, 45, 67)
      .underline('Underlined reddish color rgb(123, 45, 67)'));
  print(chalk.hex('#DEADED').bold('hextest Bold #DEADED'));
  print(chalk.hex(0xDEADED).underline('hex test underline 0xDEADED'));
  print(chalk.italic.hex('0xbed').underline('hex test italic 0xbed'));
  print(chalk.hex('#BBeedd').bold('hex test bold #BBeedd'));
  print(chalk.hex('0xb0d')('hex test 0xb0d'));
  print(chalk.hex('0xbb00dd')('hex test 0xbb00dd'));

  // Pass in multiple arguments
  print(chalk.blue('Hello', 'World!', 'Foo', 'bar', 'biz', 'baz'));

  // Nest styles
  print(chalk.red('Hello', chalk.underline.bgBlue('world') + '!'));

  // Nest styles of the same type even (color, underline, background)
  print(chalk.green('I am a green line ' +
      chalk.blue.underline.bold('with a blue substring') +
      ' that becomes green again!'));

  // use in multiline string and in templating
  print('''
      CPU: ${chalk.red('90%')}
      RAM: ${chalk.green('40%')}
      DISK: ${chalk.yellow('70%')}
   ''');

  chalk = Chalk.Instance(level: 3).font8;
  //Chalk.DEBUG_CODES = true;
  //chalk = chalk.reset;
/*
  print( "one that doesnt work: "+chalk.toStringAll() );
  String outStr = chalk.black.onYellow(ChalkDartCharts.center(chalk.bold('Test Background'), 80))+'END';
  print( outStr );
  print("DEBUG='${Chalk.makePrintableForDebug( outStr )}'" );
  //Chalk.DEBUG_CODES = false;
  chalk = Chalk.Instance(level: 3);
  //Chalk.DEBUG_CODES = true;
  print( "one that works: "+chalk.toStringAll() );
  outStr = chalk.black.onYellow(ChalkDartCharts.center(chalk.bold('Test Background'), 80))+'END';
  print( outStr );
  print("DEBUG='${Chalk.makePrintableForDebug( outStr )}'" );
  //Chalk.DEBUG_CODES = false;
*/

  //Chalk.DEBUG_CODES = true;
  demolines = ChalkDartCharts.dumpAllHWBTables();
  print('\n\n');
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }

  print('\n\n');
  demolines = ChalkDartCharts.dumpAllHSLTables();
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }

  print('\n\n');
  demolines = ChalkDartCharts.dumpAllHSVTables();
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }

  print('\n\n');
  demolines = ChalkDartCharts.dumpAllRangeHSVTables(180, 360);
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }
  print('\n\n');
  demolines = ChalkDartCharts.dumpLabChart(60);
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }
  print('\n\n');
  demolines = ChalkDartCharts.dumpLabChart(75);
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }

  print('\n\n');
  demolines = ChalkDartCharts.dumpLabChart(85);
  for (var i = 0; i < demolines.length; i++) {
    print(demolines[i]);
  }
}

void outputThePowerSymbols(Chalk chalk) {
  powerlineSettings.forEach((key, value) {
    print(makeAPowerLinePrompt(chalk, key));
  });
}

int powerLineCalls = 0;
String makeAPowerLinePrompt(Chalk chalk, String name) {
  powerLineCalls++;
  Map<String, String> item = powerlineSettings[name];

  String extraindent = '';
  for (var i = 0; i < powerLineCalls; i++) extraindent += ' ';

  String lock = (item['lock'] ?? '');
  String network = (item['network'] ?? '');
  String separator = (item['separator'] ?? '');
  String separator_thin = (item['separator_thin'] ?? '');

  String out = chalk.onYellow.color.orange("  " + extraindent + lock) +
      chalk
          .onKeyword("orange")
          .color
          .orangered("  " + extraindent + chalk.inverse(network)) +
      chalk
          .onKeyword("orangered")
          .red("  " + extraindent + chalk.inverse(separator)) +
      chalk.onRed("  " + extraindent) +
      chalk.red(separator) +
      '  ' +
      chalk.color.orangeRed(separator_thin);
  return out;
}

Map<String, dynamic> powerlineSettings = {
  //# original
  'patchedoriginal': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0B0',
    'separator_thin': '\uE0B1'
  },
  //# angly 1
  'patchedangly 1': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0B8',
    'separator_thin': '\uE0B9'
  },
  //# angly 2
  'patched angly 2': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0BC',
    'separator_thin': '\uE0BD'
  },

  ///# curvy
  'patchedcurvy': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0B4',
    'separator_thin': '\uE0B5'
  },
  //# flames (flamey)
  'patchedflames (flamey)': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0C0',
    'separator_thin': '\uE0C1'
  },
  //# lego (blocky)
  'patchedlego (blocky)': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0CE',
    'separator_thin': '\uE0CF'
  },
  //# lego (blocky)
  'patchedlego (blocky2)': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0D0',
    'separator_thin': '\uE0D1'
  },
  //# pixelated blocks 2 (large) random fade (pixey)
  'patchedpixelated blocks 2 (large) random fade (pixey)': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0C4',
    'separator_thin': '\uE0C6'
  },
  'patched hex': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0CC',
    'separator_thin': '\uE0CD'
  },
  'patched fireish': {
    'lock': '\uE0A2',
    'network': '\uE0A2',
    'separator': '\uE0C8',
    'separator_thin': '\uE0CA'
  },
};

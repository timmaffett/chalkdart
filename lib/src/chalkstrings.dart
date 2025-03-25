// Copyright (c) 2020-2025, tim maffett.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'chalk.dart';

/// Extensions on the String class that allow you to use the Chalk methods
/// directly on Strings, ie.
///    'This will be red italic'.red.italic
///    'This will be red on yellow background'.red.onYellow
///
extension ChalkString on String {
  static final Chalk _chalk = Chalk();

  /// Set foreground base 16 xterm colors black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get black => _chalk.black(this);

  /// Set foreground base 16 xterm colors red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get red => _chalk.red(this);

  /// Set foreground base 16 xterm colors green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get green => _chalk.green(this);

  /// Set foreground base 16 xterm colors yellow
  /// (terminal dependent)![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get yellow => _chalk.yellow(this);

  /// Set foreground base 16 xterm colors blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get blue => _chalk.blue(this);

  /// Set foreground base 16 xterm colors magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get magenta => _chalk.magenta(this);

  /// Set foreground base 16 xterm colors cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get cyan => _chalk.cyan(this);

  /// Set foreground base 16 xterm colors white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get white => _chalk.white(this);

  /// Set foreground base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightBlack => _chalk.brightBlack(this);

  /// Set foreground base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get blackBright => _chalk.blackBright(this);

  /// Set foreground base 16 xterm colors gray  (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get gray => _chalk.gray(this);

  /// Set foreground base 16 xterm colors grey (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get grey => _chalk.grey(this);

  /// Set foreground base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightRed => _chalk.brightRed(this);

  /// Set foreground base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get redBright => _chalk.redBright(this);

  /// Set foreground base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightGreen => _chalk.brightGreen(this);

  /// Set foreground base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get greenBright => _chalk.greenBright(this);

  /// Set foreground base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightYellow => _chalk.brightYellow(this);

  /// Set foreground base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get yellowBright => _chalk.yellowBright(this);

  /// Set foreground base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightBlue => _chalk.brightBlue(this);

  /// Set foreground base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get blueBright => _chalk.blueBright(this);

  /// Set foreground base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightMagenta => _chalk.brightMagenta(this);

  /// Set foreground base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get magentaBright => _chalk.magentaBright(this);

  /// Set foreground base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightCyan => _chalk.brightCyan(this);

  /// Set foreground base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get cyanBright => _chalk.cyanBright(this);

  /// Set foreground base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightWhite => _chalk.brightWhite(this);

  /// Set foreground base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get whiteBright => _chalk.whiteBright(this);

  /// Set background base 16 xterm colors black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBlack => _chalk.onBlack(this);

  /// Legacy api, provided only for backwards compatibility, use onBlack.
  /// Set background base 16 xterm colors black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBlack => _chalk.bgBlack(this);

  /// Set background base 16 xterm colors red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onRed => _chalk.onRed(this);

  /// Legacy api, provided only for backwards compatibility, use onRed.
  /// Set background base 16 xterm colors red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgRed => _chalk.bgRed(this);

  /// Set background base 16 xterm colors green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onGreen => _chalk.onGreen(this);

  /// Legacy api, provided only for backwards compatibility, use onGreen.
  /// Set background base 16 xterm colors green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgGreen => _chalk.bgGreen(this);

  /// Set background base 16 xterm colors yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onYellow => _chalk.onYellow(this);

  /// Legacy api, provided only for backwards compatibility, use onYellow.
  /// Set background base 16 xterm colors yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgYellow => _chalk.bgYellow(this);

  /// Set background base 16 xterm colors blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBlue => _chalk.onBlue(this);

  /// Legacy api, provided only for backwards compatibility, use onBlue.
  /// Set background base 16 xterm colors blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBlue => _chalk.bgBlue(this);

  /// Set background base 16 xterm colors magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onMagenta => _chalk.onMagenta(this);

  /// Legacy api, provided only for backwards compatibility, use onMagenta.
  /// Set background base 16 xterm colors magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgMagenta => _chalk.bgMagenta(this);

  /// Set background base 16 xterm colors cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onCyan => _chalk.onCyan(this);

  /// Legacy api, provided only for backwards compatibility, use onCyan.
  /// Set background base 16 xterm colors cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgCyan => _chalk.bgCyan(this);

  /// Set background base 16 xterm colors white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onWhite => _chalk.onWhite(this);

  /// Legacy api, provided only for backwards compatibility, use onWhite.
  /// Set background base 16 xterm colors white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgWhite => _chalk.bgWhite(this);

  /// Set background base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightBlack => _chalk.onBrightBlack(this);

  /// Set background base 16 xterm colors gray (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onGray => _chalk.onGray(this);

  /// Set background base 16 xterm colors grey (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onGrey => _chalk.onGrey(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightBlack.
  /// Set background base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightBlack => _chalk.bgBrightBlack(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightBlack.
  /// Set background base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBlackBright => _chalk.bgBlackBright(this);

  /// Legacy api, provided only for backwards compatibility, use onGray.
  /// Set background base 16 xterm colors gray (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgGray => _chalk.bgGray(this);

  /// Legacy api, provided only for backwards compatibility, use onGrey.
  /// Set background base 16 xterm colors grey (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgGrey => _chalk.bgGrey(this);

  /// Set background base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightRed => _chalk.onBrightRed(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightRed.
  /// Set background base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightRed => _chalk.bgBrightRed(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightRed.
  /// Set background base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgRedBright => _chalk.bgBrightRed(this);

  /// Set background base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightGreen => _chalk.onBrightGreen(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightGreen.
  /// Set background base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightGreen => _chalk.bgBrightGreen(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightGreen.
  /// Set background base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgGreenBright => _chalk.bgGreenBright(this);

  /// Set background base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightYellow => _chalk.onBrightYellow(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightYellow.
  /// Set background base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightYellow => _chalk.bgBrightYellow(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightYellow.
  /// Set background base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgYellowBright => _chalk.bgYellowBright(this);

  /// Set background base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightBlue => _chalk.onBrightBlue(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightBlue.
  /// Set background base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightBlue => _chalk.bgBrightBlue(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightBlue.
  /// Set background base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBlueBright => _chalk.bgBlueBright(this);

  /// Set background base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightMagenta => _chalk.onBrightMagenta(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightMagenta.
  /// Set background base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightMagenta => _chalk.bgBrightMagenta(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightMagenta.
  /// Set background base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgMagentaBright => _chalk.bgMagentaBright(this);

  /// Set background base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightCyan => _chalk.onBrightCyan(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightCyan.
  /// Set background base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightCyan => _chalk.bgBrightCyan(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightCyan.
  /// Set background base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgCyanBright => _chalk.bgCyanBright(this);

  /// Set background base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightWhite => _chalk.onBrightWhite(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightWhite.
  /// Set background base 16 xterm colors bright white
  /// (terminal dependent)  ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightWhite => _chalk.bgBrightWhite(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightWhite.
  /// Set background base 16 xterm colors bright white
  /// (terminal dependent)  ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgWhiteBright => _chalk.bgWhiteBright(this);

  ///reset - Resets the current color chain.
  String get reset => _chalk.reset(this);

  /// normal - Text with all attributes off
  String get normal => _chalk.normal(this);

  /// bold - Make text bold.
  String get bold => _chalk.bold(this);

  /// dim - Emitting only a small amount of light.
  String get dim => _chalk.dim(this);

  /// italic - Make text italic. (VSCode debug console supports,some other terminals)
  String get italic => _chalk.italic(this);

  /// underline - Make text underline. (Not as widely supported, supported in VSCode through my PR)
  String get underline => _chalk.underline(this);

  /// underlined (alternate name for underline) - Make text underline. (Not as widely supported, supported in VSCode through my PR)
  String get underlined => _chalk.underlined(this);

  /// doubleunderline - Make text double underlined. (Not as widely supported, supported in VSCode through my PR)
  String get doubleunderline => _chalk.doubleunderline(this);

  /// doubleunderlined (alternate name for doubleunderline) - Make text double underlined. (Not as widely supported, supported in VSCode through my PR)
  String get doubleunderlined => _chalk.doubleunderlined(this);

  /// doubleUnderline (alternate name for doubleunderline) - alternate for doubleunderline
  String get doubleUnderline => _chalk.doubleUnderline(this);

  /// overline - Make text overlined. (Not as widely supported, supported in VSCode through my PR)
  String get overline => _chalk.overline(this);

  /// overlined (alternate name for overline) - Make text overlined. (Not as widely supported, supported in VSCode through my PR)
  String get overlined => _chalk.overlined(this);

  /// blink - Make text blink. (Not as widely supported, supported in VSCode through my PR)
  String get blink => _chalk.blink(this);

  /// rapidblink - Make text blink rapidly (>150 times per minute). (Not as widely supported, supported in VSCode through my PR)
  String get rapidblink => _chalk.rapidblink(this);

  /// inverse- Inverse background and foreground colors.
  String get inverse => _chalk.inverse(this);

  /// invert- alternate for inverse() - Inverse background and foreground colors.
  String get invert => _chalk.invert(this);

  /// hidden - Prints the text, but makes it invisible. (still copy and pasteable)
  String get hidden => _chalk.hidden(this);
  String get strikethrough => _chalk.strikethrough(this);

  /// superscript - Superscript text. (Not as widely supported, supported in VSCode through my PR)
  String get superscript => _chalk.superscript(this);

  /// subscript - Subscript text. (Not as widely supported, supported in VSCode through my PR)
  String get subscript => _chalk.subscript(this);

  /// Alternative font 1. (Not as widely supported, supported in VSCode through my PR)
  String get font1 => _chalk.font1(this);

  /// Alternative font 2. (Not as widely supported, supported in VSCode through my PR)
  String get font2 => _chalk.font2(this);

  ///Alternative font 3. (Not as widely supported, supported in VSCode through my PR)
  String get font3 => _chalk.font3(this);

  /// Alternative font 4. (Not as widely supported, supported in VSCode through my PR)
  String get font4 => _chalk.font4(this);

  /// Alternative font 5. (Not as widely supported, supported in VSCode through my PR)
  String get font5 => _chalk.font5(this);

  /// Alternative font 6. (Not as widely supported, supported in VSCode through my PR)
  String get font6 => _chalk.font6(this);

  /// Alternative font 7. (Not as widely supported, supported in VSCode through my PR)
  String get font7 => _chalk.font7(this);

  /// Alternative font 8. (Not as widely supported, supported in VSCode through my PR)
  String get font8 => _chalk.font8(this);

  /// Alternative font 9. (Not as widely supported, supported in VSCode through my PR)
  String get font9 => _chalk.font9(this);

  /// Alternative font 10. (Not as widely supported, supported in VSCode through my PR)
  String get font10 => _chalk.font10(this);

  /// blackletter - alternate name for font10, ANSI/ECMA-48 spec refers to font10 specifically as a blackletter or Fraktur (Gothic) font.
  /// (Not as widely supported, supported in VSCode through my PR)
  String get blackletter => _chalk.blackletter(this);

  /// visible - Prints the text only when Chalk has a color level > 0. Can be useful for things that are purely cosmetic.
  String get visible => _chalk.visible(this);

  /// Strips any HTML strings present from the string and returns the result
  String get stripHtmlTags => _chalk.stripHtmlTags(this);

  /// Strip all ANSI SGR commands from the target string and return the 'stripped'
  /// result string.
  /// NOTE:  If HTML mode is activated then this strips all HMTL tags from the input string
  String get strip => _chalk.strip(this);

  /// Replaces and < or > characters found within the string the &lt; and &gt;
  /// so that text is safe for html rendering.
  /// NOTE: When using HTML mode this must be the FIRST method called before
  /// any styling calls so that any HTML created for styling is rendered
  /// invalid by the entity conversion.
  /// ie.
  /// OK:  `'my string with < and > '.safeHtml.red.onWhite;`
  /// versus 
  ///      `'my string with < and > '.red.onWhite.safeHtml;`
  /// (The second version will have no styling and instead show all of the html tags
  /// inserted for styling).
  String get htmlSafeGtLt => Chalk.htmlSafeGtLt(this);

  /// Replaces ANY special character that HTML needs a entity for in order to  renderered
  /// correctly.
  String get htmlSafeEntities => Chalk.htmlSafeEntities(this);

  /// Converts all spaces (outside of html tags) in the string with the
  /// html entity `&nbsp;`
  /// This can be useful to preserve spacing when rendering the string in a
  /// browser where all spacing would otherwise be collapsed.
  String get htmlSafeSpaces => Chalk.htmlSafeSpaces(this);

  /// Returns a String with the foreground color set to the passed in RGB Hex code.
  /// This dynamically accepts color hex codes as integer codes (0xAABBCC) or (0xABC)
  /// or as strings ('#AABBCC') or ('#ABC')
  String hex(dynamic hex) => (_chalk.hex(hex))(this);

  /// Returns a String with the background color set to the passed in RGB Hex code.
  /// This dynamically accepts color hex codes as integer codes (0xAABBCC) or (0xABC)
  /// or as strings ('#AABBCC') or ('#ABC')
  String onHex(dynamic hex) => (_chalk.onHex(hex))(this);

  /// Alternate name for onHex() (provided for legacy compatibility with JS Chalk).
  String bgHex(dynamic hex) => (_chalk.onHex(hex))(this);

  /// Returns a String with the foreground color set to the color represented by the
  /// passed in color keyword.
  /// This accepts all of the standard X11/CSS/SVG color names, and the user can extend the list
  /// of accepted color keywords using the addColorKeywordRgb() and addColorKeywordHex() methods
  String keyword(String colorKeyword) => (_chalk.keyword(colorKeyword))(this);

  /// Returns a String with the background color set to the color represented by the
  /// passed in color keyword.
  /// This accepts all of the standard X11/CSS/SVG color names, and the user can extend the list
  /// of accepted color keywords using the addColorKeywordRgb() and addColorKeywordHex() methods
  String onKeyword(String colorKeyword) =>
      (_chalk.onKeyword(colorKeyword))(this);

  /// Alternate name for onKeyword() (provided for legacy compatibility with JS Chalk).
  String bgKeyword(String colorKeyword) =>
      (_chalk.bgKeyword(colorKeyword))(this);

  /// Create String with a foreground color with the specified RGB values.
  String rgb(num red, num green, num blue) =>
      (_chalk.rgb(red, green, blue))(this);

  /// Create String with a background color with the specified RGB values.
  String onRgb(num red, num green, num blue) =>
      (_chalk.onRgb(red, green, blue))(this);

  /// Alternate name for onRgb() (provided for legacy compatibility with JS Chalk).
  String bgRgb(num red, num green, num blue) =>
      (_chalk.onRgb(red, green, blue))(this);

  /// Create String with a foreground color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3).
  String rgb16m(num red, num green, num blue) =>
      (_chalk.rgb16m(red, green, blue))(this);

  /// Create String with a background color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3).
  String onRgb16m(num red, num green, num blue) =>
      (_chalk.onRgb16m(red, green, blue))(this);

  /// Alternate name for onRgb16m() (provided for legacy compatibility with JS Chalk).
  String bgRgb16m(num red, num green, num blue) =>
      (_chalk.onRgb16m(red, green, blue))(this);

  /// Create String with an underline of the the specified RGB color
  /// WARNING: on some consoles without support for this, such as Android Studio,
  /// using this will prevent ALL styles of the Chalk from appearing
  String underlineRgb(num red, num green, num blue) =>
      (_chalk.underlineRgb(red, green, blue))(this);

  /// Create String with an underline of the the specified RGB color
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3)
  /// WARNING: on some consoles without support for this, such as Android Studio,
  /// using this will prevent ALL styles of the Chalk from appearing
  String underlineRgb16m(num red, num green, num blue) =>
      (_chalk.underlineRgb16m(red, green, blue))(this);

  /// Creates String with foreground color defined from HSL (Hue, Saturation
  /// and Lightness) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String hsl(num hue, num saturation, num lightness) =>
      (_chalk.hsl(hue, saturation, lightness))(this);

  /// Creates String with background color defined from HSL (Hue, Saturation
  /// and Lightness) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String onHsl(num hue, num saturation, num lightness) =>
      (_chalk.onHsl(hue, saturation, lightness))(this);

  /// Alternate name for onHsl() (provided for legacy compatibility with JS Chalk)
  String bgHsl(num hue, num saturation, num lightness) =>
      (_chalk.onHsl(hue, saturation, lightness))(this);

  /// Creates String with foreground color defined from HSV (Hue, Saturation
  /// and Value) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String hsv(num hue, num saturation, num value) =>
      (_chalk.hsv(hue, saturation, value))(this);

  /// Creates chalk with background color defined from HSV (Hue, Saturation
  /// and Value) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String onHsv(num hue, num saturation, num value) =>
      (_chalk.onHsv(hue, saturation, value))(this);

  /// Alternate name for onHsv() (provided for legacy compatibility with JS Chalk)
  String bgHsv(num hue, num saturation, num value) =>
      (_chalk.onHsv(hue, saturation, value))(this);

  /// Creates String with foreground color defined from HWB (Hue, Whiteness
  /// and Blackness) color space parameters.
  /// https://en.wikipedia.org/wiki/HWB_color_model
  String hwb(num hue, num whiteness, num blackness) =>
      (_chalk.hwb(hue, whiteness, blackness))(this);

  /// Creates String with background color defined from HWB (Hue, Whiteness
  /// and Blackness) color space parameters.
  /// https://en.wikipedia.org/wiki/HWB_color_model
  String onHwb(num hue, num whiteness, num blackness) =>
      (_chalk.onHwb(hue, whiteness, blackness))(this);

  /// Alternate name for onHwb() (provided for legacy compatibility with JS Chalk)
  String bgHwb(num hue, num whiteness, num blackness) =>
      (_chalk.onHwb(hue, whiteness, blackness))(this);

  /// Creates String with foreground color defined from
  /// XYZ color space parameters.
  /// https://en.wikipedia.org/wiki/CIE_1931_color_space
  String xyz(num x, num y, num z) => (_chalk.xyz(x, y, z))(this);

  /// Creates String with background color defined from
  /// XYZ color space parameters.
  /// https://en.wikipedia.org/wiki/CIE_1931_color_space
  String onXyz(num x, num y, num z) => (_chalk.onXyz(x, y, z))(this);

  /// Alternate name for onXyz() (provided for legacy compatibility with JS Chalk)
  String bgXyz(num x, num y, num z) => (_chalk.onXyz(x, y, z))(this);

  /// Creates String with foreground color defined from
  /// lab color space parameters.
  /// https://en.wikipedia.org/wiki/CIELAB_color_space#CIELAB
  String lab(num l, num a, num b) => (_chalk.lab(l, a, b))(this);

  /// Creates String with background color defined from
  /// lab color space parameters.
  /// https://en.wikipedia.org/wiki/CIELAB_color_space#CIELAB
  String onLab(num l, num a, num b) => (_chalk.onLab(l, a, b))(this);

  /// Alternate name for onLab() (provided for legacy compatibility with JS Chalk)
  String bgLab(num l, num a, num b) => onLab(l, a, b);

  /// Creates String with the foreground color specified by
  /// the ansi color escape code.
  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String ansi(int ansicode) => (_chalk.ansi(ansicode))(this);

  /// Creates String with the background color specified by
  /// the ansi color escape code.
  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String onAnsi(int ansicode) => (_chalk.onAnsi(ansicode))(this);

  /// Alternate name for onAnsi() (provided for legacy compatibility with JS Chalk)
  String bgAnsi(int ansicode) => (_chalk.onAnsi(ansicode))(this);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String ansiSgr(dynamic openCode, dynamic closeCode) =>
      (_chalk.ansiSgr(openCode, closeCode))(this);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String ansi256(int ansicode256) => (_chalk.ansi256(ansicode256))(this);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String onAnsi256(int ansicode256) => (_chalk.onAnsi256(ansicode256))(this);

  /// Alternate name for onAnsi256() (provided for legacy compatibility with JS Chalk)
  String bgAnsi256(int ansicode256) => (_chalk.onAnsi256(ansicode256))(this);

  String greyscale(num greyscale) => (_chalk.greyscale(greyscale))(this);

  String onGreyscale(num greyscale) => (_chalk.onGreyscale(greyscale))(this);

  /// Alternate name for onGreyscale() (provided for legacy compatibility with JS Chalk)
  String bgGreyscale(num greyscale) => (_chalk.onGreyscale(greyscale))(this);

  /// Wrap this chalk with specified prefix and suffix strings.
  String wrap(String prefix, String suffix) =>
      (_chalk.wrap(prefix, suffix))(this);
}

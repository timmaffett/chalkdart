// Copyright (c) 2020-2022, tim maffett.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
///// ChalkDart library
import 'src/supports_ansi.dart'
    if (dart.library.io) 'src/supports_ansi_io.dart'
    if (dart.library.html) 'src/supports_ansi_web.dart';
import 'src/chalk.dart';
export 'src/chalk.dart';

/// Default global instance of chalk used for base call.
/// This can be set to a specific Chalk instance that would then serve
/// as basis for all calls.
Chalk chalk = Chalk();

/// Read only. Chalk does not use it's value although in some
/// situation a user might use this to set the Chalk ansi color level
/// (or something) I have left it here only for completeness.
/// Within the common debug consoles this variable is essentially
/// worthless because they return FALSE from both VSCode debug console
/// and IntelliJ/Android Studio debug consoles.
/// (This is because dart just checks for 'xterm' string being present in
/// the 'TERM' environmental variable of the console..)
/// See https://github.com/dart-lang/sdk/issues/31606 and
///     https://github.com/dart-lang/sdk/issues/41770 for more info.
final bool dartSupportsAnsiColor = supportsAnsiColor;

/// Read only.  Chalk does not look at it's value.
final bool ansiColorDisabled = !supportsAnsiColor;

/// Read only, informational only.
/// Name of the ansi include file used `supports_ansi.dart` is the default, 
/// or the dart.libary.io version `supports_ansi_io.dart`
/// or the dart.library.html version `supports_ansi_web.dart`.
final String chalkUsedAnsiInclude = usedAnsiInclude;

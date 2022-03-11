/// Support for doing something awesome.
///
/// More dartdocs go here.
library chalkdart;

import 'src/supports_ansi.dart'
    if (dart.library.io) 'src/supports_ansi_io.dart'
    if (dart.library.html) 'src/supports_ansi_web.dart';

export 'src/chalkdart.dart';
export 'src/colorutils.dart';

bool ansiColorDisabled = !supportsAnsiColor;

// this variables are essentially worthless because they return FALSE for both VSCode debug console and IntelliJ/Android Studio debug consoles.
// (this is because dart just checks for 'xterm' string being present in the 'TERM' environmental variable of the...)
// https://github.com/dart-lang/sdk/issues/31606 and https://github.com/dart-lang/sdk/issues/41770 for more info
var  dartSupportsAnsiColor = supportsAnsiColor;
var  chalkUsedAnsiInclude = usedAnsiInclude;
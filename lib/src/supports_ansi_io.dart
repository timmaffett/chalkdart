import 'dart:io';

bool get supportsAnsiColor => stdout.supportsAnsiEscapes;
String get usedAnsiInclude => 'supports_ansi_io.dart';
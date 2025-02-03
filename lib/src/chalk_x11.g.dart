// Copyright (c) 2020-2025, tim maffett.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// BEGIN GENERATED CODE - DO NOT MODIFY BY HAND - generating code => /tool/makeX11EntryPoints.dart
import 'chalk.dart';

/// This extension class adds proper methods to Chalk for all of the
/// standard X11/CSS/SVG color names for use by Chalk.
/// This extension has the added advantage of providing code completion and type
/// checking at coding/compile time.  Using the dynamic [color] method cannot provide
/// any coding/compile time checks because it works via a dynamic lookup at run time.
/// Example of using this extension for Chalk:
/// `chalk.lightGoldenrodYellow.onCornflowerBlue(...)`
/// versus having to use the `color` (or `css` or `x11`) method to get a `dynamic` so
/// you can use the dynamic lookups:
/// `chalk.color.lightGoldenrodYellow.onCornflowerBlue(...)`
/// Because of the dynamic lookup is not resolved until run time that method can be
/// prone to errors which would not be detected until run time.
extension ChalkX11 on Chalk {
  /// set foreground color to X11/CSS color aliceBlue  ![aliceblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,248,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF0F8FF)/rgb(240, 248, 255)
  Chalk get aliceBlue => makeRGBChalk(240, 248, 255);

  /// set background color to X11/CSS color aliceBlue ![aliceblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,248,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF0F8FF)/rgb(240, 248, 255)
  Chalk get onAliceBlue => makeRGBChalk(240, 248, 255, bg: true);

  /// set foreground color to X11/CSS color antiqueWhite  ![antiquewhite](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,235,215%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFAEBD7)/rgb(250, 235, 215)
  Chalk get antiqueWhite => makeRGBChalk(250, 235, 215);

  /// set background color to X11/CSS color antiqueWhite ![antiquewhite](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,235,215%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFAEBD7)/rgb(250, 235, 215)
  Chalk get onAntiqueWhite => makeRGBChalk(250, 235, 215, bg: true);

  /// set foreground color to X11/CSS color aqua  ![aqua](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FFFF)/rgb(0, 255, 255)
  Chalk get aqua => makeRGBChalk(0, 255, 255);

  /// set background color to X11/CSS color aqua ![aqua](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FFFF)/rgb(0, 255, 255)
  Chalk get onAqua => makeRGBChalk(0, 255, 255, bg: true);

  /// set foreground color to X11/CSS color aquamarine  ![aquamarine](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28127,255,212%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x7FFFD4)/rgb(127, 255, 212)
  Chalk get aquamarine => makeRGBChalk(127, 255, 212);

  /// set background color to X11/CSS color aquamarine ![aquamarine](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28127,255,212%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x7FFFD4)/rgb(127, 255, 212)
  Chalk get onAquamarine => makeRGBChalk(127, 255, 212, bg: true);

  /// set foreground color to X11/CSS color azure  ![azure](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF0FFFF)/rgb(240, 255, 255)
  Chalk get azure => makeRGBChalk(240, 255, 255);

  /// set background color to X11/CSS color azure ![azure](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF0FFFF)/rgb(240, 255, 255)
  Chalk get onAzure => makeRGBChalk(240, 255, 255, bg: true);

  /// set foreground color to X11/CSS color beige  ![beige](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28245,245,220%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF5F5DC)/rgb(245, 245, 220)
  Chalk get beige => makeRGBChalk(245, 245, 220);

  /// set background color to X11/CSS color beige ![beige](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28245,245,220%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF5F5DC)/rgb(245, 245, 220)
  Chalk get onBeige => makeRGBChalk(245, 245, 220, bg: true);

  /// set foreground color to X11/CSS color bisque  ![bisque](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,228,196%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFE4C4)/rgb(255, 228, 196)
  Chalk get bisque => makeRGBChalk(255, 228, 196);

  /// set background color to X11/CSS color bisque ![bisque](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,228,196%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFE4C4)/rgb(255, 228, 196)
  Chalk get onBisque => makeRGBChalk(255, 228, 196, bg: true);

  /// set foreground color to X11/CSS color blackX11  ![black](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x000000)/rgb(0, 0, 0)
  Chalk get blackX11 => makeRGBChalk(0, 0, 0);

  /// set background color to X11/CSS color blackX11 ![black](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x000000)/rgb(0, 0, 0)
  Chalk get onBlackX11 => makeRGBChalk(0, 0, 0, bg: true);

  /// set foreground color to X11/CSS color blanchedAlmond  ![blanchedalmond](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,235,205%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFEBCD)/rgb(255, 235, 205)
  Chalk get blanchedAlmond => makeRGBChalk(255, 235, 205);

  /// set background color to X11/CSS color blanchedAlmond ![blanchedalmond](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,235,205%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFEBCD)/rgb(255, 235, 205)
  Chalk get onBlanchedAlmond => makeRGBChalk(255, 235, 205, bg: true);

  /// set foreground color to X11/CSS color blueX11  ![blue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x0000FF)/rgb(0, 0, 255)
  Chalk get blueX11 => makeRGBChalk(0, 0, 255);

  /// set background color to X11/CSS color blueX11 ![blue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x0000FF)/rgb(0, 0, 255)
  Chalk get onBlueX11 => makeRGBChalk(0, 0, 255, bg: true);

  /// set foreground color to X11/CSS color blueViolet  ![blueviolet](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28138,43,226%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8A2BE2)/rgb(138, 43, 226)
  Chalk get blueViolet => makeRGBChalk(138, 43, 226);

  /// set background color to X11/CSS color blueViolet ![blueviolet](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28138,43,226%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8A2BE2)/rgb(138, 43, 226)
  Chalk get onBlueViolet => makeRGBChalk(138, 43, 226, bg: true);

  /// set foreground color to X11/CSS color brown  ![brown](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28165,42,42%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xA52A2A)/rgb(165, 42, 42)
  Chalk get brown => makeRGBChalk(165, 42, 42);

  /// set background color to X11/CSS color brown ![brown](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28165,42,42%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xA52A2A)/rgb(165, 42, 42)
  Chalk get onBrown => makeRGBChalk(165, 42, 42, bg: true);

  /// set foreground color to X11/CSS color burlywood  ![burlywood](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28222,184,135%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDEB887)/rgb(222, 184, 135)
  Chalk get burlywood => makeRGBChalk(222, 184, 135);

  /// set background color to X11/CSS color burlywood ![burlywood](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28222,184,135%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDEB887)/rgb(222, 184, 135)
  Chalk get onBurlywood => makeRGBChalk(222, 184, 135, bg: true);

  /// set foreground color to X11/CSS color cadetBlue  ![cadetblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2895,158,160%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x5F9EA0)/rgb(95, 158, 160)
  Chalk get cadetBlue => makeRGBChalk(95, 158, 160);

  /// set background color to X11/CSS color cadetBlue ![cadetblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2895,158,160%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x5F9EA0)/rgb(95, 158, 160)
  Chalk get onCadetBlue => makeRGBChalk(95, 158, 160, bg: true);

  /// set foreground color to X11/CSS color chartreuse  ![chartreuse](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28127,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x7FFF00)/rgb(127, 255, 0)
  Chalk get chartreuse => makeRGBChalk(127, 255, 0);

  /// set background color to X11/CSS color chartreuse ![chartreuse](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28127,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x7FFF00)/rgb(127, 255, 0)
  Chalk get onChartreuse => makeRGBChalk(127, 255, 0, bg: true);

  /// set foreground color to X11/CSS color chocolate  ![chocolate](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28210,105,30%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD2691E)/rgb(210, 105, 30)
  Chalk get chocolate => makeRGBChalk(210, 105, 30);

  /// set background color to X11/CSS color chocolate ![chocolate](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28210,105,30%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD2691E)/rgb(210, 105, 30)
  Chalk get onChocolate => makeRGBChalk(210, 105, 30, bg: true);

  /// set foreground color to X11/CSS color coral  ![coral](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,127,80%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF7F50)/rgb(255, 127, 80)
  Chalk get coral => makeRGBChalk(255, 127, 80);

  /// set background color to X11/CSS color coral ![coral](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,127,80%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF7F50)/rgb(255, 127, 80)
  Chalk get onCoral => makeRGBChalk(255, 127, 80, bg: true);

  /// set foreground color to X11/CSS color cornflowerBlue  ![cornflowerblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28100,149,237%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x6495ED)/rgb(100, 149, 237)
  Chalk get cornflowerBlue => makeRGBChalk(100, 149, 237);

  /// set background color to X11/CSS color cornflowerBlue ![cornflowerblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28100,149,237%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x6495ED)/rgb(100, 149, 237)
  Chalk get onCornflowerBlue => makeRGBChalk(100, 149, 237, bg: true);

  /// set foreground color to X11/CSS color cornsilk  ![cornsilk](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,248,220%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFF8DC)/rgb(255, 248, 220)
  Chalk get cornsilk => makeRGBChalk(255, 248, 220);

  /// set background color to X11/CSS color cornsilk ![cornsilk](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,248,220%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFF8DC)/rgb(255, 248, 220)
  Chalk get onCornsilk => makeRGBChalk(255, 248, 220, bg: true);

  /// set foreground color to X11/CSS color crimson  ![crimson](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28220,20,60%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDC143C)/rgb(220, 20, 60)
  Chalk get crimson => makeRGBChalk(220, 20, 60);

  /// set background color to X11/CSS color crimson ![crimson](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28220,20,60%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDC143C)/rgb(220, 20, 60)
  Chalk get onCrimson => makeRGBChalk(220, 20, 60, bg: true);

  /// set foreground color to X11/CSS color cyanX11  ![cyan](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FFFF)/rgb(0, 255, 255)
  Chalk get cyanX11 => makeRGBChalk(0, 255, 255);

  /// set background color to X11/CSS color cyanX11 ![cyan](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FFFF)/rgb(0, 255, 255)
  Chalk get onCyanX11 => makeRGBChalk(0, 255, 255, bg: true);

  /// set foreground color to X11/CSS color darkBlue  ![darkblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,139%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00008B)/rgb(0, 0, 139)
  Chalk get darkBlue => makeRGBChalk(0, 0, 139);

  /// set background color to X11/CSS color darkBlue ![darkblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,139%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00008B)/rgb(0, 0, 139)
  Chalk get onDarkBlue => makeRGBChalk(0, 0, 139, bg: true);

  /// set foreground color to X11/CSS color darkCyan  ![darkcyan](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,139,139%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x008B8B)/rgb(0, 139, 139)
  Chalk get darkCyan => makeRGBChalk(0, 139, 139);

  /// set background color to X11/CSS color darkCyan ![darkcyan](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,139,139%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x008B8B)/rgb(0, 139, 139)
  Chalk get onDarkCyan => makeRGBChalk(0, 139, 139, bg: true);

  /// set foreground color to X11/CSS color darkGoldenrod  ![darkgoldenrod](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28184,134,11%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xB8860B)/rgb(184, 134, 11)
  Chalk get darkGoldenrod => makeRGBChalk(184, 134, 11);

  /// set background color to X11/CSS color darkGoldenrod ![darkgoldenrod](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28184,134,11%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xB8860B)/rgb(184, 134, 11)
  Chalk get onDarkGoldenrod => makeRGBChalk(184, 134, 11, bg: true);

  /// set foreground color to X11/CSS color darkGray  ![darkgray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28169,169,169%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xA9A9A9)/rgb(169, 169, 169)
  Chalk get darkGray => makeRGBChalk(169, 169, 169);

  /// set background color to X11/CSS color darkGray ![darkgray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28169,169,169%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xA9A9A9)/rgb(169, 169, 169)
  Chalk get onDarkGray => makeRGBChalk(169, 169, 169, bg: true);

  /// set foreground color to X11/CSS color darkGreen  ![darkgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,100,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x006400)/rgb(0, 100, 0)
  Chalk get darkGreen => makeRGBChalk(0, 100, 0);

  /// set background color to X11/CSS color darkGreen ![darkgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,100,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x006400)/rgb(0, 100, 0)
  Chalk get onDarkGreen => makeRGBChalk(0, 100, 0, bg: true);

  /// set foreground color to X11/CSS color darkGrey  ![darkgrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28169,169,169%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xA9A9A9)/rgb(169, 169, 169)
  Chalk get darkGrey => makeRGBChalk(169, 169, 169);

  /// set background color to X11/CSS color darkGrey ![darkgrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28169,169,169%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xA9A9A9)/rgb(169, 169, 169)
  Chalk get onDarkGrey => makeRGBChalk(169, 169, 169, bg: true);

  /// set foreground color to X11/CSS color darkKhaki  ![darkkhaki](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28189,183,107%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xBDB76B)/rgb(189, 183, 107)
  Chalk get darkKhaki => makeRGBChalk(189, 183, 107);

  /// set background color to X11/CSS color darkKhaki ![darkkhaki](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28189,183,107%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xBDB76B)/rgb(189, 183, 107)
  Chalk get onDarkKhaki => makeRGBChalk(189, 183, 107, bg: true);

  /// set foreground color to X11/CSS color darkMagenta  ![darkmagenta](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28139,0,139%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8B008B)/rgb(139, 0, 139)
  Chalk get darkMagenta => makeRGBChalk(139, 0, 139);

  /// set background color to X11/CSS color darkMagenta ![darkmagenta](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28139,0,139%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8B008B)/rgb(139, 0, 139)
  Chalk get onDarkMagenta => makeRGBChalk(139, 0, 139, bg: true);

  /// set foreground color to X11/CSS color darkOliveGreen  ![darkolivegreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2885,107,47%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x556B2F)/rgb(85, 107, 47)
  Chalk get darkOliveGreen => makeRGBChalk(85, 107, 47);

  /// set background color to X11/CSS color darkOliveGreen ![darkolivegreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2885,107,47%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x556B2F)/rgb(85, 107, 47)
  Chalk get onDarkOliveGreen => makeRGBChalk(85, 107, 47, bg: true);

  /// set foreground color to X11/CSS color darkOrange  ![darkorange](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,140,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF8C00)/rgb(255, 140, 0)
  Chalk get darkOrange => makeRGBChalk(255, 140, 0);

  /// set background color to X11/CSS color darkOrange ![darkorange](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,140,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF8C00)/rgb(255, 140, 0)
  Chalk get onDarkOrange => makeRGBChalk(255, 140, 0, bg: true);

  /// set foreground color to X11/CSS color darkOrchid  ![darkorchid](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28153,50,204%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x9932CC)/rgb(153, 50, 204)
  Chalk get darkOrchid => makeRGBChalk(153, 50, 204);

  /// set background color to X11/CSS color darkOrchid ![darkorchid](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28153,50,204%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x9932CC)/rgb(153, 50, 204)
  Chalk get onDarkOrchid => makeRGBChalk(153, 50, 204, bg: true);

  /// set foreground color to X11/CSS color darkRed  ![darkred](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28139,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8B0000)/rgb(139, 0, 0)
  Chalk get darkRed => makeRGBChalk(139, 0, 0);

  /// set background color to X11/CSS color darkRed ![darkred](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28139,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8B0000)/rgb(139, 0, 0)
  Chalk get onDarkRed => makeRGBChalk(139, 0, 0, bg: true);

  /// set foreground color to X11/CSS color darkSalmon  ![darksalmon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28233,150,122%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xE9967A)/rgb(233, 150, 122)
  Chalk get darkSalmon => makeRGBChalk(233, 150, 122);

  /// set background color to X11/CSS color darkSalmon ![darksalmon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28233,150,122%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xE9967A)/rgb(233, 150, 122)
  Chalk get onDarkSalmon => makeRGBChalk(233, 150, 122, bg: true);

  /// set foreground color to X11/CSS color darkSeaGreen  ![darkseagreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28143,188,143%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8FBC8F)/rgb(143, 188, 143)
  Chalk get darkSeaGreen => makeRGBChalk(143, 188, 143);

  /// set background color to X11/CSS color darkSeaGreen ![darkseagreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28143,188,143%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8FBC8F)/rgb(143, 188, 143)
  Chalk get onDarkSeaGreen => makeRGBChalk(143, 188, 143, bg: true);

  /// set foreground color to X11/CSS color darkSlateBlue  ![darkslateblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2872,61,139%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x483D8B)/rgb(72, 61, 139)
  Chalk get darkSlateBlue => makeRGBChalk(72, 61, 139);

  /// set background color to X11/CSS color darkSlateBlue ![darkslateblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2872,61,139%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x483D8B)/rgb(72, 61, 139)
  Chalk get onDarkSlateBlue => makeRGBChalk(72, 61, 139, bg: true);

  /// set foreground color to X11/CSS color darkSlateGray  ![darkslategray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2847,79,79%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x2F4F4F)/rgb(47, 79, 79)
  Chalk get darkSlateGray => makeRGBChalk(47, 79, 79);

  /// set background color to X11/CSS color darkSlateGray ![darkslategray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2847,79,79%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x2F4F4F)/rgb(47, 79, 79)
  Chalk get onDarkSlateGray => makeRGBChalk(47, 79, 79, bg: true);

  /// set foreground color to X11/CSS color darkSlateGrey  ![darkslategrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2847,79,79%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x2F4F4F)/rgb(47, 79, 79)
  Chalk get darkSlateGrey => makeRGBChalk(47, 79, 79);

  /// set background color to X11/CSS color darkSlateGrey ![darkslategrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2847,79,79%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x2F4F4F)/rgb(47, 79, 79)
  Chalk get onDarkSlateGrey => makeRGBChalk(47, 79, 79, bg: true);

  /// set foreground color to X11/CSS color darkTurquoise  ![darkturquoise](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,206,209%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00CED1)/rgb(0, 206, 209)
  Chalk get darkTurquoise => makeRGBChalk(0, 206, 209);

  /// set background color to X11/CSS color darkTurquoise ![darkturquoise](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,206,209%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00CED1)/rgb(0, 206, 209)
  Chalk get onDarkTurquoise => makeRGBChalk(0, 206, 209, bg: true);

  /// set foreground color to X11/CSS color darkViolet  ![darkviolet](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28148,0,211%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x9400D3)/rgb(148, 0, 211)
  Chalk get darkViolet => makeRGBChalk(148, 0, 211);

  /// set background color to X11/CSS color darkViolet ![darkviolet](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28148,0,211%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x9400D3)/rgb(148, 0, 211)
  Chalk get onDarkViolet => makeRGBChalk(148, 0, 211, bg: true);

  /// set foreground color to X11/CSS color deepPink  ![deeppink](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,20,147%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF1493)/rgb(255, 20, 147)
  Chalk get deepPink => makeRGBChalk(255, 20, 147);

  /// set background color to X11/CSS color deepPink ![deeppink](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,20,147%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF1493)/rgb(255, 20, 147)
  Chalk get onDeepPink => makeRGBChalk(255, 20, 147, bg: true);

  /// set foreground color to X11/CSS color deepSkyBlue  ![deepskyblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,191,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00BFFF)/rgb(0, 191, 255)
  Chalk get deepSkyBlue => makeRGBChalk(0, 191, 255);

  /// set background color to X11/CSS color deepSkyBlue ![deepskyblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,191,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00BFFF)/rgb(0, 191, 255)
  Chalk get onDeepSkyBlue => makeRGBChalk(0, 191, 255, bg: true);

  /// set foreground color to X11/CSS color dimGray  ![dimgray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28105,105,105%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x696969)/rgb(105, 105, 105)
  Chalk get dimGray => makeRGBChalk(105, 105, 105);

  /// set background color to X11/CSS color dimGray ![dimgray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28105,105,105%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x696969)/rgb(105, 105, 105)
  Chalk get onDimGray => makeRGBChalk(105, 105, 105, bg: true);

  /// set foreground color to X11/CSS color dimGrey  ![dimgrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28105,105,105%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x696969)/rgb(105, 105, 105)
  Chalk get dimGrey => makeRGBChalk(105, 105, 105);

  /// set background color to X11/CSS color dimGrey ![dimgrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28105,105,105%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x696969)/rgb(105, 105, 105)
  Chalk get onDimGrey => makeRGBChalk(105, 105, 105, bg: true);

  /// set foreground color to X11/CSS color dodgerBlue  ![dodgerblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2830,144,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x1E90FF)/rgb(30, 144, 255)
  Chalk get dodgerBlue => makeRGBChalk(30, 144, 255);

  /// set background color to X11/CSS color dodgerBlue ![dodgerblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2830,144,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x1E90FF)/rgb(30, 144, 255)
  Chalk get onDodgerBlue => makeRGBChalk(30, 144, 255, bg: true);

  /// set foreground color to X11/CSS color fireBrick  ![firebrick](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28178,34,34%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xB22222)/rgb(178, 34, 34)
  Chalk get fireBrick => makeRGBChalk(178, 34, 34);

  /// set background color to X11/CSS color fireBrick ![firebrick](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28178,34,34%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xB22222)/rgb(178, 34, 34)
  Chalk get onFireBrick => makeRGBChalk(178, 34, 34, bg: true);

  /// set foreground color to X11/CSS color floralWhite  ![floralwhite](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,250,240%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFAF0)/rgb(255, 250, 240)
  Chalk get floralWhite => makeRGBChalk(255, 250, 240);

  /// set background color to X11/CSS color floralWhite ![floralwhite](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,250,240%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFAF0)/rgb(255, 250, 240)
  Chalk get onFloralWhite => makeRGBChalk(255, 250, 240, bg: true);

  /// set foreground color to X11/CSS color forestGreen  ![forestgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2834,139,34%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x228B22)/rgb(34, 139, 34)
  Chalk get forestGreen => makeRGBChalk(34, 139, 34);

  /// set background color to X11/CSS color forestGreen ![forestgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2834,139,34%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x228B22)/rgb(34, 139, 34)
  Chalk get onForestGreen => makeRGBChalk(34, 139, 34, bg: true);

  /// set foreground color to X11/CSS color fuchsia  ![fuchsia](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF00FF)/rgb(255, 0, 255)
  Chalk get fuchsia => makeRGBChalk(255, 0, 255);

  /// set background color to X11/CSS color fuchsia ![fuchsia](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF00FF)/rgb(255, 0, 255)
  Chalk get onFuchsia => makeRGBChalk(255, 0, 255, bg: true);

  /// set foreground color to X11/CSS color gainsboro  ![gainsboro](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28220,220,220%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDCDCDC)/rgb(220, 220, 220)
  Chalk get gainsboro => makeRGBChalk(220, 220, 220);

  /// set background color to X11/CSS color gainsboro ![gainsboro](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28220,220,220%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDCDCDC)/rgb(220, 220, 220)
  Chalk get onGainsboro => makeRGBChalk(220, 220, 220, bg: true);

  /// set foreground color to X11/CSS color ghostWhite  ![ghostwhite](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28248,248,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF8F8FF)/rgb(248, 248, 255)
  Chalk get ghostWhite => makeRGBChalk(248, 248, 255);

  /// set background color to X11/CSS color ghostWhite ![ghostwhite](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28248,248,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF8F8FF)/rgb(248, 248, 255)
  Chalk get onGhostWhite => makeRGBChalk(248, 248, 255, bg: true);

  /// set foreground color to X11/CSS color gold  ![gold](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,215,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFD700)/rgb(255, 215, 0)
  Chalk get gold => makeRGBChalk(255, 215, 0);

  /// set background color to X11/CSS color gold ![gold](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,215,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFD700)/rgb(255, 215, 0)
  Chalk get onGold => makeRGBChalk(255, 215, 0, bg: true);

  /// set foreground color to X11/CSS color goldenrod  ![goldenrod](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28218,165,32%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDAA520)/rgb(218, 165, 32)
  Chalk get goldenrod => makeRGBChalk(218, 165, 32);

  /// set background color to X11/CSS color goldenrod ![goldenrod](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28218,165,32%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDAA520)/rgb(218, 165, 32)
  Chalk get onGoldenrod => makeRGBChalk(218, 165, 32, bg: true);

  /// set foreground color to X11/CSS color grayX11  ![gray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x808080)/rgb(128, 128, 128)
  Chalk get grayX11 => makeRGBChalk(128, 128, 128);

  /// set background color to X11/CSS color grayX11 ![gray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x808080)/rgb(128, 128, 128)
  Chalk get onGrayX11 => makeRGBChalk(128, 128, 128, bg: true);

  /// set foreground color to X11/CSS color greenX11  ![green](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x008000)/rgb(0, 128, 0)
  Chalk get greenX11 => makeRGBChalk(0, 128, 0);

  /// set background color to X11/CSS color greenX11 ![green](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x008000)/rgb(0, 128, 0)
  Chalk get onGreenX11 => makeRGBChalk(0, 128, 0, bg: true);

  /// set foreground color to X11/CSS color greenYellow  ![greenyellow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28173,255,47%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xADFF2F)/rgb(173, 255, 47)
  Chalk get greenYellow => makeRGBChalk(173, 255, 47);

  /// set background color to X11/CSS color greenYellow ![greenyellow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28173,255,47%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xADFF2F)/rgb(173, 255, 47)
  Chalk get onGreenYellow => makeRGBChalk(173, 255, 47, bg: true);

  /// set foreground color to X11/CSS color greyX11  ![grey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x808080)/rgb(128, 128, 128)
  Chalk get greyX11 => makeRGBChalk(128, 128, 128);

  /// set background color to X11/CSS color greyX11 ![grey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x808080)/rgb(128, 128, 128)
  Chalk get onGreyX11 => makeRGBChalk(128, 128, 128, bg: true);

  /// set foreground color to X11/CSS color honeydew  ![honeydew](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,255,240%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF0FFF0)/rgb(240, 255, 240)
  Chalk get honeydew => makeRGBChalk(240, 255, 240);

  /// set background color to X11/CSS color honeydew ![honeydew](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,255,240%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF0FFF0)/rgb(240, 255, 240)
  Chalk get onHoneydew => makeRGBChalk(240, 255, 240, bg: true);

  /// set foreground color to X11/CSS color hotPink  ![hotpink](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,105,180%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF69B4)/rgb(255, 105, 180)
  Chalk get hotPink => makeRGBChalk(255, 105, 180);

  /// set background color to X11/CSS color hotPink ![hotpink](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,105,180%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF69B4)/rgb(255, 105, 180)
  Chalk get onHotPink => makeRGBChalk(255, 105, 180, bg: true);

  /// set foreground color to X11/CSS color indianRed  ![indianred](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28205,92,92%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xCD5C5C)/rgb(205, 92, 92)
  Chalk get indianRed => makeRGBChalk(205, 92, 92);

  /// set background color to X11/CSS color indianRed ![indianred](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28205,92,92%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xCD5C5C)/rgb(205, 92, 92)
  Chalk get onIndianRed => makeRGBChalk(205, 92, 92, bg: true);

  /// set foreground color to X11/CSS color indigo  ![indigo](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2875,0,130%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x4B0082)/rgb(75, 0, 130)
  Chalk get indigo => makeRGBChalk(75, 0, 130);

  /// set background color to X11/CSS color indigo ![indigo](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2875,0,130%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x4B0082)/rgb(75, 0, 130)
  Chalk get onIndigo => makeRGBChalk(75, 0, 130, bg: true);

  /// set foreground color to X11/CSS color ivory  ![ivory](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,240%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFFF0)/rgb(255, 255, 240)
  Chalk get ivory => makeRGBChalk(255, 255, 240);

  /// set background color to X11/CSS color ivory ![ivory](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,240%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFFF0)/rgb(255, 255, 240)
  Chalk get onIvory => makeRGBChalk(255, 255, 240, bg: true);

  /// set foreground color to X11/CSS color khaki  ![khaki](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,230,140%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF0E68C)/rgb(240, 230, 140)
  Chalk get khaki => makeRGBChalk(240, 230, 140);

  /// set background color to X11/CSS color khaki ![khaki](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,230,140%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF0E68C)/rgb(240, 230, 140)
  Chalk get onKhaki => makeRGBChalk(240, 230, 140, bg: true);

  /// set foreground color to X11/CSS color lavender  ![lavender](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28230,230,250%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xE6E6FA)/rgb(230, 230, 250)
  Chalk get lavender => makeRGBChalk(230, 230, 250);

  /// set background color to X11/CSS color lavender ![lavender](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28230,230,250%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xE6E6FA)/rgb(230, 230, 250)
  Chalk get onLavender => makeRGBChalk(230, 230, 250, bg: true);

  /// set foreground color to X11/CSS color lavenderBlush  ![lavenderblush](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,240,245%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFF0F5)/rgb(255, 240, 245)
  Chalk get lavenderBlush => makeRGBChalk(255, 240, 245);

  /// set background color to X11/CSS color lavenderBlush ![lavenderblush](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,240,245%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFF0F5)/rgb(255, 240, 245)
  Chalk get onLavenderBlush => makeRGBChalk(255, 240, 245, bg: true);

  /// set foreground color to X11/CSS color lawnGreen  ![lawngreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28124,252,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x7CFC00)/rgb(124, 252, 0)
  Chalk get lawnGreen => makeRGBChalk(124, 252, 0);

  /// set background color to X11/CSS color lawnGreen ![lawngreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28124,252,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x7CFC00)/rgb(124, 252, 0)
  Chalk get onLawnGreen => makeRGBChalk(124, 252, 0, bg: true);

  /// set foreground color to X11/CSS color lemonChiffon  ![lemonchiffon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,250,205%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFACD)/rgb(255, 250, 205)
  Chalk get lemonChiffon => makeRGBChalk(255, 250, 205);

  /// set background color to X11/CSS color lemonChiffon ![lemonchiffon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,250,205%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFACD)/rgb(255, 250, 205)
  Chalk get onLemonChiffon => makeRGBChalk(255, 250, 205, bg: true);

  /// set foreground color to X11/CSS color lightBlue  ![lightblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28173,216,230%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xADD8E6)/rgb(173, 216, 230)
  Chalk get lightBlue => makeRGBChalk(173, 216, 230);

  /// set background color to X11/CSS color lightBlue ![lightblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28173,216,230%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xADD8E6)/rgb(173, 216, 230)
  Chalk get onLightBlue => makeRGBChalk(173, 216, 230, bg: true);

  /// set foreground color to X11/CSS color lightCoral  ![lightcoral](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF08080)/rgb(240, 128, 128)
  Chalk get lightCoral => makeRGBChalk(240, 128, 128);

  /// set background color to X11/CSS color lightCoral ![lightcoral](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28240,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF08080)/rgb(240, 128, 128)
  Chalk get onLightCoral => makeRGBChalk(240, 128, 128, bg: true);

  /// set foreground color to X11/CSS color lightCyan  ![lightcyan](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28224,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xE0FFFF)/rgb(224, 255, 255)
  Chalk get lightCyan => makeRGBChalk(224, 255, 255);

  /// set background color to X11/CSS color lightCyan ![lightcyan](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28224,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xE0FFFF)/rgb(224, 255, 255)
  Chalk get onLightCyan => makeRGBChalk(224, 255, 255, bg: true);

  /// set foreground color to CSS color lightGoldenrodYellow  ![lightgoldenrodyellow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,250,210%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFAFAD2)/rgb(250, 250, 210)
  Chalk get lightGoldenrodYellow => makeRGBChalk(250, 250, 210);

  /// set background color to CSS color lightGoldenrodYellow ![lightgoldenrodyellow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,250,210%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFAFAD2)/rgb(250, 250, 210)
  Chalk get onLightGoldenrodYellow => makeRGBChalk(250, 250, 210, bg: true);

  /// set foreground color to X11 color lightGoldenrod  ![rgb(250, 250, 210)](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,250,210%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFAFAD2)/rgb(250, 250, 210)
  Chalk get lightGoldenrod => makeRGBChalk(250, 250, 210);

  /// set background color to X11 color lightGoldenrod ![rgb(250, 250, 210)](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,250,210%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFAFAD2)/rgb(250, 250, 210)
  Chalk get onLightGoldenrod => makeRGBChalk(250, 250, 210, bg: true);

  /// set foreground color to X11/CSS color lightGray  ![lightgray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28211,211,211%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD3D3D3)/rgb(211, 211, 211)
  Chalk get lightGray => makeRGBChalk(211, 211, 211);

  /// set background color to X11/CSS color lightGray ![lightgray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28211,211,211%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD3D3D3)/rgb(211, 211, 211)
  Chalk get onLightGray => makeRGBChalk(211, 211, 211, bg: true);

  /// set foreground color to X11/CSS color lightGreen  ![lightgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28144,238,144%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x90EE90)/rgb(144, 238, 144)
  Chalk get lightGreen => makeRGBChalk(144, 238, 144);

  /// set background color to X11/CSS color lightGreen ![lightgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28144,238,144%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x90EE90)/rgb(144, 238, 144)
  Chalk get onLightGreen => makeRGBChalk(144, 238, 144, bg: true);

  /// set foreground color to X11/CSS color lightGrey  ![lightgrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28211,211,211%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD3D3D3)/rgb(211, 211, 211)
  Chalk get lightGrey => makeRGBChalk(211, 211, 211);

  /// set background color to X11/CSS color lightGrey ![lightgrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28211,211,211%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD3D3D3)/rgb(211, 211, 211)
  Chalk get onLightGrey => makeRGBChalk(211, 211, 211, bg: true);

  /// set foreground color to X11/CSS color lightPink  ![lightpink](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,182,193%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFB6C1)/rgb(255, 182, 193)
  Chalk get lightPink => makeRGBChalk(255, 182, 193);

  /// set background color to X11/CSS color lightPink ![lightpink](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,182,193%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFB6C1)/rgb(255, 182, 193)
  Chalk get onLightPink => makeRGBChalk(255, 182, 193, bg: true);

  /// set foreground color to X11/CSS color lightSalmon  ![lightsalmon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,160,122%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFA07A)/rgb(255, 160, 122)
  Chalk get lightSalmon => makeRGBChalk(255, 160, 122);

  /// set background color to X11/CSS color lightSalmon ![lightsalmon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,160,122%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFA07A)/rgb(255, 160, 122)
  Chalk get onLightSalmon => makeRGBChalk(255, 160, 122, bg: true);

  /// set foreground color to X11/CSS color lightSeaGreen  ![lightseagreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2832,178,170%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x20B2AA)/rgb(32, 178, 170)
  Chalk get lightSeaGreen => makeRGBChalk(32, 178, 170);

  /// set background color to X11/CSS color lightSeaGreen ![lightseagreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2832,178,170%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x20B2AA)/rgb(32, 178, 170)
  Chalk get onLightSeaGreen => makeRGBChalk(32, 178, 170, bg: true);

  /// set foreground color to X11/CSS color lightSkyBlue  ![lightskyblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28135,206,250%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x87CEFA)/rgb(135, 206, 250)
  Chalk get lightSkyBlue => makeRGBChalk(135, 206, 250);

  /// set background color to X11/CSS color lightSkyBlue ![lightskyblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28135,206,250%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x87CEFA)/rgb(135, 206, 250)
  Chalk get onLightSkyBlue => makeRGBChalk(135, 206, 250, bg: true);

  /// set foreground color to X11/CSS color lightSlateGray  ![lightslategray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28119,136,153%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x778899)/rgb(119, 136, 153)
  Chalk get lightSlateGray => makeRGBChalk(119, 136, 153);

  /// set background color to X11/CSS color lightSlateGray ![lightslategray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28119,136,153%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x778899)/rgb(119, 136, 153)
  Chalk get onLightSlateGray => makeRGBChalk(119, 136, 153, bg: true);

  /// set foreground color to X11/CSS color lightSlateGrey  ![lightslategrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28119,136,153%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x778899)/rgb(119, 136, 153)
  Chalk get lightSlateGrey => makeRGBChalk(119, 136, 153);

  /// set background color to X11/CSS color lightSlateGrey ![lightslategrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28119,136,153%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x778899)/rgb(119, 136, 153)
  Chalk get onLightSlateGrey => makeRGBChalk(119, 136, 153, bg: true);

  /// set foreground color to X11/CSS color lightSteelBlue  ![lightsteelblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28176,196,222%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xB0C4DE)/rgb(176, 196, 222)
  Chalk get lightSteelBlue => makeRGBChalk(176, 196, 222);

  /// set background color to X11/CSS color lightSteelBlue ![lightsteelblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28176,196,222%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xB0C4DE)/rgb(176, 196, 222)
  Chalk get onLightSteelBlue => makeRGBChalk(176, 196, 222, bg: true);

  /// set foreground color to X11/CSS color lightYellow  ![lightyellow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,224%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFFE0)/rgb(255, 255, 224)
  Chalk get lightYellow => makeRGBChalk(255, 255, 224);

  /// set background color to X11/CSS color lightYellow ![lightyellow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,224%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFFE0)/rgb(255, 255, 224)
  Chalk get onLightYellow => makeRGBChalk(255, 255, 224, bg: true);

  /// set foreground color to X11/CSS color lime  ![lime](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FF00)/rgb(0, 255, 0)
  Chalk get lime => makeRGBChalk(0, 255, 0);

  /// set background color to X11/CSS color lime ![lime](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FF00)/rgb(0, 255, 0)
  Chalk get onLime => makeRGBChalk(0, 255, 0, bg: true);

  /// set foreground color to X11/CSS color limeGreen  ![limegreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2850,205,50%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x32CD32)/rgb(50, 205, 50)
  Chalk get limeGreen => makeRGBChalk(50, 205, 50);

  /// set background color to X11/CSS color limeGreen ![limegreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2850,205,50%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x32CD32)/rgb(50, 205, 50)
  Chalk get onLimeGreen => makeRGBChalk(50, 205, 50, bg: true);

  /// set foreground color to X11/CSS color linen  ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,240,230%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFAF0E6)/rgb(250, 240, 230)
  Chalk get linen => makeRGBChalk(250, 240, 230);

  /// set background color to X11/CSS color linen ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,240,230%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFAF0E6)/rgb(250, 240, 230)
  Chalk get onLinen => makeRGBChalk(250, 240, 230, bg: true);

  /// set foreground color to X11/CSS color magentaX11  ![magenta](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF00FF)/rgb(255, 0, 255)
  Chalk get magentaX11 => makeRGBChalk(255, 0, 255);

  /// set background color to X11/CSS color magentaX11 ![magenta](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF00FF)/rgb(255, 0, 255)
  Chalk get onMagentaX11 => makeRGBChalk(255, 0, 255, bg: true);

  /// set foreground color to X11/CSS color maroon  ![maroon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x800000)/rgb(128, 0, 0)
  Chalk get maroon => makeRGBChalk(128, 0, 0);

  /// set background color to X11/CSS color maroon ![maroon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x800000)/rgb(128, 0, 0)
  Chalk get onMaroon => makeRGBChalk(128, 0, 0, bg: true);

  /// set foreground color to X11/CSS color mediumAquamarine  ![mediumaquamarine](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28102,205,170%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x66CDAA)/rgb(102, 205, 170)
  Chalk get mediumAquamarine => makeRGBChalk(102, 205, 170);

  /// set background color to X11/CSS color mediumAquamarine ![mediumaquamarine](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28102,205,170%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x66CDAA)/rgb(102, 205, 170)
  Chalk get onMediumAquamarine => makeRGBChalk(102, 205, 170, bg: true);

  /// set foreground color to X11/CSS color mediumBlue  ![mediumblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,205%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x0000CD)/rgb(0, 0, 205)
  Chalk get mediumBlue => makeRGBChalk(0, 0, 205);

  /// set background color to X11/CSS color mediumBlue ![mediumblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,205%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x0000CD)/rgb(0, 0, 205)
  Chalk get onMediumBlue => makeRGBChalk(0, 0, 205, bg: true);

  /// set foreground color to X11/CSS color mediumOrchid  ![mediumorchid](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28186,85,211%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xBA55D3)/rgb(186, 85, 211)
  Chalk get mediumOrchid => makeRGBChalk(186, 85, 211);

  /// set background color to X11/CSS color mediumOrchid ![mediumorchid](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28186,85,211%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xBA55D3)/rgb(186, 85, 211)
  Chalk get onMediumOrchid => makeRGBChalk(186, 85, 211, bg: true);

  /// set foreground color to X11/CSS color mediumPurple  ![mediumpurple](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28147,112,219%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x9370DB)/rgb(147, 112, 219)
  Chalk get mediumPurple => makeRGBChalk(147, 112, 219);

  /// set background color to X11/CSS color mediumPurple ![mediumpurple](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28147,112,219%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x9370DB)/rgb(147, 112, 219)
  Chalk get onMediumPurple => makeRGBChalk(147, 112, 219, bg: true);

  /// set foreground color to X11/CSS color mediumSeaGreen  ![mediumseagreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2860,179,113%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x3CB371)/rgb(60, 179, 113)
  Chalk get mediumSeaGreen => makeRGBChalk(60, 179, 113);

  /// set background color to X11/CSS color mediumSeaGreen ![mediumseagreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2860,179,113%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x3CB371)/rgb(60, 179, 113)
  Chalk get onMediumSeaGreen => makeRGBChalk(60, 179, 113, bg: true);

  /// set foreground color to X11/CSS color mediumSlateBlue  ![mediumslateblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28123,104,238%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x7B68EE)/rgb(123, 104, 238)
  Chalk get mediumSlateBlue => makeRGBChalk(123, 104, 238);

  /// set background color to X11/CSS color mediumSlateBlue ![mediumslateblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28123,104,238%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x7B68EE)/rgb(123, 104, 238)
  Chalk get onMediumSlateBlue => makeRGBChalk(123, 104, 238, bg: true);

  /// set foreground color to X11/CSS color mediumSpringGreen  ![mediumspringgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,250,154%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FA9A)/rgb(0, 250, 154)
  Chalk get mediumSpringGreen => makeRGBChalk(0, 250, 154);

  /// set background color to X11/CSS color mediumSpringGreen ![mediumspringgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,250,154%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FA9A)/rgb(0, 250, 154)
  Chalk get onMediumSpringGreen => makeRGBChalk(0, 250, 154, bg: true);

  /// set foreground color to X11/CSS color mediumTurquoise  ![mediumturquoise](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2872,209,204%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x48D1CC)/rgb(72, 209, 204)
  Chalk get mediumTurquoise => makeRGBChalk(72, 209, 204);

  /// set background color to X11/CSS color mediumTurquoise ![mediumturquoise](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2872,209,204%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x48D1CC)/rgb(72, 209, 204)
  Chalk get onMediumTurquoise => makeRGBChalk(72, 209, 204, bg: true);

  /// set foreground color to X11/CSS color mediumVioletRed  ![mediumvioletred](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28199,21,133%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xC71585)/rgb(199, 21, 133)
  Chalk get mediumVioletRed => makeRGBChalk(199, 21, 133);

  /// set background color to X11/CSS color mediumVioletRed ![mediumvioletred](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28199,21,133%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xC71585)/rgb(199, 21, 133)
  Chalk get onMediumVioletRed => makeRGBChalk(199, 21, 133, bg: true);

  /// set foreground color to X11/CSS color midnightBlue  ![midnightblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2825,25,112%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x191970)/rgb(25, 25, 112)
  Chalk get midnightBlue => makeRGBChalk(25, 25, 112);

  /// set background color to X11/CSS color midnightBlue ![midnightblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2825,25,112%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x191970)/rgb(25, 25, 112)
  Chalk get onMidnightBlue => makeRGBChalk(25, 25, 112, bg: true);

  /// set foreground color to X11/CSS color mintCream  ![mintcream](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28245,255,250%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF5FFFA)/rgb(245, 255, 250)
  Chalk get mintCream => makeRGBChalk(245, 255, 250);

  /// set background color to X11/CSS color mintCream ![mintcream](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28245,255,250%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF5FFFA)/rgb(245, 255, 250)
  Chalk get onMintCream => makeRGBChalk(245, 255, 250, bg: true);

  /// set foreground color to X11/CSS color mistyRose  ![mistyrose](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,228,225%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFE4E1)/rgb(255, 228, 225)
  Chalk get mistyRose => makeRGBChalk(255, 228, 225);

  /// set background color to X11/CSS color mistyRose ![mistyrose](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,228,225%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFE4E1)/rgb(255, 228, 225)
  Chalk get onMistyRose => makeRGBChalk(255, 228, 225, bg: true);

  /// set foreground color to X11/CSS color moccasin  ![moccasin](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,228,181%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFE4B5)/rgb(255, 228, 181)
  Chalk get moccasin => makeRGBChalk(255, 228, 181);

  /// set background color to X11/CSS color moccasin ![moccasin](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,228,181%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFE4B5)/rgb(255, 228, 181)
  Chalk get onMoccasin => makeRGBChalk(255, 228, 181, bg: true);

  /// set foreground color to X11/CSS color navajoWhite  ![navajowhite](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,222,173%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFDEAD)/rgb(255, 222, 173)
  Chalk get navajoWhite => makeRGBChalk(255, 222, 173);

  /// set background color to X11/CSS color navajoWhite ![navajowhite](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,222,173%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFDEAD)/rgb(255, 222, 173)
  Chalk get onNavajoWhite => makeRGBChalk(255, 222, 173, bg: true);

  /// set foreground color to X11/CSS color navy  ![navy](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x000080)/rgb(0, 0, 128)
  Chalk get navy => makeRGBChalk(0, 0, 128);

  /// set background color to X11/CSS color navy ![navy](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x000080)/rgb(0, 0, 128)
  Chalk get onNavy => makeRGBChalk(0, 0, 128, bg: true);

  /// set foreground color to X11/CSS color oldLace  ![oldlace](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28253,245,230%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFDF5E6)/rgb(253, 245, 230)
  Chalk get oldLace => makeRGBChalk(253, 245, 230);

  /// set background color to X11/CSS color oldLace ![oldlace](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28253,245,230%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFDF5E6)/rgb(253, 245, 230)
  Chalk get onOldLace => makeRGBChalk(253, 245, 230, bg: true);

  /// set foreground color to X11/CSS color olive  ![olive](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x808000)/rgb(128, 128, 0)
  Chalk get olive => makeRGBChalk(128, 128, 0);

  /// set background color to X11/CSS color olive ![olive](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x808000)/rgb(128, 128, 0)
  Chalk get onOlive => makeRGBChalk(128, 128, 0, bg: true);

  /// set foreground color to X11/CSS color oliveDrab  ![olivedrab](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28107,142,35%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x6B8E23)/rgb(107, 142, 35)
  Chalk get oliveDrab => makeRGBChalk(107, 142, 35);

  /// set background color to X11/CSS color oliveDrab ![olivedrab](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28107,142,35%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x6B8E23)/rgb(107, 142, 35)
  Chalk get onOliveDrab => makeRGBChalk(107, 142, 35, bg: true);

  /// set foreground color to X11/CSS color orange  ![orange](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,165,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFA500)/rgb(255, 165, 0)
  Chalk get orange => makeRGBChalk(255, 165, 0);

  /// set background color to X11/CSS color orange ![orange](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,165,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFA500)/rgb(255, 165, 0)
  Chalk get onOrange => makeRGBChalk(255, 165, 0, bg: true);

  /// set foreground color to X11/CSS color orangeRed  ![orangered](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,69,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF4500)/rgb(255, 69, 0)
  Chalk get orangeRed => makeRGBChalk(255, 69, 0);

  /// set background color to X11/CSS color orangeRed ![orangered](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,69,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF4500)/rgb(255, 69, 0)
  Chalk get onOrangeRed => makeRGBChalk(255, 69, 0, bg: true);

  /// set foreground color to X11/CSS color orchid  ![orchid](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28218,112,214%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDA70D6)/rgb(218, 112, 214)
  Chalk get orchid => makeRGBChalk(218, 112, 214);

  /// set background color to X11/CSS color orchid ![orchid](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28218,112,214%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDA70D6)/rgb(218, 112, 214)
  Chalk get onOrchid => makeRGBChalk(218, 112, 214, bg: true);

  /// set foreground color to X11/CSS color paleGoldenrod  ![palegoldenrod](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28238,232,170%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xEEE8AA)/rgb(238, 232, 170)
  Chalk get paleGoldenrod => makeRGBChalk(238, 232, 170);

  /// set background color to X11/CSS color paleGoldenrod ![palegoldenrod](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28238,232,170%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xEEE8AA)/rgb(238, 232, 170)
  Chalk get onPaleGoldenrod => makeRGBChalk(238, 232, 170, bg: true);

  /// set foreground color to X11/CSS color paleGreen  ![palegreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28152,251,152%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x98FB98)/rgb(152, 251, 152)
  Chalk get paleGreen => makeRGBChalk(152, 251, 152);

  /// set background color to X11/CSS color paleGreen ![palegreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28152,251,152%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x98FB98)/rgb(152, 251, 152)
  Chalk get onPaleGreen => makeRGBChalk(152, 251, 152, bg: true);

  /// set foreground color to X11/CSS color paleTurquoise  ![paleturquoise](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28175,238,238%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xAFEEEE)/rgb(175, 238, 238)
  Chalk get paleTurquoise => makeRGBChalk(175, 238, 238);

  /// set background color to X11/CSS color paleTurquoise ![paleturquoise](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28175,238,238%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xAFEEEE)/rgb(175, 238, 238)
  Chalk get onPaleTurquoise => makeRGBChalk(175, 238, 238, bg: true);

  /// set foreground color to X11/CSS color paleVioletRed  ![palevioletred](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28219,112,147%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDB7093)/rgb(219, 112, 147)
  Chalk get paleVioletRed => makeRGBChalk(219, 112, 147);

  /// set background color to X11/CSS color paleVioletRed ![palevioletred](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28219,112,147%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDB7093)/rgb(219, 112, 147)
  Chalk get onPaleVioletRed => makeRGBChalk(219, 112, 147, bg: true);

  /// set foreground color to X11/CSS color papayaWhip  ![papayawhip](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,239,213%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFEFD5)/rgb(255, 239, 213)
  Chalk get papayaWhip => makeRGBChalk(255, 239, 213);

  /// set background color to X11/CSS color papayaWhip ![papayawhip](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,239,213%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFEFD5)/rgb(255, 239, 213)
  Chalk get onPapayaWhip => makeRGBChalk(255, 239, 213, bg: true);

  /// set foreground color to X11/CSS color peachPuff  ![peachpuff](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,218,185%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFDAB9)/rgb(255, 218, 185)
  Chalk get peachPuff => makeRGBChalk(255, 218, 185);

  /// set background color to X11/CSS color peachPuff ![peachpuff](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,218,185%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFDAB9)/rgb(255, 218, 185)
  Chalk get onPeachPuff => makeRGBChalk(255, 218, 185, bg: true);

  /// set foreground color to X11/CSS color peru  ![peru](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28205,133,63%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xCD853F)/rgb(205, 133, 63)
  Chalk get peru => makeRGBChalk(205, 133, 63);

  /// set background color to X11/CSS color peru ![peru](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28205,133,63%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xCD853F)/rgb(205, 133, 63)
  Chalk get onPeru => makeRGBChalk(205, 133, 63, bg: true);

  /// set foreground color to X11/CSS color pink  ![pink](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,192,203%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFC0CB)/rgb(255, 192, 203)
  Chalk get pink => makeRGBChalk(255, 192, 203);

  /// set background color to X11/CSS color pink ![pink](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,192,203%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFC0CB)/rgb(255, 192, 203)
  Chalk get onPink => makeRGBChalk(255, 192, 203, bg: true);

  /// set foreground color to X11/CSS color plum  ![plum](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28221,160,221%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDDA0DD)/rgb(221, 160, 221)
  Chalk get plum => makeRGBChalk(221, 160, 221);

  /// set background color to X11/CSS color plum ![plum](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28221,160,221%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xDDA0DD)/rgb(221, 160, 221)
  Chalk get onPlum => makeRGBChalk(221, 160, 221, bg: true);

  /// set foreground color to X11/CSS color powderBlue  ![powderblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28176,224,230%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xB0E0E6)/rgb(176, 224, 230)
  Chalk get powderBlue => makeRGBChalk(176, 224, 230);

  /// set background color to X11/CSS color powderBlue ![powderblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28176,224,230%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xB0E0E6)/rgb(176, 224, 230)
  Chalk get onPowderBlue => makeRGBChalk(176, 224, 230, bg: true);

  /// set foreground color to X11/CSS color purple  ![purple](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x800080)/rgb(128, 0, 128)
  Chalk get purple => makeRGBChalk(128, 0, 128);

  /// set background color to X11/CSS color purple ![purple](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x800080)/rgb(128, 0, 128)
  Chalk get onPurple => makeRGBChalk(128, 0, 128, bg: true);

  /// set foreground color to X11 color rebeccaPurple  ![rgb(102, 51, 153)](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28102,51,153%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x663399)/rgb(102, 51, 153)
  Chalk get rebeccaPurple => makeRGBChalk(102, 51, 153);

  /// set background color to X11 color rebeccaPurple ![rgb(102, 51, 153)](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28102,51,153%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x663399)/rgb(102, 51, 153)
  Chalk get onRebeccaPurple => makeRGBChalk(102, 51, 153, bg: true);

  /// set foreground color to X11/CSS color redX11  ![red](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF0000)/rgb(255, 0, 0)
  Chalk get redX11 => makeRGBChalk(255, 0, 0);

  /// set background color to X11/CSS color redX11 ![red](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF0000)/rgb(255, 0, 0)
  Chalk get onRedX11 => makeRGBChalk(255, 0, 0, bg: true);

  /// set foreground color to X11/CSS color rosyBrown  ![rosybrown](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28188,143,143%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xBC8F8F)/rgb(188, 143, 143)
  Chalk get rosyBrown => makeRGBChalk(188, 143, 143);

  /// set background color to X11/CSS color rosyBrown ![rosybrown](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28188,143,143%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xBC8F8F)/rgb(188, 143, 143)
  Chalk get onRosyBrown => makeRGBChalk(188, 143, 143, bg: true);

  /// set foreground color to X11/CSS color royalBlue  ![royalblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2865,105,225%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x4169E1)/rgb(65, 105, 225)
  Chalk get royalBlue => makeRGBChalk(65, 105, 225);

  /// set background color to X11/CSS color royalBlue ![royalblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2865,105,225%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x4169E1)/rgb(65, 105, 225)
  Chalk get onRoyalBlue => makeRGBChalk(65, 105, 225, bg: true);

  /// set foreground color to X11/CSS color saddleBrown  ![saddlebrown](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28139,69,19%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8B4513)/rgb(139, 69, 19)
  Chalk get saddleBrown => makeRGBChalk(139, 69, 19);

  /// set background color to X11/CSS color saddleBrown ![saddlebrown](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28139,69,19%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x8B4513)/rgb(139, 69, 19)
  Chalk get onSaddleBrown => makeRGBChalk(139, 69, 19, bg: true);

  /// set foreground color to X11/CSS color salmon  ![salmon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,128,114%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFA8072)/rgb(250, 128, 114)
  Chalk get salmon => makeRGBChalk(250, 128, 114);

  /// set background color to X11/CSS color salmon ![salmon](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28250,128,114%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFA8072)/rgb(250, 128, 114)
  Chalk get onSalmon => makeRGBChalk(250, 128, 114, bg: true);

  /// set foreground color to X11/CSS color sandyBrown  ![sandybrown](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28244,164,96%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF4A460)/rgb(244, 164, 96)
  Chalk get sandyBrown => makeRGBChalk(244, 164, 96);

  /// set background color to X11/CSS color sandyBrown ![sandybrown](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28244,164,96%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF4A460)/rgb(244, 164, 96)
  Chalk get onSandyBrown => makeRGBChalk(244, 164, 96, bg: true);

  /// set foreground color to X11/CSS color seaGreen  ![seagreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2846,139,87%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x2E8B57)/rgb(46, 139, 87)
  Chalk get seaGreen => makeRGBChalk(46, 139, 87);

  /// set background color to X11/CSS color seaGreen ![seagreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2846,139,87%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x2E8B57)/rgb(46, 139, 87)
  Chalk get onSeaGreen => makeRGBChalk(46, 139, 87, bg: true);

  /// set foreground color to X11/CSS color seashell  ![seashell](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,245,238%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFF5EE)/rgb(255, 245, 238)
  Chalk get seashell => makeRGBChalk(255, 245, 238);

  /// set background color to X11/CSS color seashell ![seashell](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,245,238%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFF5EE)/rgb(255, 245, 238)
  Chalk get onSeashell => makeRGBChalk(255, 245, 238, bg: true);

  /// set foreground color to X11/CSS color sienna  ![sienna](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28160,82,45%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xA0522D)/rgb(160, 82, 45)
  Chalk get sienna => makeRGBChalk(160, 82, 45);

  /// set background color to X11/CSS color sienna ![sienna](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28160,82,45%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xA0522D)/rgb(160, 82, 45)
  Chalk get onSienna => makeRGBChalk(160, 82, 45, bg: true);

  /// set foreground color to X11/CSS color silver  ![silver](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xC0C0C0)/rgb(192, 192, 192)
  Chalk get silver => makeRGBChalk(192, 192, 192);

  /// set background color to X11/CSS color silver ![silver](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xC0C0C0)/rgb(192, 192, 192)
  Chalk get onSilver => makeRGBChalk(192, 192, 192, bg: true);

  /// set foreground color to X11/CSS color skyBlue  ![skyblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28135,206,235%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x87CEEB)/rgb(135, 206, 235)
  Chalk get skyBlue => makeRGBChalk(135, 206, 235);

  /// set background color to X11/CSS color skyBlue ![skyblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28135,206,235%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x87CEEB)/rgb(135, 206, 235)
  Chalk get onSkyBlue => makeRGBChalk(135, 206, 235, bg: true);

  /// set foreground color to X11/CSS color slateBlue  ![slateblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28106,90,205%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x6A5ACD)/rgb(106, 90, 205)
  Chalk get slateBlue => makeRGBChalk(106, 90, 205);

  /// set background color to X11/CSS color slateBlue ![slateblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28106,90,205%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x6A5ACD)/rgb(106, 90, 205)
  Chalk get onSlateBlue => makeRGBChalk(106, 90, 205, bg: true);

  /// set foreground color to X11/CSS color slateGray  ![slategray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28112,128,144%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x708090)/rgb(112, 128, 144)
  Chalk get slateGray => makeRGBChalk(112, 128, 144);

  /// set background color to X11/CSS color slateGray ![slategray](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28112,128,144%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x708090)/rgb(112, 128, 144)
  Chalk get onSlateGray => makeRGBChalk(112, 128, 144, bg: true);

  /// set foreground color to X11/CSS color slateGrey  ![slategrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28112,128,144%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x708090)/rgb(112, 128, 144)
  Chalk get slateGrey => makeRGBChalk(112, 128, 144);

  /// set background color to X11/CSS color slateGrey ![slategrey](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28112,128,144%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x708090)/rgb(112, 128, 144)
  Chalk get onSlateGrey => makeRGBChalk(112, 128, 144, bg: true);

  /// set foreground color to X11/CSS color snow  ![snow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,250,250%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFAFA)/rgb(255, 250, 250)
  Chalk get snow => makeRGBChalk(255, 250, 250);

  /// set background color to X11/CSS color snow ![snow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,250,250%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFAFA)/rgb(255, 250, 250)
  Chalk get onSnow => makeRGBChalk(255, 250, 250, bg: true);

  /// set foreground color to X11/CSS color springGreen  ![springgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,127%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FF7F)/rgb(0, 255, 127)
  Chalk get springGreen => makeRGBChalk(0, 255, 127);

  /// set background color to X11/CSS color springGreen ![springgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,127%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x00FF7F)/rgb(0, 255, 127)
  Chalk get onSpringGreen => makeRGBChalk(0, 255, 127, bg: true);

  /// set foreground color to X11/CSS color steelBlue  ![steelblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2870,130,180%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x4682B4)/rgb(70, 130, 180)
  Chalk get steelBlue => makeRGBChalk(70, 130, 180);

  /// set background color to X11/CSS color steelBlue ![steelblue](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2870,130,180%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x4682B4)/rgb(70, 130, 180)
  Chalk get onSteelBlue => makeRGBChalk(70, 130, 180, bg: true);

  /// set foreground color to X11/CSS color tan  ![tan](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28210,180,140%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD2B48C)/rgb(210, 180, 140)
  Chalk get tan => makeRGBChalk(210, 180, 140);

  /// set background color to X11/CSS color tan ![tan](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28210,180,140%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD2B48C)/rgb(210, 180, 140)
  Chalk get onTan => makeRGBChalk(210, 180, 140, bg: true);

  /// set foreground color to X11/CSS color teal  ![teal](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x008080)/rgb(0, 128, 128)
  Chalk get teal => makeRGBChalk(0, 128, 128);

  /// set background color to X11/CSS color teal ![teal](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x008080)/rgb(0, 128, 128)
  Chalk get onTeal => makeRGBChalk(0, 128, 128, bg: true);

  /// set foreground color to X11/CSS color thistle  ![thistle](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28216,191,216%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD8BFD8)/rgb(216, 191, 216)
  Chalk get thistle => makeRGBChalk(216, 191, 216);

  /// set background color to X11/CSS color thistle ![thistle](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28216,191,216%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xD8BFD8)/rgb(216, 191, 216)
  Chalk get onThistle => makeRGBChalk(216, 191, 216, bg: true);

  /// set foreground color to X11/CSS color tomato  ![tomato](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,99,71%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF6347)/rgb(255, 99, 71)
  Chalk get tomato => makeRGBChalk(255, 99, 71);

  /// set background color to X11/CSS color tomato ![tomato](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,99,71%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFF6347)/rgb(255, 99, 71)
  Chalk get onTomato => makeRGBChalk(255, 99, 71, bg: true);

  /// set foreground color to X11/CSS color turquoise  ![turquoise](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2864,224,208%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x40E0D0)/rgb(64, 224, 208)
  Chalk get turquoise => makeRGBChalk(64, 224, 208);

  /// set background color to X11/CSS color turquoise ![turquoise](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%2864,224,208%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x40E0D0)/rgb(64, 224, 208)
  Chalk get onTurquoise => makeRGBChalk(64, 224, 208, bg: true);

  /// set foreground color to X11/CSS color violet  ![violet](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28238,130,238%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xEE82EE)/rgb(238, 130, 238)
  Chalk get violet => makeRGBChalk(238, 130, 238);

  /// set background color to X11/CSS color violet ![violet](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28238,130,238%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xEE82EE)/rgb(238, 130, 238)
  Chalk get onViolet => makeRGBChalk(238, 130, 238, bg: true);

  /// set foreground color to X11/CSS color wheat  ![wheat](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28245,222,179%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF5DEB3)/rgb(245, 222, 179)
  Chalk get wheat => makeRGBChalk(245, 222, 179);

  /// set background color to X11/CSS color wheat ![wheat](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28245,222,179%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF5DEB3)/rgb(245, 222, 179)
  Chalk get onWheat => makeRGBChalk(245, 222, 179, bg: true);

  /// set foreground color to X11/CSS color whiteX11  ![white](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFFFF)/rgb(255, 255, 255)
  Chalk get whiteX11 => makeRGBChalk(255, 255, 255);

  /// set background color to X11/CSS color whiteX11 ![white](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFFFF)/rgb(255, 255, 255)
  Chalk get onWhiteX11 => makeRGBChalk(255, 255, 255, bg: true);

  /// set foreground color to X11/CSS color whiteSmoke  ![whitesmoke](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28245,245,245%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF5F5F5)/rgb(245, 245, 245)
  Chalk get whiteSmoke => makeRGBChalk(245, 245, 245);

  /// set background color to X11/CSS color whiteSmoke ![whitesmoke](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28245,245,245%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xF5F5F5)/rgb(245, 245, 245)
  Chalk get onWhiteSmoke => makeRGBChalk(245, 245, 245, bg: true);

  /// set foreground color to X11/CSS color yellowX11  ![yellow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFF00)/rgb(255, 255, 0)
  Chalk get yellowX11 => makeRGBChalk(255, 255, 0);

  /// set background color to X11/CSS color yellowX11 ![yellow](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0xFFFF00)/rgb(255, 255, 0)
  Chalk get onYellowX11 => makeRGBChalk(255, 255, 0, bg: true);

  /// set foreground color to X11/CSS color yellowGreen  ![yellowgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28154,205,50%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x9ACD32)/rgb(154, 205, 50)
  Chalk get yellowGreen => makeRGBChalk(154, 205, 50);

  /// set background color to X11/CSS color yellowGreen ![yellowgreen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28154,205,50%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32) (0x9ACD32)/rgb(154, 205, 50)
  Chalk get onYellowGreen => makeRGBChalk(154, 205, 50, bg: true);
}

// END GENERATED CODE - DO NOT MODIFY BY HAND - generating code => /examples/makeX11EntryPoints.dart

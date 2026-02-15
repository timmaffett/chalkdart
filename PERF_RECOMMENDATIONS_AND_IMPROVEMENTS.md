# ChalkDart Performance Guide

Practical advice for getting the best performance out of ChalkDart, based on
extensive micro-benchmarking of every major code path.

---

## Three Ways to Style Text

ChalkDart gives you three approaches. Each has different performance
characteristics:

```dart
import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalkstrings.dart';

final c = Chalk();

// 1. String extension — convenient, great for 1-4 styles
'hello'.red.bold

// 2. Chalk API — build a chain, apply once
c.red.bold('hello')

// 3. Pre-built Chalk — fastest for repeated use
final errorStyle = c.red.bold;
errorStyle('something went wrong')
```

## Quick Recommendations

| Situation | Best approach | Example |
|---|---|---|
| Simple coloring | String extension | `message.green` |
| Color + 1-2 modifiers | String extension | `msg.red.bold` |
| 5+ styles on one string | Chalk API | `c.red.onBlue.bold.italic.underline(text)` |
| Long strings with 3+ styles | Chalk API or pre-built | `c.red.bold.italic(longText)` |
| Same style applied in a loop | Pre-built Chalk | `final err = c.red.bold;` then `err(msg)` |
| Composite lines (mixed styles) | String extension | `'${label.bold} ${value.green}'` |

---

## Performance by Approach

### String Extensions — Best for Everyday Use

String extensions like `'text'.red.bold` are the most readable and, for
typical usage (short strings, 1-4 styles), also the fastest option:

| Operation | Time | Throughput |
|---|---|---|
| `'text'.red` | ~0.28µs | 3.6M ops/sec |
| `'text'.red.bold` | ~0.79µs | 1.3M ops/sec |
| `'text'.red.bold.italic` | ~1.39µs | 720K ops/sec |
| `'text'.red.onYellow.bold.italic` | ~2.0µs | 500K ops/sec |

For a single style, the string extension is **2-4x faster** than the equivalent
Chalk API call because cached Chalk instances are reused internally.

### Chalk API — Best for Deep Chains and Long Strings

The Chalk API builds up all styles into one object, then applies them in a
single pass. This matters when you have many styles or long strings:

| Operation | Time | Throughput |
|---|---|---|
| `c.red('text')` | ~0.70µs | 1.4M ops/sec |
| `c.red.bold('text')` | ~1.49µs | 670K ops/sec |
| `c.red.bold.italic('text')` | ~2.25µs | 440K ops/sec |
| `c.red.bold.italic.underline.dim('text')` | ~3.12µs | 320K ops/sec |

### Pre-built Chalk — Best for Hot Paths and Loops

Store a styled Chalk in a variable and reuse it. The call cost is constant
regardless of how many styles are baked in:

| Operation | Time | Throughput |
|---|---|---|
| `preRed('text')` — 1 style | ~0.29µs | 3.4M ops/sec |
| `preRedBold('text')` — 2 styles | ~0.35µs | 2.9M ops/sec |
| `preRedBoldItalic('text')` — 3 styles | ~0.34µs | 2.9M ops/sec |
| `preRBIUD('text')` — 5 styles | ~0.30µs | 3.4M ops/sec |

Pre-built Chalks are **3-11x faster** than building the chain each time.

---

## When String Length Matters

For short strings (under ~100 characters), the approach you choose barely
matters. But for longer strings with chained styles, the difference is dramatic:

| Scenario | String Extension | Chalk API |
|---|---|---|
| Short (11 chars), 1 style | **0.34µs** | 1.01µs |
| Short (11 chars), 3 styles | **1.69µs** | 2.62µs |
| Medium (135 chars), 3 styles | 4.47µs | **3.39µs** |
| Long (1K chars), 1 style | **9.40µs** | 10.64µs |
| Long (1K chars), 3 styles | 58.55µs | **14.71µs** |

**Why the divergence?** String extension chains wrap the text at each step.
With `longText.red.bold.italic`, the `.bold` step has to process the
already-red-styled long string, and `.italic` processes the red+bold styled
string. Each step scans the full string for escape codes. The Chalk API
applies all three styles in one pass over the original text.

**Rule of thumb:** If your string is longer than ~100 characters and you're
applying 3+ styles, prefer `c.red.bold.italic(longText)` over
`longText.red.bold.italic`.

---

## Realistic Patterns — Benchmarked

These benchmarks simulate common real-world usage:

| Pattern | String Extension | Chalk API | Pre-built |
|---|---|---|---|
| Log line (`msg.green`) | **0.58µs** | 1.23µs | 0.54µs |
| Error message (`msg.red.bold`) | **1.36µs** | 1.97µs | **0.52µs** |
| Table header (`hdr.white.onBlue.bold`) | 2.84µs | 2.77µs | **0.58µs** |
| Composite (`"${label.bold} ${value.green}"`) | **1.10µs** | 2.56µs | — |
| Loop over 10 items (`.red`) | **5.56µs** | 14.62µs | 5.27µs |

For one-off styling, string extensions are both fast and readable. For
styling inside tight loops, pre-built Chalks are the way to go.

---

## Tips for Performance-Sensitive Code

### 1. Pre-build styles you reuse

```dart
// Do this once at startup
final error = Chalk().red.bold;
final success = Chalk().green;
final highlight = Chalk().yellow.onBlue.bold;

// Then use throughout your app — each call is ~0.3-0.5µs
print(error('Connection failed'));
print(success('All tests passed'));
print(highlight('IMPORTANT'));
```

### 2. Avoid re-creating Chalk instances

```dart
// Slower — creates a new Chalk() every iteration
for (final item in items) {
  print(Chalk().red(item));     // ~0.7µs per item
}

// Faster — reuse the Chalk
final red = Chalk().red;
for (final item in items) {
  print(red(item));             // ~0.3µs per item
}

// Also fast — string extension caches internally
for (final item in items) {
  print(item.red);              // ~0.3µs per item
}
```

### 3. For long strings with multiple styles, use the Chalk API

```dart
final longReport = generateReport();  // 1000+ characters

// Slower — each step processes the growing styled string
print(longReport.red.bold.italic);              // ~58µs for 1K chars

// Faster — all styles applied in one pass
print(Chalk().red.bold.italic(longReport));     // ~15µs for 1K chars

// Fastest — pre-built
final style = Chalk().red.bold.italic;
print(style(longReport));                       // ~14µs for 1K chars
```

### 4. Multi-line text is well-optimized

ChalkDart wraps each line individually so that styles survive line breaks
in terminals. This is handled efficiently with StringBuffer-based processing:

| Lines | Time |
|---|---|
| 10 lines | ~1.9µs |
| 100 lines | ~17µs |
| 1,000 lines | ~131µs |

Scaling is linear — no performance cliff on large multi-line output.

---

## Color Method Performance

Named colors and basic modifiers are the fastest. Parameterized color methods
(RGB, hex, HSL, etc.) add conversion overhead:

| Method | Time | Notes |
|---|---|---|
| `c.red('text')` | ~0.70µs | Named color — fastest |
| `c.ansi256(196)('text')` | ~0.69µs | Direct ANSI code — fast |
| `c.keyword('tomato')('text')` | ~1.11µs | Map lookup + conversion |
| `c.hsl(120, 50, 50)('text')` | ~0.96µs | HSL → RGB → ANSI conversion |
| `c.rgb(255, 100, 50)('text')` | ~1.41µs | RGB → ANSI conversion |
| `c.hex('#FF6432')('text')` | ~1.50µs | Hex parse + RGB → ANSI |
| `c.hex(0xFF6432)('text')` | ~0.84µs | Int hex — no string parsing |

**Tip:** If you use `hex()`, prefer integer literals (`0xFF6432`) over strings
(`'#FF6432'`) — it skips the string parsing step and is nearly 2x faster.

---

## Strip Operations

Stripping ANSI codes (e.g. for length calculation or logging to files) uses
optimized regex processing with an early-exit guard for plain text:

| Operation | Time |
|---|---|
| `stripAnsi` on plain text (no codes) | ~0.06µs |
| `hasAnsi` check (positive) | ~0.12µs |
| `stripAnsi` on short styled text | ~0.62µs |
| `stripAnsi` on medium styled text | ~2.6µs |
| `lengthWithoutAnsi` on short styled text | ~0.58µs |

Plain text passes through `stripAnsi` almost instantly (~0.06µs) thanks to
an early `hasAnsi` guard — no regex replacement is performed.

---

## Version 3.1.0 Performance Improvements

The benchmarks above reflect significant internal optimizations:

- **Chalk getter chains** are 4-6x faster — child Chalk instances now inherit
  pre-computed state from their parent instead of recomputing it
- **String extension getters** are 7-10x faster — cached Chalk instances are
  reused across calls instead of being created and discarded each time
- **X11/CSS string extension getters** are 3-4x faster — all 298 X11 color
  getters now use a list-based cache (`List<Chalk?>`) with integer indices,
  bringing them to parity with base16 cached getters (~0.45µs vs ~0.37µs)
- **Multi-line text** is 4-6x faster — internal string building uses
  StringBuffer instead of concatenation
- **ANSI code generation** is faster — frequently used SGR escape strings
  are cached and reused
- **Strip on plain text** is near-instant — early-exit guard skips regex
  when no ANSI codes are present


## Performance optimization release — significant speed improvements across all major code paths.
  ### String Extension Getters — 7-10x faster
  - Cached Chalk instances are now lazily created and reused across calls
    instead of being allocated and discarded on every use
  - `'text'.red`: ~1.6µs → ~0.15µs
  - `'text'.red.bold` (chain of 2): ~3.2µs → ~0.38µs
  - `'text'.red.bold.italic.underline` (chain of 4): ~6.4µs → ~0.85µs
  - Cache is properly invalidated when `reInitializeChalkStringExtensionChalkInstance()` is called

  ### X11/CSS String Extension Getters — 3-4x faster
  - All 298 X11/CSS color getters (149 foreground + 149 background) now use a
    list-based cache (`List<Chalk?>.filled(298, null)`) with integer indices
  - `'text'.cornflowerBlue`: ~1.60µs → ~0.45µs
  - `'text'.tomato`: ~1.60µs → ~0.45µs
  - `'text'.onCornflowerBlue`: ~1.60µs → ~0.47µs
  - Now on par with base16 cached getters (~0.37µs)
  - Cache is reset alongside base16 cache via `ChalkX11Strings.resetCache()`

  ### Chalk Getter Chains — 4-6x faster
  - Child Chalk instances now inherit pre-computed wrapper functions and close
    strings from their parent, skipping the expensive `_setAllWrapperFunctionsAccordingToMode()` call
  - `c.red` getter: ~1.25µs → ~0.21µs
  - `c.red('text')` getter+call: ~1.61µs → ~0.40µs

  ### ANSI SGR Code Generation — cached
  - Static cache for frequently used SGR escape strings (`\x1B[Nm`)
    eliminates repeated string interpolation
  - Cache auto-invalidates if the ESC sequence changes (e.g. xcodeSafeEsc mode)

  ### Multi-line Text Processing — 4-6x faster
  - `stringReplaceAll` and `stringEncaseCRLFWithFirstIndex` now use
    StringBuffer instead of O(n²) string concatenation
  - 1,000 lines: ~754µs → ~131µs

  ### Hex Color Parsing — 13x faster
  - `hex2rgb('#FF6432')` rewritten with direct charcode math instead of
    regex + split/map/join + int.parse
  - String hex: ~0.26µs → ~0.02µs (now matches integer hex speed)
  - `hex(0xFF6432)` integer path unchanged at ~0.02µs

  ### Other
  - Added `PERF_RECOMMENDATIONS_AND_IMPROVEMENTS.md` with practical performance
    guidance for library users
  - Added comprehensive performance benchmark suite under `test/perf_*.dart`
  - Expanded test coverage from 493 to 515 tests
class TextCleaner {
  /// Regular expression to match standard cosmetic ingredient block header prefixes.
  /// Matches "INGREDIENTES:", "INGREDIENTS:", "COMPOSIÇÃO:", "FÓRMULA:", etc.
  static final RegExp _headerRegex = RegExp(
    r'(?:^|[\r\n\s])(?:INGREDIENTES|INGREDIENTS|COMPOSIÇÃO|COMPOSICAO|FÓRMULA|FORMULA)\s*(?:\([^\)]*\))?\s*[:\-\.]?\s*',
    caseSensitive: false,
  );

  /// Sections that typically mark the end of the primary INCI ingredient list.
  static final RegExp _trailingSectionRegex = RegExp(
    r'(?:[\r\n\s]+)(?:INGREDIENTES\s*\((?:PORTUGUÊS|PORTUGUES)\)|COMPOSIÇÃO\s*\((?:PORTUGUÊS|PORTUGUES)\)|MODO\s+DE\s+(?:USO|USAR)|PRECAUÇÕES|PRECAUCOES|ADVERTÊNCIAS|ADVERTENCIAS|FABRICADO\s+POR|PRODUZIDO\s+POR|DISTRIBUÍDO\s+POR|DISTRIBUIDO\s+POR|SAC|LOTE|VALIDADE|VAL\.)',
    caseSensitive: false,
  );

  /// Pattern to detect the end period of the ingredient list (avoiding decimals like 1.2-hexanediol).
  static final RegExp _endPeriodRegex = RegExp(r'\.(?:\s+|$)');

  /// Extracts exclusively the ingredients portion from raw OCR text.
  /// Scans for anchors such as "INGREDIENTES:", "COMPOSIÇÃO:" and isolates up to
  /// the terminating period (.) or the next label section.
  /// If no ingredient header is detected, safely preserves the raw text.
  static String extractIngredientsBlock(String raw) {
    if (raw.trim().isEmpty) return '';

    // 1. Locate ingredient header anchor
    final headerMatch = _headerRegex.firstMatch(raw);
    if (headerMatch == null) {
      // Fallback: user cropped specifically the ingredient list without headers
      return raw.trim();
    }

    // Extract text after the header
    var candidate = raw.substring(headerMatch.end).trim();

    // 2. Terminate before any subsequent label section
    final sectionMatch = _trailingSectionRegex.firstMatch(candidate);
    if (sectionMatch != null) {
      candidate = candidate.substring(0, sectionMatch.start).trim();
    }

    // 3. Terminate at the sentence-ending period (.)
    final periodMatch = _endPeriodRegex.firstMatch(candidate);
    if (periodMatch != null) {
      candidate = candidate.substring(0, periodMatch.start + 1).trim();
    }

    return candidate;
  }

  /// Cleans OCR text output by isolating the ingredient block (if present),
  /// normalizing line breaks, removing control characters, and preserving
  /// punctuation relevant to cosmetics ingredients (commas, slashes, semicolons).
  static String clean(String raw) {
    if (raw.trim().isEmpty) return '';

    // First, isolate the ingredient block
    var cleaned = extractIngredientsBlock(raw);

    // Remove non-printable control characters (except common whitespace)
    cleaned = cleaned.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F\uFFFD]'), ' ');

    // Normalize Windows CRLF and CR to simple spaces if within words, or keep commas
    cleaned = cleaned.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // Replace line breaks with a single space to combine wrapped lines
    cleaned = cleaned.replaceAll('\n', ' ');

    // Collapse multiple consecutive spaces to a single space
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ');

    // Normalize spacing around slashes and commas
    cleaned = cleaned.replaceAll(RegExp(r'\s*/\s*'), ' / ');
    cleaned = cleaned.replaceAll(RegExp(r'\s*,\s*'), ', ');

    return cleaned.trim();
  }
}

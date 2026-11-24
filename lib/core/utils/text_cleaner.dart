class TextCleaner {
  /// Cleans OCR text output by normalizing line breaks, removing control characters,
  /// and preserving punctuation relevant to cosmetics ingredients (commas, slashes, semicolons).
  static String clean(String raw) {
    if (raw.trim().isEmpty) return '';

    // Remove non-printable control characters (except common whitespace)
    var cleaned = raw.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F\uFFFD]'), ' ');

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

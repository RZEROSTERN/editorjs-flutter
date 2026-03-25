class StyleConfig {
  final List<CssTagConfig> cssTags;
  final String? defaultFont;

  const StyleConfig({
    required this.cssTags,
    this.defaultFont,
  });
}

class CssTagConfig {
  final String tag;
  final String? backgroundColor;
  final String? color;
  final double? padding;

  const CssTagConfig({
    required this.tag,
    this.backgroundColor,
    this.color,
    this.padding,
  });
}

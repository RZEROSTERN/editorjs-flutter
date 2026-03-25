## [0.2.1] - 2026-03-25 — Viewer completeness: embed, linkTool, attaches, raw

### New block types (viewer only)
* `embed` — tappable card showing service name, source URL, and optional caption; opens URL via `url_launcher`.
* `linkTool` — link preview card with thumbnail, title, description, and URL; opens link via `url_launcher`.
* `attaches` — file download card with type-specific icon, file size, and `url_launcher` download action.
* `raw` — raw HTML content rendered through `flutter_html` with full `HtmlSanitizer` protection.

### Cross-cutting renderer improvements
* Extracted `HtmlStyleBuilder` shared utility — applies `defaultFont` to `flutter_html` `body` style and all CSS tag overrides, eliminating duplicate helpers across renderers.
* Applied `HtmlSanitizer.sanitize()` to `QuoteRenderer` and `ListRenderer` (HTML content fields).
* `ImageRenderer` caption now respects `styleConfig.defaultFont`.

### Exports
* All four new block entity classes (`EmbedBlock`, `LinkToolBlock`, `AttachesBlock`, `RawBlock`) exported from the public barrel file.

---

## [0.2.0] - 2026-03-25 — Phase 2: Viewer & editor completeness

### New block types (viewer + editor)
* `quote` — blockquote with optional caption and left/center/right alignment.
* `code` — monospace code block with horizontal scroll, selectable text, and a copy-to-clipboard button.
* `checklist` — checkbox list with checked/unchecked state; strikethrough rendered on checked items.
* `table` — 2-D table with optional heading row, horizontal scroll, and add/remove row & column controls in the editor.
* `warning` — highlighted alert box with title and message fields.

### Nested list support
* `ListBlock` items are now `ListItem` objects with a recursive `items` field.
* `ListMapper` handles both flat string items (`@editorjs/list`) and nested object items (`@editorjs/nested-list`) transparently.
* `ListRenderer` renders nested items with indentation per depth level.

### HTML sanitization
* Added `HtmlSanitizer` utility in the data layer that strips `<script>`, `<iframe>`, and `on*` event handler attributes before passing HTML to `flutter_html`.
* Applied in `ParagraphRenderer` and will apply to any renderer that calls `HtmlSanitizer.sanitize()`.

### Toolbar
* Added toolbar buttons for all new block types: Quote, Code, Checklist, Table, Warning.

### Exports
* All five new block entity classes are exported from the public barrel file.

---

## [0.1.0] - 2026-03-25 — Clean Architecture refactor (breaking)

This release is a full architectural rewrite. The public API has changed.
See the migration notes below.

### Breaking changes
* `EditorJSView` parameter renamed: `editorJSData` → `jsonData`, `styles` → `config` (accepts `EditorConfig`).
* `EditorJSEditor` now requires an `EditorController` passed via `controller:`.
* Old `src/model/` and `src/widgets/` packages removed entirely.

### Architecture
* Adopted Clean Architecture with three strict layers: `domain`, `data`, `presentation`. Dependencies flow inward only; `domain` has zero Flutter imports.
* Applied SOLID principles throughout: one class per block type (SRP), block registry for extensibility without modifying core files (OCP), all renderers/editors implement typed abstract bases (LSP/DIP).
* New block type registry pattern: register custom block types at runtime via `BlockTypeRegistry` and `BlockRendererRegistry` without touching any package file.

### New: `EditorController`
* Replaces the previous `List<Widget>` anti-pattern in the editor.
* Holds `List<BlockEntity>` as the source of truth.
* Exposes `getContent()` → EditorJS-compliant JSON string (previously impossible).
* Zero-arg factory `EditorController()` wires the default serializer automatically.
* Full block management API: `addBlock`, `insertBlock`, `updateBlock`, `removeBlock`, `moveBlock`, `clear`.

### New: domain entities
* `BlockEntity` — abstract base class for all block types.
* `BlockDocument` — root document entity with full `toJson()` serialization.
* `StyleConfig` / `CssTagConfig` — styling configuration entities replacing old JSON-only models.
* Typed block entities: `HeaderBlock`, `ParagraphBlock`, `ListBlock`, `DelimiterBlock`, `ImageBlock` — each owns only its relevant fields and serializes itself.

### New: data layer
* `BlockMapper<T>` — abstract interface for deserializing a block type from EditorJS JSON.
* Five concrete mappers (`HeaderMapper`, `ParagraphMapper`, `ListMapper`, `DelimiterMapper`, `ImageMapper`) with safe, non-throwing parsing.
* `BlockTypeRegistry` — pre-registered with all built-in mappers; callers call `.register()` for custom blocks.
* `JsonDocumentSource` — implements `DocumentRepository`; unknown block types are silently skipped (never throws on unrecognized data).

### New: presentation layer
* `BlockRenderer<T>` / `BlockEditor<T>` — abstract base widgets for custom block authors.
* `BlockRendererRegistry` — maps type strings to renderer/editor builder functions.
* `EditorConfig` — single configuration object accepted by both `EditorJSView` and `EditorJSEditor`.
* Five renderer widgets: fully stateless, receive an immutable entity.
* Five editor widgets: push updates upward via `ValueChanged<T>` callback; no direct parent coupling.
* `EditorJSToolbar` — decoupled from editor widget; communicates exclusively through `EditorController`.
* Image renderer now respects `caption`, `withBorder`, `stretched`, and `withBackground` fields.
* Image load errors show a placeholder widget instead of crashing.

### Dependency upgrades
* Dart SDK constraint: `>=2.14.0 <3.0.0` → `>=3.0.0 <4.0.0`
* Flutter constraint: `>=2.10.0` → `>=3.10.0`
* `flutter_html`: `^2.2.1` → `^3.0.0-beta.2` (API breaking: `Style.padding` now uses `HtmlPaddings`)
* `image_picker`: `^0.8.6` → `^1.0.0`
* `url_launcher`: `^6.1.6` → `^6.2.0`

### Bug fixes
* Replaced deprecated `launch()` with `launchUrl(Uri.parse(...))` in toolbar.
* Replaced deprecated `MaterialStateProperty` with `WidgetStateProperty`.
* Fixed `stretched` field never being assigned in the old `EditorJSBlockData.fromJson`.
* Removed duplicate `toolbar.dart` import in `editor.dart`.
* Fixed `MyHomePage` constructor to use `Key?` and `required this.title` (null safety).
* Removed dead toolbar buttons (quote, list) that previously rendered with no functionality.

### Migration guide
```dart
// Before
EditorJSView(editorJSData: json, styles: stylesJson)

// After
EditorJSView(jsonData: json, config: EditorConfig(styleConfig: styleConfig))

// Before — editor had no save mechanism
EditorJSEditor()

// After — create a controller, pass it in, call getContent() to export
final controller = EditorController();
EditorJSEditor(controller: controller)
final json = controller.getContent();
```

---

## [0.0.5] - Links support
* Now you may add links in the editor. Just set the name and the url to set.
NOTE: Right now is a basic implementation. I'll make it adhoc to EditorJS standard later

## [0.0.4] - Image, text block and horizontal ruler insertion completed

* You may use image insertion from camera and gallery. You must give permissions from your device for enabling it. Also, now you can create new text blocks and horizontal rulers. Soon you'll be able to change header on each block.

## [0.0.3] - Added Toolbar

* The toolbar scaffolding is ready. You may check it out in the Demo.

## [0.0.2] - Added Styles for Paragraphs

* Now you can add a paragraph with some styles.

## [0.0.1] - Initial Release

* The Viewer has been completed with the basic structures of an EditorJS JSON file.

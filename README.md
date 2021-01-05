# EditorJS viewer for Flutter

A viewer compatible with the EditorJS schema.

## DISCLAIMER
This library is still under development, so critical bugs are expected and should not be used right now for a production environment.

## Installation
**WARNING:** You must install the Flutter HTML library for using correctly this library.

Add these lines in your pubspec.yaml file on the dependencies level:

```dart
  editorjs_flutter: any
  flutter_html: ^0.8.2
```

After that just execute ```flutter pub get``` in Terminal as always.

## Usage

### Viewer
For Viewer, you must ensure you have as input an EditorJS JSON as shown in EditorJS documentation at https://editorjs.io/.

After that, you may use the editor as follows:

```dart
    EditorJSView editorJSView;

    // Substitute as the way of getting your JSON
    String data = await DefaultAssetBundle.of(context).loadString("example_asset/example.json");

    setState(() { // Recommended for async environments.
      editorJSView = EditorJSView(editorJSData: data);
    });
```

Finally, assign it to your widget as you wish. The Viewer has the same features as a common column.

### Editor
On development, thanks for your patience.

## Want to Collaborate?
Please send me a message to Twitter (@RZEROSTERN) or an email to marco.ramirez@rzerocorp.com for getting in touch.

Also if you have an issue or want to propose a fix, please leave it in the Issues tab on Github. I'll fix it ASAP.

**Made in Mexico with love by RZEROSTERN**

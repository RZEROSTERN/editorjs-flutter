import 'package:editorjs_flutter/editorjs_flutter.dart';
import 'package:flutter/material.dart';
import 'createnote.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EditorJS Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'EditorJS Flutter Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EditorJSView editorJSView;

  @override
  void initState() {
    super.initState();
    fetchTestData();
  }

  void fetchTestData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("test_data/editorjsdatatest.json");
    String styles = await DefaultAssetBundle.of(context)
        .loadString("test_data/editorjsstyles.json");

    setState(() {
      editorJSView = EditorJSView(editorJSData: data, styles: styles);
    });
  }

  void _showEditor() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => CreateNoteLayout()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(15),
        children: [
          (editorJSView != null) ? editorJSView : Text("Please wait...")
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showEditor,
        tooltip: 'Create content',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

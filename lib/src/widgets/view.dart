import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:editorjs_flutter/src/model/EditorJSData.dart';
import 'package:flutter_html/flutter_html.dart';

class EditorJSView extends StatefulWidget {
  final String editorJSData;
  
  const EditorJSView({Key key, this.editorJSData}) : super(key: key);

  @override
  EditorJSViewState createState() => EditorJSViewState();
}

class EditorJSViewState extends State<EditorJSView> {
  String data;
  EditorJSData dataObject;
  List<Widget> items = new List();

  @override
  void initState() {
    super.initState();
    
    setState(() {
      data = widget.editorJSData;
      dataObject = EditorJSData.fromJson(jsonDecode(data));

      dataObject.blocks.forEach((element) {
        double levelFontSize = 16;
        
        switch(element.data.level) {
          case 1: levelFontSize = 32; break;
          case 2: levelFontSize = 24; break;
          case 3: levelFontSize = 16; break;
          case 4: levelFontSize = 12; break;
          case 5: levelFontSize = 10; break;
          case 6: levelFontSize = 8; break;
        }

        switch(element.type) {
          case "header":
            items.add(Text(element.data.text, 
              style: TextStyle(
                fontSize: levelFontSize,
                fontWeight: (element.data.level <= 3) ? FontWeight.bold : FontWeight.normal
              ), 
              textAlign: TextAlign.center, )
            );
          break;
          case "paragraph":
            items.add(Html(data: element.data.text));
          break;
          case "list":
            String bullet = "\u2022 ";
            String style = element.data.style;
            int counter = 1;

            element.data.items.forEach((element) {
              if(style == 'ordered') {
                bullet = counter.toString();
                items.add(Text(bullet + element));
                counter++;
              } else {
                items.add(Text(bullet + element));
              }
            });
          break;
          case "delimiter":
            items.add(Text('***', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center,));
          break;
          case "image":
            items.add(Image.network(element.data.file.url));
          break;
        }
        items.add(SizedBox(height: 10,));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }
}
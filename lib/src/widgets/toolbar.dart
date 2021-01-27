import 'package:flutter/material.dart';

class EditorJSToolbar extends StatelessWidget {
  const EditorJSToolbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int headerSize = 1;
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("T", style: TextStyle(color: Colors.black38, fontSize: 20.0, fontWeight: FontWeight.bold),)
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text("H" + headerSize.toString(), style: TextStyle(color: Colors.black38, fontSize: 20.0, fontWeight: FontWeight.bold),)
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.format_quote, color: Colors.black38,),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.list, color: Colors.black38,),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.link, color: Colors.black38,),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.horizontal_rule, color: Colors.black38,),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.image, color: Colors.black38,),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class EditorJSToolbar extends StatefulWidget {
  EditorJSToolbar({
    Key key,
  }) : super(key: key);

  @override
  EditorJSToolbarState createState() => EditorJSToolbarState();
}

class EditorJSToolbarState extends State<EditorJSToolbar> {
  int headerSize = 1;
  
  void changeHeader() {
    setState(() {
      if(headerSize > 5) {
        headerSize = 1;
      } else {
        headerSize++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          GestureDetector(
            onTap: () {
              print("Adds new paragraph");
            },
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("T", style: TextStyle(color: Colors.black38, fontSize: 20.0, fontWeight: FontWeight.bold),)
            ),
          ),
          GestureDetector(
            onTap: () => changeHeader(),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("H" + headerSize.toString(), style: TextStyle(color: Colors.black38, fontSize: 20.0, fontWeight: FontWeight.bold),)
            ),
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
import 'package:flutter/material.dart';

class EditorJSToolbar extends StatelessWidget {
  const EditorJSToolbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Expanded(
            child: Text('Demo', style: TextStyle(color: Colors.red, backgroundColor: Colors.black),),
          )
        ],
      ),
    );
  }
}
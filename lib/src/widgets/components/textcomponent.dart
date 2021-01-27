import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TextComponent {
  static Widget addText() {
    return Flexible(
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: ""
        ),
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
      )
    );
  }

  static Widget addHeader() {}
}
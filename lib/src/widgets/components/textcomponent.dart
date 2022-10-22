import 'package:flutter/material.dart';

class TextComponent {
  static Widget addText(
      {double size = 14, FontWeight weight = FontWeight.w400}) {
    return Flexible(
        child: TextField(
          autofocus: true,
          style: TextStyle(
            fontSize: size,
            fontWeight: weight,
          ),
          decoration: InputDecoration(border: InputBorder.none, hintText: ""),
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: null,
        )
    );
  }
}

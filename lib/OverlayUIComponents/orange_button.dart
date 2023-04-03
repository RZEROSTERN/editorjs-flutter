import 'dart:developer';

import 'package:flutter/material.dart';

import 'Colors/Colors.dart';
import 'Fonts/Styles.dart';

class EditorJSOrangeButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final String buttonType;

  const EditorJSOrangeButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.buttonType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final Widget buttonIcon;
    switch (buttonType.trim().toLowerCase()) {
      case ('externalurl'):
        buttonIcon = Icon(Icons.link);
        break;
      case ('servercall'):
        buttonIcon = Icon(Icons.dns_outlined);
        break;
      case ('internaldeeplink'):
        buttonIcon = Icon(Icons.double_arrow);
        break;
      case ('externaldeeplink'):
        buttonIcon = Icon(Icons.arrow_outward);
        break;
      default:
        buttonIcon = Icon(Icons.question_mark);
        break;
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: const StadiumBorder(),
          backgroundColor: AppColors.overlayDarkOrange,
          padding: const EdgeInsets.symmetric(
            horizontal: 42.0,
            vertical: 15.0,
          )),
      onPressed: () => onPressed(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buttonIcon,
          const SizedBox(
            width: 8.0,
          ),
          Text(
            text,
            style: AppStyles.poppinsButton,
          ),
        ],
      ),
    );
  }
}

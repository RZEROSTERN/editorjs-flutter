import 'package:flutter/material.dart';

import 'Colors/Colors.dart';
import 'Fonts/Styles.dart';

class BlueButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  const BlueButton({Key? key,
    required this.text,
    required this.onPressed,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      alignment: Alignment.center,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return AppColors.overlayBlueButtonPressed;
            } else {
              return AppColors.overlayBlue;
            }
          }),
          padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 24.0,
            ),
          ),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          )),
        ),
        onPressed: () => onPressed(),
        child: Text(
          text,
          style: AppStyles.poppinsButton,
        ),
      ),
    );
  }
}


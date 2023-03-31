import 'package:flutter/material.dart';
import '../Colors/Colors.dart';

class AppStyles {

  // Poppins Extra Large
  static const TextStyle poppinsXL = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 32.0,
  );

  // Poppins Large
  static const TextStyle poppinsLarge = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 19.0,
    letterSpacing: 0.15,
  );

  static const TextStyle poppins19 = TextStyle(
    fontFamily: "Poppins",
  );
  static TextStyle poppins19BlueBold = poppins19.copyWith(
    fontSize: 19.0,
    fontWeight: FontWeight.w600,
    color: AppColors.overlayBlue,
  );

  // static const TextStyle poppins16 = TextStyle(
  //   fontSize: 16.0,
  //   fontFamily: "Poppins",
  // );
  static TextStyle poppins16BlueBold = poppins16.copyWith(
    fontWeight: FontWeight.w600,
    color: AppColors.overlayBlue,
  );
  // Poppins Large
  static const TextStyle poppins16 = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 16.0,
    letterSpacing: 0.15,
  );


  // Poppins Button
  static const TextStyle poppinsButton = TextStyle(
    color: Colors.white,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
  );

  // Poppins Normal
  static const TextStyle poppinsNormal = TextStyle(
    fontFamily: "Poppins",
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
  );
  static TextStyle poppinsNormalBlack = poppinsNormal.copyWith(
    color: Colors.black,
  );
  static TextStyle poppinsNormalOrange = poppinsNormal.copyWith(
    color: AppColors.overlayDarkOrange,
  );

  static TextStyle poppinsNormalBlackBold = poppinsNormalBlack.copyWith(
    fontWeight: FontWeight.w800,
  );


  static TextStyle poppinsNormal600Black = poppinsNormal.copyWith(
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle poppinsNormal500Black =
      poppinsNormal.copyWith(color: Colors.black, fontWeight: FontWeight.w500);

  // Poppins Small
  static const TextStyle poppinsSmall = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
  );
  static TextStyle poppinsSmallBlack = poppinsSmall.copyWith(
    color: Colors.black,
  );
  static TextStyle poppinsSmallBlue = poppinsSmall.copyWith(
    color: AppColors.overlayBlue,
  );
  static TextStyle poppinsSmallLightGrey = poppinsSmall.copyWith(
    color: AppColors.overlayLightGrey,
  );
  static TextStyle poppinsSmall600Black = poppinsNormal.copyWith(
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );
  static TextStyle poppinsSmall500White = poppinsNormal.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );
  static TextStyle poppinsSmall500Black = poppinsNormal.copyWith(
    color: Colors.black,
    fontWeight: FontWeight.w500,
  );
  static TextStyle poppinsSmallLightBlue = poppinsSmall.copyWith(
    color: Colors.lightBlueAccent,
  );
  static TextStyle poppinsSmallBlackBold = poppinsSmallBlack.copyWith(
    fontWeight: FontWeight.w800,
  );


  // Poppins Tiny
  static const TextStyle poppinsTiny = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 10.0,
  );
  static TextStyle poppinsTinyBlack = poppinsTiny.copyWith(
    color: Colors.black,
  );
  static TextStyle poppinsTinyBlue = poppinsTiny.copyWith(
    color: AppColors.overlayBlue,
  );
  static TextStyle poppinsTinyRed = poppinsTiny.copyWith(
    color: Colors.red,
  );
  static TextStyle poppinsTinyLightBlue = poppinsTiny.copyWith(
    color: Colors.lightBlueAccent,
  );

  static TextStyle poppinsButtonWhite = poppinsButton.copyWith(
    color: AppColors.overlayBlue,
  );


  //============================ Scan View =====================
  static const TextStyle titleTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 19.0,
    letterSpacing: 0.15,
  );

  static const TextStyle descriptionTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontSize: 14,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w400,
  );


  //settings
//Settings Title
  static const TextStyle settingsTitle = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 32.0,
    letterSpacing: 2.5,
  );

  //Settings buttons
  static const TextStyle settingsButton = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    letterSpacing: 0.5,
  );


  static const TextStyle settingsLabels = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 24.0,
    letterSpacing: 2.5,
  );

  static const TextStyle helpLabels = TextStyle(
    color: AppColors.overlayBlue,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 16.0,
    letterSpacing: 0.5,
  );

  static const TextStyle description = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
    letterSpacing: 0.5,
  );

  static const TextStyle profileTitles = TextStyle(
    color: Colors.black,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 18.0,
    letterSpacing: 0.5,
  );

  static const TextStyle rubikAudioPlayerNormal = TextStyle(
    color: Colors.black,
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
  );

  static const TextStyle rubikAudioPlayerBold = TextStyle(
    color: Colors.black,
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w600,
    fontSize: 12.0,
  );

  static const TextStyle rubikBodyText = TextStyle(
    color: Colors.black,
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w400,
    fontSize: 14.0,
  );

}

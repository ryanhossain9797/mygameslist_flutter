import 'package:flutter/material.dart';
import 'package:mygameslist_flutter/colors.dart';
import 'package:mygameslist_flutter/constants.dart';

final primaryCircleBorderRadius = BorderRadius.circular(kPrimaryRadiusValue);

var appBarText = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.bold,
);

var boldGreenText = TextStyle(
  fontSize: 30,
  fontFamily: 'Poppins',
  color: lightAccentColor,
);
var darkGreyText = TextStyle(
  fontSize: 30,
  fontFamily: 'Poppins',
  color: darkGreyColor,
);
var greyBorder = OutlineInputBorder(
  borderRadius: primaryCircleBorderRadius,
  borderSide: BorderSide(width: 2, color: darkGreyColor),
);

var lightGreenBorder = OutlineInputBorder(
  borderRadius: primaryCircleBorderRadius,
  borderSide: BorderSide(
    width: 2,
    color: lightAccentColor,
  ),
);

var greenBorder = OutlineInputBorder(
  borderRadius: primaryCircleBorderRadius,
  borderSide: BorderSide(
    width: 2,
    color: darkAccentColor,
  ),
);

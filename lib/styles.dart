import 'package:flutter/material.dart';
import 'package:mygameslist_flutter/colors.dart';

var boldGreenText = TextStyle(
  fontSize: 30,
  fontFamily: 'Poppins',
  color: accentColor,
);
var darkGreyText = TextStyle(
  fontSize: 30,
  fontFamily: 'Poppins',
  color: darkGrey,
);
var greyBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(
    width: 2,
    color: Colors.grey[800],
  ),
);

var lightGreenBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(
    width: 2,
    color: Colors.lightGreenAccent,
  ),
);

var greenBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10),
  borderSide: BorderSide(
    width: 2,
    color: Colors.greenAccent,
  ),
);

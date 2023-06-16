// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social/shared/styles/colors.dart';

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: defaultColor),
  useMaterial3: true,
  appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      color: Colors.white,
      elevation: 0.0,
      titleSpacing: 20.0,
      titleTextStyle: TextStyle(
        fontFamily: 'Jannah',
        color: Colors.black,
        fontSize: 20.0,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      )),
  scaffoldBackgroundColor: Colors.white,
  cardTheme: CardTheme(
    color: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 30.0,
    backgroundColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: Colors.white,
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.white,
  ),
  iconTheme: IconThemeData(
    color: Colors.black,
  ),
  fontFamily: 'Jannah',
  textTheme: TextTheme(
    headlineSmall: TextStyle(),
    headlineMedium: TextStyle(
      color: Colors.black,
    ),
    titleSmall: TextStyle(),
    titleLarge: TextStyle(),
    bodyMedium: TextStyle(),
    bodyLarge: TextStyle(),
  ).apply(
    bodyColor: Colors.black,
  ),
);

ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: defaultColor),
  useMaterial3: true,
  appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: HexColor('333739'),
        statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: HexColor('333739'),
      elevation: 0.0,
      titleSpacing: 20.0,
      titleTextStyle: TextStyle(
        fontFamily: 'Jannah',
        color: Colors.white,
        fontSize: 20.0,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      )),
  scaffoldBackgroundColor: HexColor('333739'),
  cardTheme: CardTheme(
    color: HexColor('333739'),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 30.0,
    backgroundColor: HexColor('333739'),
    unselectedItemColor: Colors.grey,
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: HexColor('333739'),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: HexColor('333739'),
  ),
  iconTheme: IconThemeData(
    color: Colors.white,
  ),
  fontFamily: 'Jannah',
  textTheme: TextTheme(
    headlineSmall: TextStyle(),
    headlineMedium: TextStyle(
      color: Colors.white,
    ),
    titleSmall: TextStyle(),
    titleLarge: TextStyle(),
    bodyMedium: TextStyle(),
    bodyLarge: TextStyle(),
  ).apply(
    bodyColor: Colors.white,
  ),
);

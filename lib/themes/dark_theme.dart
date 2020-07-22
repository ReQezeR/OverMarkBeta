import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:overmark/themes/theme_options.dart';


AppTheme customDarkTheme() {
  return AppTheme(
    id: "dark_theme",
    description: "dark",
    data: ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: Colors.black,
      accentColor: Colors.amber[300],
      textSelectionColor: Colors.blue[400],
      appBarTheme: AppBarTheme(elevation: 0),
      textTheme: TextTheme(headline6: TextStyle(color: Colors.white), bodyText2:TextStyle(color: Colors.grey)),
    ),
    options: CustomThemeOptions(
      surfaceColor: Color(0xFF222222),
      mainTextColor: Colors.white,
      inputFieldColor: Colors.white30,
      secondaryTextColor: Colors.grey,
      defaultIconColor: Colors.white60,
      accentIconColor: Colors.amber[300],
      backgroundColor: Color(0xFF181613),
      defaultDetailColor: Colors.grey[400]
    ),
  );
}
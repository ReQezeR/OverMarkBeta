import 'package:flutter/material.dart';
import 'package:overmark/pages/home_page.dart';
import 'package:overmark/themes/dark_theme.dart';
import 'package:overmark/themes/light_theme.dart';
import 'package:theme_provider/theme_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      defaultThemeId: 'dark_theme', 
      themes: [
        customLightTheme(),
        customDarkTheme(),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OverMark',
        color: Colors.black,
        home: ThemeConsumer(
          child: HomePage(title: 'OverMark'),
        ),
      ),
    );
  }
}
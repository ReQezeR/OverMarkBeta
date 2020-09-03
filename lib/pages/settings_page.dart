
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.db, this.toogleGradientState, this.getGradientState}) : super(key: key);
  final DbProvider db;
  final Function toogleGradientState;
  final Function getGradientState;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void changeTheme(bool value, BuildContext context)async{
    ThemeProvider.controllerOf(context).nextTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
              borderRadius:BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height*0.14,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Center(
                        child: Text(
                          "Ustawienia",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            fontSize: 55.0,
                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Icon(
                            SimpleLineIcons.settings,
                            size: 45,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //! Koniec nagłówka

          Expanded(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[


                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                              child: Icon(
                                 SimpleLineIcons.pencil,
                                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Motyw:",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                ),
                              )),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        color: Theme.of(context).brightness == Brightness.light?Colors.white: Colors.black38,
                        width: MediaQuery.of(context).size.width*0.9,
                        child: InkWell(
                          onTap: (){
                            changeTheme(true,context);
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  SimpleLineIcons.bulb,
                                  size: 25,
                                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Tryb ciemny",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Switch(
                                  value: Theme.of(context).brightness == Brightness.light?false:true,
                                  onChanged: (bool state){
                                    changeTheme(true,context);
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        color: Theme.of(context).brightness == Brightness.light?Colors.white: Colors.black38,
                        width: MediaQuery.of(context).size.width*0.9,
                        child: InkWell(
                          onTap: (){
                            widget.toogleGradientState();
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.palette,
                                  size: 25,
                                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Gradient",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Switch(
                                  value: widget.getGradientState(),
                                  onChanged: (bool state){
                                    widget.toogleGradientState();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                Container(
                  padding: EdgeInsets.fromLTRB(0,10,0,10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                              child: Icon(
                                 SimpleLineIcons.layers,
                                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Baza danych:",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                ),
                              )),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        color: Theme.of(context).brightness == Brightness.light?Colors.white: Colors.black38,
                        width: MediaQuery.of(context).size.width*0.9,
                        child: InkWell(
                          onTap: (){
                            widget.db.flushTable('Bookmarks');
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.line_weight,
                                  size: 25,
                                  // color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                  color: Colors.red,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Usuń zakładki",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  SimpleLineIcons.trash,
                                  size: 25,
                                  // color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        color: Theme.of(context).brightness == Brightness.light?Colors.white: Colors.black38,
                        width: MediaQuery.of(context).size.width*0.9,
                        child: InkWell(
                          onTap: (){
                            widget.db.flushTable('Bookmarks');
                            widget.db.flushTable('Categories');
                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  SimpleLineIcons.trash,
                                  size: 25,
                                  // color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                  color: Colors.red,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Usuń wszystko",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w400,
                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  SimpleLineIcons.trash,
                                  size: 25,
                                  // color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                  color: Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
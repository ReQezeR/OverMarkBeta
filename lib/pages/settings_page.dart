
import 'package:OverMark/services/admob_provider.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:OverMark/databases/bookmark.dart';
import 'package:OverMark/databases/db_provider.dart';
import 'package:OverMark/themes/theme_options.dart';
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
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
              borderRadius:BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor.withOpacity(0.6):Colors.grey.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
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
                            // SimpleLineIcons.settings,
                            Icons.settings,
                            size: 47,
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Column(
                    children: [
                      Container(
                        height: 80,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: Center(
                                    child: Icon(
                                      Icons.palette,
                                      size: 30.0,
                                      color: Theme.of(context).brightness == Brightness.light?Colors.black:Colors.tealAccent,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Motyw:",
                                  style: TextStyle(
                                    fontSize: 30.0,
                                      fontWeight: FontWeight.w300,
                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                  ),
                                )),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        width: MediaQuery.of(context).size.width*0.9,
                        decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
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
                                child: Theme.of(context).brightness == Brightness.light?Icon(Icons.wb_sunny, color:Colors.grey[800], size:25):Icon(Icons.brightness_3, color:Colors.amber, size:25),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Tryb ciemny",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w300,
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
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
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
                                  Icons.gradient,
                                  size: 25,
                                  color: Theme.of(context).brightness == Brightness.light?Colors.grey[800]:Colors.lightBlue[700],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Gradient",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w300,
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
                  padding: EdgeInsets.fromLTRB(0,0,0,0),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0,10,0,10),
                        height: 80,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: Center(
                                    child: Icon(
                                      SimpleLineIcons.layers,
                                      size: 25.0,
                                      color: Theme.of(context).brightness == Brightness.light?Colors.black:Colors.tealAccent,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Baza danych:",
                                  style: TextStyle(
                                    fontSize: 30.0,
                                      fontWeight: FontWeight.w300,
                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                  ),
                                )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
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
                                  Icons.collections_bookmark,
                                  size: 25,
                                  color: Colors.red,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  "Usuń zakładki",
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.w300,
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
                        decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
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
                                    fontWeight: FontWeight.w300,
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
          Padding(
            padding: const EdgeInsets.only(left:10.0, right:10.0),
            child: Card(
              color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AdmobBanner(
                  nonPersonalizedAds: false,
                  adUnitId: AdMobStatic.bannerAdUnitId,
                  adSize: AdmobBannerSize.ADAPTIVE_BANNER(width: (MediaQuery.of(context).size.width*0.9).toInt()),
                  listener: (AdmobAdEvent event,Map<String, dynamic> args) {},
                  onBannerCreated:(AdmobBannerController controller) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
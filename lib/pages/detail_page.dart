import 'dart:math';

import 'package:OverMark/services/admob_provider.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:OverMark/databases/bookmark.dart';
import 'package:OverMark/databases/db_provider.dart';
import 'package:OverMark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';


class DetailPage extends StatefulWidget{
  final Bookmark bookmark;
  final DbProvider db;
  final bool isGradient;
  final Function getGradient;
  final Function refresh;
  DetailPage({this.bookmark, this.db, this.getGradient, this.isGradient, this.refresh});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin{
  List<Bookmark> bookmarks = new List();

  AnimationController _refreshController;
  Animation<double> _refreshAnimation;

  @override
  void initState(){
    this._refreshController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    this._refreshAnimation = Tween<double>(begin: 0, end: pi + pi).animate(_refreshController);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color tileBackground = ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor.withOpacity(0.5):Theme.of(context).primaryColor;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Informacje",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 25.0,
                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                ),
              ),
            ],
          ),
          leading: FlatButton(
            child: Icon(
              Icons.arrow_back,
              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          actions: [
            FlatButton(
              child: Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: () {
                widget.db.delete(widget.bookmark.id, "Bookmarks");
                widget.refresh();
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
        body: Container(
          decoration: widget.isGradient?BoxDecoration(
            gradient: widget.getGradient(ThemeProvider.themeOf(context).id == "dark_theme"?1:0),
          ):ThemeProvider.themeOf(context).id == "dark_theme"?BoxDecoration(
            color: Theme.of(context).primaryColor,
          ):BoxDecoration(
            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 100,
                        color: tileBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.title,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Nazwa:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Schyler',
                                      fontSize: 25.0,
                                      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                    ),
                                  ),
                                )
                              ),
                              Expanded(
                                  child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      widget.bookmark.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 25.0,
                                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                      ),
                                    ),
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Container(
                      //   color: tileBackground,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(10.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: <Widget>[
                      //         Container(
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(10.0),
                      //             child: Icon(
                      //               SimpleLineIcons.key,
                      //               color: Colors.amber,
                      //             ),
                      //           ),
                      //         ),
                      //         Container(
                      //           child: Padding(
                      //             padding: const EdgeInsets.all(10.0),
                      //             child: Text(
                      //               "Identyfikator:",
                      //               style: TextStyle(
                      //                 fontWeight: FontWeight.w300,
                      //                 fontSize: 25.0,
                      //                 color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                      //               ),
                      //             ),
                      //           )
                      //         ),
                      //         Expanded(
                      //             child: Container(
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(10.0),
                      //               child: Text(
                      //                 widget.bookmark.id.toString(),
                      //                 style: TextStyle(
                      //                   fontWeight: FontWeight.w300,
                      //                   fontSize: 25.0,
                      //                   color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                      //                 ),
                      //               ),
                      //             )
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Container(
                        color: tileBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    SimpleLineIcons.link,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "URL:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 25.0,
                                      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                    ),
                                  ),
                                )
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      widget.bookmark.url,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 25.0,
                                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        color: tileBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    SimpleLineIcons.layers,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Kategoria:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 25.0,
                                      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                    ),
                                  ),
                                )
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      widget.bookmark.categoryId.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 25.0,
                                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        color: tileBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    SimpleLineIcons.calendar,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Utworzono:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 25.0,
                                      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                    ),
                                  ),
                                )
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          widget.bookmark.date.split("T")[0],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20.0,
                                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                          ),
                                        ),
                                        Text(
                                          widget.bookmark.date.split("T")[1],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20.0,
                                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        color: tileBackground,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    SimpleLineIcons.clock,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Użyto:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 25.0,
                                      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                    ),
                                  ),
                                )
                              ),
                              Expanded(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          widget.bookmark.recentUpdate.split("T")[0],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20.0,
                                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                          ),
                                        ),
                                        Text(
                                          widget.bookmark.recentUpdate.split("T")[1],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 20.0,
                                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
              Card(
                color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AdmobBanner(
                    nonPersonalizedAds: false,
                    adUnitId: AdMobStatic.bannerAdUnitId,
                    adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                    listener: (AdmobAdEvent event,Map<String, dynamic> args) {},
                    onBannerCreated:(AdmobBannerController controller) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
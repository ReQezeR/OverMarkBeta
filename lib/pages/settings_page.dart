
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
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
                Row(
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

                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                               padding: const EdgeInsets.all(20.0),
                        color: Colors.limeAccent[700],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Icon(Icons.add),
                            ),
                            Text("Insert", style: TextStyle(fontSize: 25),),
                          ],
                        ),
                        onPressed: () {
                          print("ADD +");
                          String _date = new DateTime.now().toIso8601String();
                          widget.db.insert(Bookmark(categoryId:1, name: "XD", url:"XD_URL", date: _date, recentUpdate: _date).toMap(), 'Bookmarks');
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        padding: const EdgeInsets.all(20.0),
                        color: Colors.blueAccent[700],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Icon(Icons.list),
                            ),
                            Text("Querry All", style: TextStyle(fontSize: 25),),
                          ],
                        ),
                        onPressed: () async{
                          print("GET ALL");
                          var temp = await widget.db.queryAllRows('Bookmarks');
                          printBookmarks(toBookmarks(temp));
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        padding: const EdgeInsets.all(20.0),
                        color: Colors.orangeAccent[700],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Icon(Icons.list),
                            ),
                            Text("Querry Recent", style: TextStyle(fontSize: 25),),
                          ],
                        ),
                        onPressed: () async{
                          print("GET Recent");
                          var temp = await widget.db.queryRecentRows('Bookmarks', 'date', 5);
                          printBookmarks(toBookmarks(temp));
                        },
                      ),
                    ),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(
                        padding: const EdgeInsets.all(20.0),
                        color: Colors.redAccent[700],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Icon(Icons.remove),
                            ),
                            Text("Drop", style: TextStyle(fontSize: 25),),
                          ],
                        ),
                        onPressed: () async{
                          print("Drop Table");
                          widget.db.flushTable('Bookmarks');
                          widget.db.flushTable('Categories');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
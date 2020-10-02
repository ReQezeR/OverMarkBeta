import 'dart:math';

import 'package:flutter/material.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/category.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:overmark/tools/custom_listtile.dart';
import 'package:theme_provider/theme_provider.dart';


class CategoryPage extends StatefulWidget{
  final String categoryName;
  final DbProvider db;
  final Function(String)openWebPage;
  final Function (Bookmark, Function)openDetailPage;
  final bool isGradient;
  final Function getGradient;
  final Function refresh;
  CategoryPage({this.db, this.categoryName, this.openWebPage, this.openDetailPage, this.getGradient, this.isGradient, this.refresh});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with TickerProviderStateMixin{
  List<Bookmark> bookmarks = new List();

  AnimationController _refreshController;
  Animation<double> _refreshAnimation;

  int openTileID = 0;

  @override
  void initState(){
    this._refreshController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    this._refreshAnimation = Tween<double>(begin: 0, end: pi + pi).animate(_refreshController);
    this.getData();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
  void refreshAll(){
    getData();
    widget.refresh();
  }

  void getData() async {
    var temp = await widget.db.search('Categories', 'name', widget.categoryName);
    List<Category> cat = toCategories(temp);
    print(cat[0].id);

    var tempB = await widget.db.search('Bookmarks', 'categoryId', cat[0].id.toString());
    this.bookmarks = toBookmarks(tempB);
    this.setState((){});
  }

    int toogleOpenTile({int id:-1}){
    if(id == 0){
      this.openTileID = 0;
      setState(() {});
    }
    else if(id == -1){
      return this.openTileID;
    }
    else{
      this.openTileID = id;
      setState(() {});
    }
    return openTileID;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.categoryName,
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
            onPressed: () {Navigator.of(context).pop(true);},
          ),
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
            children: <Widget>[
              Container(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0.0),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: bookmarks.length,
                  itemBuilder: (BuildContext context, int index) => 
                  ThemeConsumer(child: CustomListTile(bookmark: bookmarks[index], openWebPage: widget.openWebPage,openDetailPage:widget.openDetailPage, onChange: toogleOpenTile, refresh: refreshAll,)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
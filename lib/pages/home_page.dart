import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:OverMark/databases/bookmark.dart';
import 'package:OverMark/databases/category.dart';
import 'package:OverMark/databases/db_provider.dart';
import 'package:OverMark/themes/theme_options.dart';
import 'package:OverMark/tools/bookmark_form.dart';
import 'package:OverMark/tools/custom_listtile.dart';
import 'package:theme_provider/theme_provider.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.db, this.openWebPage, this.openCategoryPage, this.openDetailPage}) : super(key: key);
  final DbProvider db;
  final Function(Bookmark)openWebPage;
  final Function(String, Function) openCategoryPage;
  final Function (Bookmark, Function)openDetailPage;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List<Bookmark> recent_bookmarks = new List();
  List<Category> categories = new List();
  bool isBookmarkForm = false;
  int openTileID = 0;
  
  void closeForm(){
    this.isBookmarkForm = false;
    this.setState(() {});
  }

  int toogleOpenTile({int id:-1}){
    if(id == 0){
      openTileID = 0;
      setState(() {});
    }
    else if(id == -1){
      return openTileID;
    }
    else{
      openTileID = id;
      setState(() {});
    }
    return openTileID;
  }

  void getData() async {
    var temp = await widget.db.queryRecentRows('Bookmarks', 'recentUpdate', 5);
    recent_bookmarks = toBookmarks(temp);
    var tempC = await widget.db.queryAllRows('Categories');
    this.categories = toCategories(tempC);
    this.setState((){});
  }

  @override
  void initState(){
    this.getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  double calcGridAspectRatio(){
    return (MediaQuery.of(context).size.width-30)/(MediaQuery.of(context).size.width*0.74-24);
  }

  @override
  Widget build(BuildContext context){
    bool isInput = false;
    bool isForm = false;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
              borderRadius:BorderRadius.only(
                bottomLeft: isInput?Radius.circular(0.0): Radius.circular(20.0),
                bottomRight: isInput?Radius.circular(0.0): Radius.circular(20.0),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height*0.14,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Icon(
                                Icons.bookmark,
                                size: 47,
                                color: Colors.amber
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              "OverMark",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 55.0,
                                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  Container(
                    height: 80,
                    color: Colors.transparent,
                    padding: const EdgeInsets.fromLTRB(10,10,10,0),
                    child: Card(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Icon(
                                      SimpleLineIcons.fire,
                                      size: 30,
                                      color: Colors.orange[400],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Center(
                                  child: Text(
                                    "Ostatnie zakładki:",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  recent_bookmarks.length>0?Container(
                    padding: const EdgeInsets.fromLTRB(10,0,10,5),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: recent_bookmarks.length>=3?3:recent_bookmarks.length,
                      itemBuilder: (BuildContext context, int index) => 
                      Padding(
                        padding: const EdgeInsets.fromLTRB(1, 5, 1, 2),
                        child: CustomListTile(bookmark: recent_bookmarks[index],openWebPage: widget.openWebPage, openDetailPage: widget.openDetailPage, onChange: toogleOpenTile,),
                      ),
                    ),
                  ):Container(),

                  Container(
                    height: 80,
                    color: Colors.transparent,
                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                    child: Card(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Icon(
                                      SimpleLineIcons.folder,
                                      size: 30,
                                      color: Colors.deepOrange[800],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Center(
                                  child: Text(
                                    "Kategorie:",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      // fontWeight: FontWeight.w500,
                                      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  categories.length>0?Container(
                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(0.0),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: categories.length,
                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount( 
                        crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3, 
                        childAspectRatio: categories.length==1?calcGridAspectRatio():1.5,
                      ),

                      itemBuilder: (BuildContext context, int index) => 
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: InkWell(
                            onTap: () => widget.openCategoryPage(categories[index].name, getData),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10.0), ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor.withOpacity(0.6):Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(1, 7), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            categories[index].name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w300,
                                              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                            ),
                                          )
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 10,
                                      decoration: BoxDecoration(
                                        gradient: RadialGradient(
                                          center: Alignment.center,
                                          radius: 9,
                                          colors: [
                                            Colors.red[400],
                                            Colors.red[600],
                                            Colors.red[800],
                                          ]
                                        ),
                                        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0), ),
                                        borderRadius: BorderRadius.all(Radius.elliptical(50, 100))
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ):Container(),
                  Container(
                    height: 80,
                    color: Colors.transparent
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
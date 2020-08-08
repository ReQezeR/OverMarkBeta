import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/category.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:overmark/tools/bookmark_form.dart';
import 'package:overmark/tools/custom_listtile.dart';
import 'package:theme_provider/theme_provider.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.db, this.openWebPage}) : super(key: key);
  final DbProvider db;
  final Function(String)openWebPage;

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
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
              borderRadius:BorderRadius.only(
                bottomLeft: isInput?Radius.circular(0.0): Radius.circular(20.0),
                bottomRight: isInput?Radius.circular(0.0): Radius.circular(20.0),
              ),
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
                              Icons.bookmark_border,
                              size: 45,
                              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            "Over Mark",
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
                        alignment: Alignment.centerRight,
                        child: isForm==false?Container(
                          padding: EdgeInsets.all(0),
                          child: MaterialButton(
                            padding: EdgeInsets.all(0),
                            shape: CircleBorder(),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:BorderRadius.all(Radius.circular(20.0))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Icons.card_travel, color: Colors.grey[800],),
                              )
                            ),
                            onPressed: () {
                              print("side menu");
                            },
                          ),
                        ):Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
          // Column(
          //   children: <Widget>[
          //     Container(
          //       color: Theme.of(context).primaryColor.withOpacity(0.5),
          //       height: MediaQuery.of(context).size.height*0.08,
          //       child: SafeArea(
          //         child: Center(child: Text("Over Mark", style: TextStyle(fontSize: 35.0, color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),)),
          //       ),
          //     ),
          //     Container(
          //       color: ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
          //       height: 2.0,
          //       child: Container(),
          //     ),
          //   ],
          // ),

          isBookmarkForm==false?Container(
            height: MediaQuery.of(context).size.height*0.054,
            padding: const EdgeInsets.fromLTRB(20,5,10,0),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Icon(
                            SimpleLineIcons.fire,
                            size: 25,
                            // color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                            color: Colors.orange[400],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Ostatnie zakładki:",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                        ),
                      )
                    ),
                  ],
                ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: FlatButton(
                //       color: Colors.orangeAccent,
                //       child: Icon(Icons.add),
                //       onPressed: () {
                //         print("ADD +");
                //         this.isBookmarkForm = true;
                //         this.setState(() {});
                //         // String _date = new DateTime.now().toIso8601String();
                //         // widget.db.insert(Bookmark(categoryId:1, name: "XD", url:"XD_URL", date: _date, recentUpdate: _date).toMap(), 'Bookmarks');
                //         // this.getData();
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ):BookmarkForm(width: 500, height:550, db: widget.db, closeForm: this.closeForm,),
          
          isBookmarkForm==false?recent_bookmarks.length>0?Container(
            padding: const EdgeInsets.fromLTRB(1,0,1,5),
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: recent_bookmarks.length>=3?3:recent_bookmarks.length,
              itemBuilder: (BuildContext context, int index) => 
              CustomListTile(bookmark: recent_bookmarks[index],openWebPage: widget.openWebPage, onChange: toogleOpenTile,),
              // Container(
              //   child: Padding(
              //     padding: const EdgeInsets.all(2.0),
              //     child: Card(
              //       child: Padding(
              //         padding: const EdgeInsets.all(20.0),
              //         child: Center(
              //           child: Text(
              //             recent_bookmarks[index].name.toString(),
              //             style: TextStyle(color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),
              //           )
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ):Container():Container(),
          Container(
            height: MediaQuery.of(context).size.height*0.05,
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(20,0,10,5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Icon(
                            SimpleLineIcons.folder,
                            size: 25,
                            // color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "Kategorie:",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                        ),
                      ),
                    ),
                  ],
                ),
                // Container(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: FlatButton(
                //       color: Colors.cyan,
                //       child: Icon(Icons.add),
                //       onPressed: () {
                //         print("ADD +");
                //         String _date = new DateTime.now().toIso8601String();
                //         widget.db.insert(Category(name: "Motoryzacja "+_date, date: _date).toMap(), 'Categories');
                //         this.getData();
                //       },
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          categories.length>0?Expanded(
            child: Container(
              // color: Theme.of(context).primaryColor.withOpacity(0.3),
              padding: const EdgeInsets.all(10),
              child: Container(
                height:  MediaQuery.of(context).size.width*0.2,
                child: GridView.builder(
                  padding: const EdgeInsets.all(0.0),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: categories.length,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount( 
                    crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 1, 
                    childAspectRatio: categories.length==1?calcGridAspectRatio():1.5,
                  ),

                  itemBuilder: (BuildContext context, int index) => 
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Card(
                        color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              categories[index].name,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                              ),
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ):Container(),
          // Expanded(child: Container(),)
        ],
      ),
    );
  }

}
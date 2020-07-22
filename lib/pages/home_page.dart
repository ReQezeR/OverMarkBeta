import 'package:flutter/material.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/category.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:overmark/tools/bookmark_form.dart';
import 'package:theme_provider/theme_provider.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.db}) : super(key: key);
  final DbProvider db;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List<Bookmark> recent_bookmarks = new List();
  List<Category> categories = new List();
  bool isBookmarkForm = false;
  
  void closeForm(){
    // getData();
    this.isBookmarkForm = false;
    this.setState(() {});
  }

  void getData() async {
    var temp = await widget.db.queryRecentRows('Bookmarks', 'date', 5);
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
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                height: MediaQuery.of(context).size.height*0.08,
                child: SafeArea(
                  child: Center(child: Text("Over Mark", style: TextStyle(fontSize: 35.0, color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),)),
                ),
              ),
              Container(
                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
                height: 2.0,
                child: Container(),
              ),
            ],
          ),
          isBookmarkForm==false?Container(
            height: MediaQuery.of(context).size.height*0.054,
            padding: const EdgeInsets.fromLTRB(10,0,10,0),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.view_week,
                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ostatnie zakładki:",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                        ),
                      )),
                  ],
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      color: Colors.orangeAccent,
                      child: Icon(Icons.add),
                      onPressed: () {
                        print("ADD +");
                        this.isBookmarkForm = true;
                        this.setState(() {});
                        // String _date = new DateTime.now().toIso8601String();
                        // widget.db.insert(Bookmark(categoryId:1, name: "XD", url:"XD_URL", date: _date, recentUpdate: _date).toMap(), 'Bookmarks');
                        // this.getData();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ):BookmarkForm(width: 500, height:550, db: widget.db, closeForm: this.closeForm,),
          
          isBookmarkForm==false?recent_bookmarks.length>0?Container(
            color: Theme.of(context).primaryColor.withOpacity(0.30),
            padding: const EdgeInsets.fromLTRB(10,10,10,10),
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: recent_bookmarks.length>=5?5:recent_bookmarks.length,
              itemBuilder: (BuildContext context, int index) => 
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          recent_bookmarks[index].name.toString(),
                          style: TextStyle(color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ):Container():Container(),
          Container(
            height: MediaQuery.of(context).size.height*0.05,
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(10,0,10,0),
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.view_week,
                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      color: Colors.cyan,
                      child: Icon(Icons.add),
                      onPressed: () {
                        print("ADD +");
                        String _date = new DateTime.now().toIso8601String();
                        widget.db.insert(Category(name: "Motoryzacja "+_date, date: _date).toMap(), 'Categories');
                        this.getData();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          categories.length>0?Expanded(
            child: Container(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
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
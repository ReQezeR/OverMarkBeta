import 'package:flutter/material.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.db}) : super(key: key);
  final DbProvider db;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  List<Bookmark> recent_bookmarks = new List();


  void getData() async {
    var temp = await widget.db.queryRecentRows('Bookmarks', 5);
    recent_bookmarks = toBookmarks(temp);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height*0.2,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text("Over Mark", style: TextStyle(fontSize: 40.0, color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),)),
              ),
          ),
          Container(
            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
            height: 1.0,
            child: Container(),
          ),
          Container(
            color: Colors.transparent,
            child: Row(
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
                        "Ostatnio dodane:",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                        ),
                      )),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            child: GridView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: recent_bookmarks.length>=10?10:recent_bookmarks.length,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 1 : 1),
              itemBuilder: (BuildContext context, int index) => 
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          recent_bookmarks[index].id.toString(),
                          style: TextStyle(color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: Row(
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
                      )),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.2,
            child: GridView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 1 : 1),
              itemBuilder: (BuildContext context, int index) => 
              Container(
                // width: MediaQuery.of(context).size.width * 0.45,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'Dummy Card Text',
                          style: TextStyle(color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Container(
                height: MediaQuery.of(context).size.height*0.15,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
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
                        widget.db.insert(Bookmark(categoryId:1, name: "XD", url:"XD_URL", date: _date).toMap(), 'Bookmarks');
                        this.getData();
                      },
                    ),
                    // FlatButton(
                    //   padding: const EdgeInsets.all(20.0),
                    //   color: Colors.pinkAccent[700],
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     children: <Widget>[
                    //       Padding(
                    //         padding: const EdgeInsets.only(right: 20),
                    //         child: Icon(Icons.add),
                    //       ),
                    //       Text("Querry", style: TextStyle(fontSize: 25),),
                    //     ],
                    //   ),
                    //   onPressed: () async{
                    //     // widget.db.flushTable('Bookmarks');
                    //     print("GET +");
                    //     var temp = await widget.db.queryAllRows('Bookmarks');
                    //     printBookmarks(toBookmarks(temp));
                    //     this.getData();
                    //   },
                    // ),
                  ],
                ),
              ),
          ),
           ),
          
        ],
      ),
    );
  }

}
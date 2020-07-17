import 'package:flutter/material.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/category.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:overmark/tools/data_search.dart';
import 'package:theme_provider/theme_provider.dart';


class ListPage extends StatefulWidget {
  ListPage({Key key, this.db}) : super(key: key);
  final DbProvider db;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>{
  List<Bookmark> bookmarks = new List();

  @override
  void initState(){
    this.getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getData() async {
    var tempB = await widget.db.queryAllRows('Bookmarks');
    this.bookmarks = toBookmarks(tempB);
    this.setState((){});

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column( 
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                height: MediaQuery.of(context).size.height*0.08,
                width: MediaQuery.of(context).size.width,
                child: SafeArea(
                  child: IconButton(
                    alignment: Alignment.centerRight,
                    color: Colors.blueAccent.withOpacity(0.8),
                    onPressed: (){
                      showSearch(context: context, delegate: DataSearch()); 
                    },
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Icon(Icons.search, size: 40,),
                    ),
                  ),
                ),
              ),
              Container(
                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
                height: 2.0,
                child: Container(),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height*0.05,
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
                        "Lista zakładek:",
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
                        String _date = new DateTime.now().toIso8601String();
                        widget.db.insert(Bookmark(categoryId:1, name: "XD", url:"XD_URL", date: _date).toMap(), 'Bookmarks');
                        this.getData();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0.0),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: bookmarks.length,
                itemBuilder: (BuildContext context, int index) => 
                Card(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      // color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(child: Text(bookmarks[index].id.toString()+"    "+bookmarks[index].date.toString())),
                    )),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}


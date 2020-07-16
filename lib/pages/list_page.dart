import 'package:flutter/material.dart';
import 'package:overmark/databases/bookmark.dart';
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
    var temp = await widget.db.queryAllRows('Bookmarks');
    bookmarks = toBookmarks(temp);
    this.setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeProvider.themeOf(context).data.primaryColor,
      child: Column( 
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: IconButton(
              alignment: Alignment.centerRight,
              color: Colors.blueAccent.withOpacity(0.8),
              onPressed: (){
                showSearch(context: context, delegate: DataSearch()); 
              },
              icon: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                child: Icon(Icons.search, size: 40,),
              ),
            ),
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: bookmarks.length,
                itemBuilder: (BuildContext context, int index) => 
                Card(
                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).surfaceColor,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(child: Text(bookmarks[index].id.toString()+"    "+bookmarks[index].date.toString())),
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



import 'package:flutter/material.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/db_provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.db}) : super(key: key);
  final DbProvider db;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
            },
          ),

          FlatButton(
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

          FlatButton(
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
              var temp = await widget.db.queryRecentRows('Bookmarks', 5);
              printBookmarks(toBookmarks(temp));
            },
          ),

          FlatButton(
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
        ],
      ),
    );
  }
}
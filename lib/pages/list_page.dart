import 'package:flutter/material.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';


class ListPage extends StatefulWidget {
  ListPage({Key key, this.db}) : super(key: key);
  final DbProvider db;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>{
  List<Bookmark> bookmarks = new List();
  List<Bookmark> recentBookmarks = new List();
  TextEditingController _controller;
  FocusNode inputFocusNode = new FocusNode();
  bool isInput = false;
  bool isResult = false;

  @override
  void initState(){
    this.getData();
    super.initState();
     _controller = TextEditingController();
     inputFocusNode.addListener(()=>toogleInputFlag()
    );
  }
  void toogleInputFlag(){
    if(isInput) this.isInput=false;
    else this.isInput=true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void getData() async {
    var tempB = await widget.db.queryAllRows('Bookmarks');
    this.bookmarks = toBookmarks(tempB);

    var tempC = await widget.db.queryRecentRows('Bookmarks', 4);
    this.recentBookmarks = toBookmarks(tempC);
    this.setState((){});
  }

  void searchForData() async{
    var temp = await widget.db.search('Bookmarks', 'id', _controller.text);
    this.bookmarks =toBookmarks(temp);
    this.setState(() {});
  }

  void onChange(){
    this.setState((){});
  }
  void changeInputFocus({value}){
    if(isInput){
      FocusScope.of(context).unfocus();
    }
    else {
      FocusScope.of(context).requestFocus(inputFocusNode);
    }
    this.setState((){});
  }

  Widget buildSuggestions(BuildContext context) {
    String query = _controller.text;

    final List<Bookmark> suggestionList = query.isEmpty
        ? recentBookmarks
        : bookmarks.where((p) => p.getFilter().toLowerCase().startsWith(query.toLowerCase())).toList();

    return Container(
      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).surfaceColor,
      child: ListView.builder(
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                query = suggestionList[index].getFilter();
                _controller.text = query;
                this.setState(() {});
              },
              leading: Icon(Icons.label_important),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].getFilter().substring(0, query.length),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionList[index].getFilter().substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
            ),
        itemCount: suggestionList.length<4?suggestionList.length:4,
        padding: const EdgeInsets.all(0.0),
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
              borderRadius:BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height*0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.line_weight,
                                size: 30,
                                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Lista zakładek:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27.0,
                                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                ),
                              )),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(0),
                          child: MaterialButton(
                            padding: EdgeInsets.all(0),
                            shape: CircleBorder(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
                                borderRadius:BorderRadius.all(Radius.circular(20.0))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(Icons.add),
                              )
                            ),
                            onPressed: () {
                              print("ADD +");
                              String _date = new DateTime.now().toIso8601String();
                              widget.db.insert(Bookmark(categoryId:1, name: "XD", url:"XD_URL", date: _date).toMap(), 'Bookmarks');
                              this.getData();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.90,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Material(
                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          onTap: (){
                            changeInputFocus();
                          },
                          child: Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.search, size: 30, color: Colors.blueAccent.withOpacity(0.8),),
                                ),
                              ),
                              Expanded(
                                  child: TextField(
                                    onChanged: (param)=>onChange(),
                                    controller: _controller,
                                    decoration: new InputDecoration.collapsed(
                                      hintText: 'Bookmark'
                                    ),
                                    autocorrect: false,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 22.0,
                                      height: 1.0,
                                      color: Colors.black                  
                                    ),
                                    focusNode: inputFocusNode,
                                    onTap: (){
                                      changeInputFocus();
                                    },
                                    onSubmitted: (String value){
                                      changeInputFocus();
                                      searchForData();
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  isInput?Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: buildSuggestions(context),
                  ):Container(),
                ],
              ),
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


import 'dart:math';
import 'package:flutter/material.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:overmark/tools/bookmark_form.dart';
import 'package:overmark/tools/custom_listtile.dart';
import 'package:overmark/tools/rotate_trans.dart';
import 'package:theme_provider/theme_provider.dart';


class ListPage extends StatefulWidget {
  ListPage({Key key, this.db, this.openWebPage, this.openDetailPage}) : super(key: key);
  final DbProvider db;
  final Function(String)openWebPage;
  final Function (Bookmark)openDetailPage;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{
  List<Bookmark> bookmarks = new List();
  List<Bookmark> recentBookmarks = new List();
  TextEditingController _controller;
  FocusNode inputFocusNode = new FocusNode();
  bool isInput = false;
  bool isResult = false;
  bool isForm = false;

  int openTileID = 0;

  AnimationController _refreshController;
  Animation<double> _refreshAnimation;

  @override
  void initState(){
    this._refreshController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    this._refreshAnimation = Tween<double>(begin: 0, end: pi + pi).animate(_refreshController);
    this.getData();
    super.initState();
    _controller = TextEditingController();
    inputFocusNode.addListener(()=>toogleInputFlag());
  }

  int toogleOpenTile({int id:-1}){
    if(id == 0){
      this.isForm = false;
      FocusScope.of(context).unfocus();
      this.openTileID = 0;
      setState(() {});
    }
    else if(id == -1){
      return this.openTileID;
    }
    else{
      this.isForm = false;
      FocusScope.of(context).unfocus();
      this.openTileID = id;
      setState(() {});
    }
    return openTileID;
  }
  
  void toogleInputFlag(){
    if(isInput) this.isInput=false;
    else this.isInput=true;
    this.setState(() {});
  }

  void closeForm(){
    getData();
    this.isForm = false;
    this.setState(() {});
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void getData() async {
    var tempB = await widget.db.queryAllRows('Bookmarks');
    this.bookmarks = toBookmarks(tempB);

    var tempC = await widget.db.queryRecentRows('Bookmarks', 'recentUpdate', 4);
    this.recentBookmarks = toBookmarks(tempC);
    this.setState((){});
  }

  void searchForData() async{
    var temp = await widget.db.search('Bookmarks', 'name', _controller.text);
    this.bookmarks = toBookmarks(temp);
    String _date = new DateTime.now().toIso8601String();
    for(Bookmark b in this.bookmarks){
      print(b.toMap().toString());
      b.recentUpdate = _date;
      print(b.toMap().toString());
      widget.db.update(b.toMap(), 'Bookmarks');
    }
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
      closeForm();
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
      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
      child: suggestionList.length>0?ListView.builder(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            query = suggestionList[index].getFilter();
            _controller.text = query;
            this.setState(() {});
          },
          leading: Icon(
            Icons.label_important,
            color: Colors.blue,
          ),
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
      ):Container(height: 0,),
    );
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
              borderRadius:BorderRadius.only(
                bottomLeft: isInput?Radius.circular(0.0): Radius.circular(20.0),
                bottomRight: isInput?Radius.circular(0.0): Radius.circular(20.0),
              ),
            ),
            child: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height*0.14,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.line_weight,
                                    size: 28,
                                    // color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                                    color: Colors.blue,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Lista zakładek:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 25.0,
                                      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                    ),
                                  )),
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              isForm==false?Container(
                                padding: EdgeInsets.all(0),
                                child: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ThemeProvider.themeOf(context).id=='dark_theme'?Colors.transparent:ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
                                        borderRadius:BorderRadius.all(Radius.circular(20.0))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Icon(
                                          Icons.add, 
                                          color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor:Colors.white,
                                        ),
                                      )
                                    ),
                                  ),
                                  onTap: () {
                                    print("open +");
                                    FocusScope.of(context).unfocus();
                                    isForm = true;
                                    this.setState(() {});
                                  },
                                ),
                              ):Container(),
                              Container(
                                padding: EdgeInsets.all(0),
                                child: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ThemeProvider.themeOf(context).id=='dark_theme'?Colors.transparent:Colors.green[500],
                                        borderRadius:BorderRadius.all(Radius.circular(20.0))
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: RotateTrans(
                                          Icon(
                                            Icons.autorenew,
                                            color: ThemeProvider.themeOf(context).id=='dark_theme'?Colors.green[500]:Colors.white,
                                          ),
                                          _refreshAnimation
                                        ),
                                      )
                                    ),
                                  ),
                                  onTap: () {
                                    print("refresh");
                                    _refreshController.forward(from: 0);
                                    getData();
                                    this.setState(() {});
                                  },
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width*0.9,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5,10,5,10),
                        child: Material(
                          color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).surfaceColor:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
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
                                      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,                 
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
                                _controller.text.length>0?InkWell(
                                  onTap: (){
                                    _controller.text="";
                                    this.setState(() {});
                                  },
                                    child: Container(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.clear, size: 30, color: Colors.redAccent.withOpacity(0.8),),
                                    ),
                                  ),
                                ):Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
              child: Stack(
                fit: StackFit.loose,
                overflow: Overflow.clip,
                children: <Widget>[
                  Container(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: bookmarks.length,
                      itemBuilder: (BuildContext context, int index) => 
                      CustomListTile(bookmark: bookmarks[index], openWebPage: widget.openWebPage, openDetailPage: widget.openDetailPage, onChange: toogleOpenTile),
                    ),
                  ),
                  isForm?Positioned(
                    top: 5,
                    left: (MediaQuery.of(context).size.width-400)/4,
                    right: (MediaQuery.of(context).size.width-400)/4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: 400,
                        child: BookmarkForm(width: 400, height:550, db: widget.db, closeForm: this.closeForm,),
                      ),
                    ),
                  ):Container(),

                  isInput?Container(
                    decoration: BoxDecoration(
                      color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
                      borderRadius:BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(20,10,20,15),
                        child: buildSuggestions(context),
                      ),
                  ):Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


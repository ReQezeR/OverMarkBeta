import 'dart:math';
import 'package:OverMark/services/admob_provider.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:OverMark/databases/bookmark.dart';
import 'package:OverMark/databases/db_provider.dart';
import 'package:OverMark/themes/theme_options.dart';
import 'package:OverMark/tools/bookmark_form.dart';
import 'package:OverMark/tools/custom_listtile.dart';
import 'package:OverMark/tools/rotate_trans.dart';
import 'package:theme_provider/theme_provider.dart';


class ListPage extends StatefulWidget {
  ListPage({Key key, this.db, this.openWebPage, this.openDetailPage}) : super(key: key);
  final DbProvider db;
  final Function(Bookmark)openWebPage;
  final Function (Bookmark, Function)openDetailPage;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin{
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
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

  // AdMob 
  bool isAd = false;
  // AdmobInterstitial interstitialAd;

  // void handleEvent(
  //     AdmobAdEvent event, Map<String, dynamic> args, String adType) {
  //   switch (event) {
  //     case AdmobAdEvent.loaded:
  //       // showSnackBar('New Admob $adType Ad loaded!');
  //       break;
  //     case AdmobAdEvent.opened:
  //       // showSnackBar('Admob $adType Ad opened!');
  //       break;
  //     case AdmobAdEvent.closed:
  //       // showSnackBar('Admob $adType Ad closed!');
  //       break;
  //     case AdmobAdEvent.failedToLoad:
  //       showSnackBar('Admob $adType failed to load. :(');
  //       break;
  //     default:
  //   }
  // }

  // void showSnackBar(String content) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(content),
  //       duration: Duration(milliseconds: 1500),
  //     ),
  //   );
  // }

  //AdMob end

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
    // String _date = new DateTime.now().toIso8601String();
    // for(Bookmark b in this.bookmarks){
    //   print(b.toMap().toString());
    //   b.recentUpdate = _date;
    //   print(b.toMap().toString());
    //   widget.db.update(b.toMap(), 'Bookmarks');
    // }
    // this.setState(() {});
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
            Icons.text_fields,
            color: Colors.blueAccent.withOpacity(0.8),
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
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
                                      Icons.collections_bookmark,
                                      size: 28,
                                      color: Colors.blueAccent.withOpacity(0.8),
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
                                    focusColor: Colors.transparent,
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
                          padding: const EdgeInsets.fromLTRB(5,15,5,5),
                          child: Material(
                            color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).surfaceColor:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            child: InkWell(
                              focusColor: Colors.transparent,
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
                                        hintText: 'Szukaj'
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
                  // overflow: Overflow.clip,
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    Container(
                      child: bookmarks.length>0?ListView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: bookmarks.length,
                        itemBuilder: (BuildContext context, int index){
                          if(index != 0 && index %6==0){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(1, 5, 1, 2),
                                  child: Card(
                                    color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
                                    elevation: 3.0,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(10,5,10,5),
                                      child: Container(
                                        margin: EdgeInsets.all(5.0),
                                        child: AdmobBanner(
                                          nonPersonalizedAds: true,
                                          adUnitId: AdMobStatic.bannerAdUnitId,
                                          // 320 x 50
                                          // 468 x 60
                                          adSize: AdmobBannerSize.ADAPTIVE_BANNER(width: (MediaQuery.of(context).size.width*0.9).toInt()),
                                          listener: (AdmobAdEvent event,Map<String, dynamic> args) {
                                            // handleEvent(event, args, 'Banner');
                                          },
                                          onBannerCreated:(AdmobBannerController controller) {setState(() {isAd = true;});},
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(1, 5, 1, 2),
                                  child: CustomListTile(
                                    bookmark: bookmarks[index>=bookmarks.length?index%bookmarks.length:index], 
                                    openWebPage: widget.openWebPage, 
                                    openDetailPage: widget.openDetailPage, 
                                    onChange: toogleOpenTile, 
                                    refresh: getData,
                                    height: 115,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(1, 5, 1, 2),
                            child: CustomListTile(
                              bookmark: bookmarks[index>=bookmarks.length?index%bookmarks.length:index], 
                              openWebPage: widget.openWebPage, 
                              openDetailPage: widget.openDetailPage, 
                              onChange: toogleOpenTile, 
                              refresh: getData,
                              height: 115,
                            ),
                          );
                        }
                      ):Container(),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


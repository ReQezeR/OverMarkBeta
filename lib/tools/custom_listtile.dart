import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:OverMark/databases/bookmark.dart';
import 'package:OverMark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomListTile extends StatefulWidget {
  CustomListTile({Key key, this.bookmark, this.openWebPage, this.openDetailPage, this.onChange, this.refresh}) : super(key: key);
  final Bookmark bookmark;
  final Function(Bookmark)openWebPage;
  final Function (Bookmark, Function)openDetailPage;
  final Function onChange;
  final Function refresh;

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile>{
  bool isOpen = false;
  int openTileID = 0;
  
  @override
  void initState() {
    super.initState();
    checkTile();
  }

  void checkTile(){
    openTileID = widget.onChange(id:-1);
    if(widget.bookmark.id == openTileID){
      isOpen = true;
    }
    else{
      isOpen = false;
    }
  }

  void toogleTile(){
    if(isOpen){
      isOpen = false;
      openTileID = widget.onChange(id:0);
    }
    else {
      isOpen = true;
      openTileID = widget.onChange(id: widget.bookmark.id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    checkTile();
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => toogleTile(),
        child:Padding(
          padding: const EdgeInsets.all(2),
          child: Card(
            color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
            elevation: 3.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[

                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 0.6,
                            colors: [
                              Colors.amber[400],
                              Colors.amber[600],
                              Colors.amber[800],
                            ]
                          )
                        ),
                        child: Center(
                          child: Text(
                            widget.bookmark.id.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Theme.of(context).brightness == Brightness.light?Colors.black:Colors.grey[200],
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  // color: Colors.red,
                                  height: 40,
                                  child: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.bookmark.name.toString(),
                                          style: TextStyle(
                                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                            fontWeight: FontWeight.w400,
                                            fontSize: 25,
                                          ),
                                          maxLines: 1,

                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Container(
                                  height: 40,
                                  // color: Theme.of(context).brightness == Brightness.light?Colors.blueGrey[50]:Colors.black38,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                          child: Icon(
                                            SimpleLineIcons.link,
                                            size: 15,
                                            color: Theme.of(context).brightness == Brightness.light?Colors.black:ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            widget.bookmark.url.toString(),
                                            style: TextStyle(
                                              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                              fontWeight: FontWeight.w300,
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        onLongPress: (){Clipboard.setData(ClipboardData(text: widget.bookmark.url.toString()));},
                        onTap: (){Clipboard.setData(ClipboardData(text: widget.bookmark.url.toString()));},
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.all(0),
                          padding: EdgeInsets.all(0),
                          // color: Colors.amber,
                          child: InkWell(
                            child: Icon(
                              Icons.content_copy,
                              color: Colors.grey,
                            ),
                            // onLongPress: (){Clipboard.setData(ClipboardData(text: widget.bookmark.url.toString()));},
                            // onTap: (){Clipboard.setData(ClipboardData(text: widget.bookmark.url.toString()));},
                          ),
                        ),
                      )
                    ],
                  ),
                  isOpen?Padding(
                    padding: const EdgeInsets.fromLTRB(5.0,10.0,5.0,0.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: InkWell(
                              onTap: () =>widget.openWebPage(widget.bookmark),
                              child: Card(
                                margin: EdgeInsets.fromLTRB(5,0,5,0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.transparent, width: 0)
                                ),
                                color: Theme.of(context).brightness == Brightness.light?Colors.transparent:Colors.black38,
                                shadowColor: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                                  child:Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.web,
                                            color: Colors.blueAccent.withOpacity(0.8),
                                          ),
                                        ),
                                        Text(
                                          "Otwórz",
                                          style: TextStyle(
                                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    )
                                  )
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => widget.openDetailPage(widget.bookmark, widget.refresh),
                              child: Card(
                                margin: EdgeInsets.fromLTRB(5,0,5,0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.transparent, width: 0)
                                ),
                                color: Theme.of(context).brightness == Brightness.light?Colors.transparent:Colors.black38,
                                shadowColor: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                                  child:Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.info_outline,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        Text(
                                          "Informacje",
                                          style: TextStyle(
                                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    )
                                  )
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ):Container(),
                ],
              ),
          )),
        ),
      ),
    );
  }
}
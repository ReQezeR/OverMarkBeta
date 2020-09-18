import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomListTile extends StatefulWidget {
  CustomListTile({Key key, this.bookmark, this.openWebPage, this.openDetailPage, this.onChange, this.refresh}) : super(key: key);
  final Bookmark bookmark;
  final Function(String)openWebPage;
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
            // color: Colors.transparent,
            // elevation: 0.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0,15.0,0.0,15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 40,
                        // color: Colors.amber,
                        child: Center(
                          child: Text(
                            widget.bookmark.id.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Theme.of(context).brightness == Brightness.light?Colors.black:widget.bookmark.id%2==1?Colors.grey: Colors.grey[200],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5.0,0.0,5.0,0.0),
                          child: Container(
                            // color: Theme.of(context).brightness == Brightness.light?Colors.blueGrey[50]:Colors.black38,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    height: 40,
                                    constraints: BoxConstraints(minWidth: 50,maxWidth: MediaQuery.of(context).size.width*0.25),
                                    child: Container(
                                      color: Theme.of(context).brightness == Brightness.light?Colors.blueGrey[50]:Colors.black38,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            widget.bookmark.name.toString(),
                                            style: TextStyle(
                                              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            ),
                                            maxLines: 1,

                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Container(
                                      height: 40,
                                      color: Theme.of(context).brightness == Brightness.light?Colors.blueGrey[50]:Colors.black38,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          // crossAxisAlignment: CrossAxisAlignment.baseline,
                                          // textBaseline: TextBaseline.alphabetic,
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
                                              child: Center(
                                                child: Text(
                                                  widget.bookmark.url.toString(),
                                                  style: TextStyle(
                                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                  ),
                                                  maxLines: 1,
                                                )
                                              ),
                                            ),
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
                              onTap: () =>widget.openWebPage(widget.bookmark.url.toString()),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.blue, width: 3)
                                ),
                                color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                                  child:Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.web
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: BorderSide(color: Colors.green, width: 3)
                                ),
                                color: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                                  child:Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Icon(
                                            Icons.info_outline
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
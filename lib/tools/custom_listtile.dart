import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class CustomListTile extends StatefulWidget {
  CustomListTile({Key key, this.bookmark}) : super(key: key);
  final Bookmark bookmark;

  @override
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile>{
  bool isOpen = false;

  void toogleTile(){
    if(isOpen){
      isOpen = false;
    }
    else isOpen = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => toogleTile(),
        child:Padding(
          padding: const EdgeInsets.fromLTRB(1.0,1.0,1.0,1.0),
          child: Card(
            color: Theme.of(context).brightness == Brightness.light?Colors.white:ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0,10.0,15.0,10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5,10,5,10),
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
                            padding: const EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                            child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      color: Theme.of(context).brightness == Brightness.light?Colors.blueGrey[50]:Colors.grey[800],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0,5,5,5),
                                              child: Icon(
                                                Icons.title,
                                                size: 15,
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  widget.bookmark.name.toString(),
                                                  style: TextStyle(
                                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 17,
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

                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      color: Theme.of(context).brightness == Brightness.light?Colors.blueGrey[50]:Colors.grey[800],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0,5,5,5),
                                              child: Icon(
                                                Icons.insert_link,
                                                size: 15,
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  widget.bookmark.url.toString(),
                                                  style: TextStyle(
                                                    color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 17,
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

                      Container(
                        child: InkWell(
                          child: Icon(
                            Icons.content_copy,
                            color: Colors.grey,
                          ),
                          onLongPress: (){Clipboard.setData(ClipboardData(text: widget.bookmark.url.toString()));},
                          onTap: (){Clipboard.setData(ClipboardData(text: widget.bookmark.url.toString()));},
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
                            child: Card(
                              color: Colors.blue,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                                child:InkWell(
                                  child: Center(
                                    child: Text(
                                      "Open Website",
                                      style: TextStyle(
                                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                )
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10.0,10.0,10.0,10.0),
                                child:InkWell(
                                  child: Center(
                                    child: Text(
                                      "Show Details",
                                      style: TextStyle(
                                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,  
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                )
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
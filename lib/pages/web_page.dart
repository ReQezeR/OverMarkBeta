import 'package:flutter/material.dart';
import 'package:OverMark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget{
  final String url;
  WebPage({this.url});

  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage>{
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeProvider.themeOf(context).id=='dark_theme'?ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor:Theme.of(context).primaryColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "WebPage",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 25.0,
                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                ),
              ),
              // Expanded(
              //   child: Center(
              //     child: Text(
              //       widget.url,
              //       style: TextStyle(
              //         fontWeight: FontWeight.w300,
              //         fontSize: 20.0,
              //         color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
              //       ),
              //     )
              //   )
              // )
            ],
          ),
          leading: FlatButton(
            child: Icon(
              Icons.arrow_back,
              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor,
            ),
            onPressed: () {Navigator.of(context).pop(true);},
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                color: Colors.transparent,
                child: InkWell(
                  onTap: ()=>_controller?.loadUrl("https://"+widget.url),
                  child:Padding(
                    padding: const EdgeInsets.fromLTRB(20,0,20,0),
                    child: Icon(
                      Icons.home,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                color: Colors.transparent,
                child: InkWell(
                  onTap: ()=>_controller?.reload(),
                  child:Padding(
                    padding: const EdgeInsets.fromLTRB(20,0,20,0),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Material(
          child: WebView(
            initialUrl: "https://"+widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller){
              _controller = controller;
            },

          ),
        ),
      ),
    );
  }
}
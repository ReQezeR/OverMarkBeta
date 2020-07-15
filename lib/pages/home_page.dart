import 'package:flutter/material.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: Colors.grey[900],
            height: 200.0,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(child: Text("Over Mark", style: TextStyle(fontSize: 40.0, color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),)),
              ),
          ),
          Container(
            color: Colors.amber,
            height: 1.0,
            child: Container(),
          ),
          Container(
            color: Colors.transparent,
            child: Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.view_week,
                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Ostatnio dodane:",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                        ),
                      )),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200.0,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (BuildContext context, int index) => 
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      'Dummy Card Text',
                      style: TextStyle(color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor),
                    )
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
import 'package:flutter/material.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/pages/home_page.dart';
import 'package:overmark/pages/list_page.dart';
import 'package:overmark/pages/settings_page.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:sqflite/sqflite.dart';
import 'package:theme_provider/theme_provider.dart';


class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;
 
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final dbProvider = DbProvider.instance;

  int _currentIndex = 1;
  int _targetIndex = 1;
  bool _isjump = false;

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      // print("pageChanged "+_currentIndex.toString()+" -> "+index.toString());
      _currentIndex = index;
      if(index == _targetIndex && _isjump == true){
        _targetIndex = index;
        _isjump = false;
      }
      else if(_isjump == false){
        _targetIndex = index;
      }
    });
  }
  void bottomTapped(int index) {
      setState(() {
        _targetIndex = index;
        _isjump = true;
        pageController.animateToPage(index, duration: Duration(milliseconds: 400), curve: Curves.ease);
      });
    }

  @override
  Widget build(BuildContext context) {
    Color accent =  ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor;
    Color detail =  ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor;

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Container(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                pageChanged(index);
              },
              children: <Widget>[
                ThemeConsumer(child: ListPage(db: dbProvider)),
                HomePage(db: dbProvider),
                SettingsPage(db: dbProvider),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            title: Container(
              child: Icon(Icons.arrow_drop_up, 
              color: _targetIndex==0? Colors.blue[400]: Colors.transparent,
              ),
            ),
            icon: Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,0),
              child: _targetIndex==0?Icon(Icons.view_list, color: accent,): Icon(Icons.view_list, color: detail),
            ),
          ),

          BottomNavigationBarItem(
            title: Container(
              child: Icon(
                Icons.arrow_drop_up, 
                color: _targetIndex==1? Colors.blue[400]: Colors.transparent,
              )
            ),
            icon: Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,0),
              child:_targetIndex==1?Icon(Icons.home, color: accent,): Icon(Icons.home, color: detail),
            )
          ),

          BottomNavigationBarItem(
            title: Container(
              child: Icon(
                Icons.arrow_drop_up, 
                color: _targetIndex==2? Colors.blue[400]: Colors.transparent,
              )
            ),
            icon: Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,0),
              child: _targetIndex==2?Icon(Icons.settings,color: accent,): Icon(Icons.settings, color: detail),
            ),
          ),
        ],
        onTap: (index) {
          bottomTapped(index);
        },
      ),
    );
  }
}
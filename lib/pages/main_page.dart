import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/pages/home_page.dart';
import 'package:overmark/pages/list_page.dart';
import 'package:overmark/pages/settings_page.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:overmark/tools/custom_pageview.dart';
import 'package:theme_provider/theme_provider.dart';


class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;
 
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final dbProvider = DbProvider.instance;
  ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  AnimationController _indicatorController;
  NotifyingPageView customPageView;

  int _currentIndex = 1;
  int _targetIndex = 1;
  bool _isjump = false;
  bool isGradient = false;
  bool isInit= false;

  void toogleGradientState(){
    isGradient = !isGradient;
    setState(() {});
  }
  bool getGradientState(){
    return isGradient;
  }

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  @override
  void initState() {
    initPageView();
    _initAnimationController();
    super.initState();
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    _notifier?.dispose();
    super.dispose();
  }

  void _initAnimationController(){
    _indicatorController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  void pageChanged(int index) {
    setState(() {
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
      customPageView..navigateToPage(index);
    });
  }

  LinearGradient getGradient(int version){
    // light_gradient - 0
     // dark_gradient  - 1
    LinearGradient lightGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xDFFFFFFF), 
        Color(0x2F486C7C),
        Color(0x2F486C7C),
        Color(0xDFFFFFFF),
      ],
      stops: [
        0,
        0.6,
        0.9,
        1
      ],
    );
    LinearGradient darkGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF202750), 
        Color(0xFF203A43),
        Color(0xFF2C5364),
        Color(0xFF202750),
      ],
      stops: [
        0,
        0.4,
        0.9,
        1
      ],
    );

    if (version == 0){
      return lightGradient;
    }
    else if (version == 1){
      return darkGradient;
    }
    else return darkGradient;
  }

  double getOffset(int pageNumber){
    if(pageNumber == 0){
      if(_notifier.value<=0.5 && _notifier.value>=0.0){
        return _notifier.value;
      }
      else return 0.5;
    }
    else if(pageNumber == 1){
      if(_notifier.value<=1.5 && _notifier.value>0.5){
        return _notifier.value-pageNumber;
      }
      else return 0.0;
    }
    else if(pageNumber == 2){
      if(_notifier.value<=2.0 && _notifier.value>1.5){
        return _notifier.value-pageNumber;
      }
      else return 0.0;
    }

    print(_notifier.value);
    return 0.0;
  }

  void initPageView(){
    customPageView = NotifyingPageView(
      currentPage: _currentIndex,
      notifier: _notifier,
      pageChanged: pageChanged,
      pages: <Widget>[
        ThemeConsumer(child: ListPage(db: dbProvider)),
        ThemeConsumer(child:HomePage(db: dbProvider)),
        ThemeConsumer(child:SettingsPage(db: dbProvider, toogleGradientState: toogleGradientState, getGradientState: getGradientState,)),
      ],
    );
  }

  BottomNavigationBarItem getCustomItem({int id, Color accent, Color detail, IconData icon, Color iconColor}){
    return BottomNavigationBarItem(
      title: Container(
        width: 40,
        height: 10,
        child: _currentIndex==id?AnimatedBuilder(
          animation: _notifier,
          builder: (context, _) {
            return Transform.translate(
              offset: Offset(15 * getOffset(id), -8),
              child:  Icon(
                Icons.arrow_drop_up, 
                color: _targetIndex==id? iconColor: Colors.transparent,
              ),
            );
          },
        ):Container(),
      ),
      icon: Padding(
        padding: const EdgeInsets.fromLTRB(0,10,0,0),
        child: _targetIndex==id?Icon(icon, color: iconColor,): Icon(icon, color: detail),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accent =  ThemeProvider.optionsOf<CustomThemeOptions>(context).accentIconColor;
    Color detail =  ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultDetailColor;
    isInit?isInit = true:isGradient = ThemeProvider.optionsOf<CustomThemeOptions>(context).isGradientEnabled;
    isInit = true;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: InkWell(
        onTap: (){FocusScope.of(context).unfocus();},
        child: Container(
          decoration: isGradient?BoxDecoration(
            gradient: getGradient(ThemeProvider.themeOf(context).id == "dark_theme"?1:0),
          ):ThemeProvider.themeOf(context).id == "dark_theme"?BoxDecoration(
            color: Theme.of(context).primaryColor,
          ):BoxDecoration(
            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
          ),
          child: Container(
            child: customPageView,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedFontSize: 5.0,
        unselectedFontSize: 5.0,
        items: [
          getCustomItem(id: 0,accent: accent, detail: detail, icon: Icons.line_weight, iconColor: Colors.blue[400]),
          getCustomItem(id: 1,accent: accent, detail: detail, icon: Icons.home, iconColor: Colors.amber),
          getCustomItem(id: 2,accent: accent, detail: detail, icon: Icons.settings, iconColor: Colors.red),
        ],
        onTap: (index) {
          bottomTapped(index);
        },
      ),
    );
  }
}
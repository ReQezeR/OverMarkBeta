import 'package:flutter/material.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';



class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;
 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _currentIndex = 1;

  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  void bottomTapped(int index) {
      setState(() {
        _currentIndex = index;
        pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: new AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).accentColor
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,
            ),
          ),
        ),
      ),

      body: Container(
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            pageChanged(index);
          },
          children: <Widget>[
            Container(color: Colors.limeAccent,),
            Container(color: Colors.red,),
            Container(color: Colors.blue,),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            title: Container(child: Icon(Icons.arrow_drop_up, color: Colors.blue[400],)),
            icon: Icon(Icons.view_list, color: Colors.grey,),
            activeIcon:  Icon(Icons.view_list),
          ),

          BottomNavigationBarItem(
            title: Container(child: Icon(Icons.arrow_drop_up, color: Colors.blue[400],)),
            icon: Icon(Icons.home, color: Colors.grey,),
            activeIcon:  Icon(Icons.home),
          ),

          BottomNavigationBarItem(
            title: Container(child: Icon(Icons.arrow_drop_up, color: Colors.blue[400],)),
            icon: Icon(Icons.access_alarms, color: Colors.grey,),
            activeIcon:  Icon(Icons.access_alarms),
          ),
        ],
        onTap: (index) {
          bottomTapped(index);
        },
      ),
    );
  }
}
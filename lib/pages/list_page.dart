import 'package:flutter/material.dart';


class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column( 
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 100,
            child: Center(child: Text("XD")),
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: 15,
                itemBuilder: (BuildContext context, int index) => 
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(child: Text('Dummy Card Text')),
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


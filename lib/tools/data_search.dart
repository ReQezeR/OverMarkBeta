import 'package:flutter/material.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';


class DataSearch extends SearchDelegate<String> {
  DataSearch({
    String hintText = "Szukaj",
  }) : super(
    searchFieldLabel: hintText,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.search,
      
  );


  final cities = [
    "Bhandup",
    "Mumbai",
    "Visakhapatnam",
    "Coimbatore",
    "Delhi",
    "Bangalore",
    "Pune",
    "Nagpur",
    "Lucknow",
    "Vadodara",
    "Indore",
    "Jalalpur",
    "Bhopal",
    "Kolkata",
    "Kanpur",
    "New Delhi",
    "Faridabad",
    "Rajkot",
    "Ghaziabad",
    "Chennai",
    "Meerut",
    "Agra",
    "Jaipur",
    "Jabalpur",
    "Varanasi",
    "Allahabad",
    "Hyderabad",
    "Noida",
    "Howrah",
    "Thane"
  ];

  final recentCities = [
    "New Delhi",
    "Faridabad",
    "Rajkot",
    "Ghaziabad",
  ];


  @override
  ThemeData appBarTheme(BuildContext context) => ThemeProvider.themeOf(context).data.copyWith(
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: Theme.of(context).textTheme.title.copyWith(color: Colors.white60,),
    ),
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Container(
        height: 100.0,
        width: 200.0,
        child: Card(
          color: Colors.red,
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentCities
        : cities.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();

    return Container(
      color: ThemeProvider.optionsOf<CustomThemeOptions>(context).surfaceColor,
      child: ListView.builder(
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                query = suggestionList[index];
                showResults(context);
              },
              leading: Icon(Icons.label_important),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: suggestionList[index].substring(query.length),
                          style: TextStyle(color: Colors.grey))
                    ]),
              ),
            ),
        itemCount: suggestionList.length,
      ),
    );
  }
}
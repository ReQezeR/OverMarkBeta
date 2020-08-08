import 'package:flutter/material.dart';
import 'package:overmark/databases/bookmark.dart';
import 'package:overmark/databases/category.dart';
import 'package:overmark/databases/db_provider.dart';
import 'package:overmark/themes/theme_options.dart';
import 'package:theme_provider/theme_provider.dart';

class BookmarkForm extends StatefulWidget {
  BookmarkForm({Key key, this.db, this.closeForm, this.width, this.height}) : super(key: key);
  final double width;
  final double height;
  final DbProvider db;
  final Function closeForm;

  @override
  _BookmarkFormState createState() => _BookmarkFormState();
}

class _BookmarkFormState extends State<BookmarkForm>{
  CustomInputField nameField;
  CustomInputField urlField;
  CustomCategoryField categoryField;
  bool nameFieldValidation = true;
  bool urlFieldValidation = true;
  bool categoryFieldValidation = true;

  @override
  Widget build(BuildContext context){
    nameField = CustomInputField(width: widget.width, height: widget.height, name: "Nazwa", icon: Icons.details, validate:nameFieldValidation);
    urlField = CustomInputField(width: widget.width, height: widget.height, name: "URL", icon: Icons.insert_link, validate:urlFieldValidation);
    categoryField = CustomCategoryField(width: widget.width, height: widget.height, name: "Kategoria", icon: Icons.category, db: widget.db, validate:categoryFieldValidation);
    return Container(
       decoration: BoxDecoration(
        color: ThemeProvider.themeOf(context).id=='dark_theme'?Colors.grey[900]:Colors.white,
        borderRadius:BorderRadius.all(Radius.circular(20.0)),
        border: Border.all(width: 1)
      ),
      width: widget.width,
      // height: widget.height,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Column(
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add,
                                color: Colors.amber,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Dodaj nową zakładkę",
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 25.0,
                                  color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.all(Radius.circular(20.0))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(Icons.clear),
                            )
                          ),
                          onTap: () {
                            print("close +");
                            FocusScope.of(context).unfocus();
                            widget.closeForm();
                            this.setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: nameField,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: urlField,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: categoryField,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: RaisedButton(
                  color: ThemeProvider.themeOf(context).id=='dark_theme'?Colors.amber:Colors.blue,
                  onPressed: () async{
                    bool validationFlag = true;
                    if(nameField.textData.length==0){
                      nameFieldValidation = false;
                      validationFlag = false;
                      print(nameField.textData);
                    }
                    else nameFieldValidation = true;

                    if(urlField.textData.length==0){
                      urlFieldValidation = false;
                      validationFlag = false;
                      print(urlField.textData);
                    }
                    else urlFieldValidation = true;

                    if(categoryField.textData.length==0){
                      categoryFieldValidation = false;
                      validationFlag = false;
                    }
                    else {
                      categoryFieldValidation = true; 
                      if(categoryField.categoryData.id == null){
                        String _date = new DateTime.now().toIso8601String();
                        widget.db.insert(Category(name: categoryField.categoryData.name, date: _date).toMap(), 'Categories');
                        var temp = await widget.db.search('Categories', 'name', categoryField.categoryData.name);
                        var tempCategories  = toCategories(temp);
                        categoryField.categoryData = tempCategories[0];
                      }
                    }
                    if(validationFlag==true){
                      String _date = new DateTime.now().toIso8601String();
                      widget.db.insert(Bookmark(categoryId:categoryField.categoryData.id, name: nameField.textData, url:urlField.textData, date: _date, recentUpdate: _date).toMap(), 'Bookmarks');
                    }
                    this.setState(() {});
                    FocusScope.of(context).unfocus();
                    widget.closeForm();
                    this.setState(() {});
                  },
                  child: Text(
                    'Dodaj',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class CustomInputField extends StatefulWidget {
  CustomInputField({Key key,this.name, this.icon, this.width, this.height, this.validate}) : super(key: key);
  final double width;
  final double height;
  final String name;
  final IconData icon;
  bool validate = true;
  String textData = "";

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField>{
  TextEditingController _controller;
  FocusNode inputFocusNode = new FocusNode();
  bool isInput = false;
  bool isResult = false;


  @override
  void initState(){
    super.initState();
     _controller = TextEditingController();
     inputFocusNode.addListener(()=>toogleInputFlag());
  }
  void toogleInputFlag(){
    if(isInput) this.isInput=false;
    else this.isInput=true;
    print(widget.name+" toogle flag "+isInput.toString());
    this.setState((){});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeInputFocus(){
    if(isInput){
      FocusScope.of(context).unfocus();
    }
    else {
      FocusScope.of(context).unfocus();
      this.setState((){});
      FocusScope.of(context).requestFocus(inputFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color fieldStatusColor = Colors.red;
    Color activeColor = ThemeProvider.themeOf(context).id=='dark_theme'?Colors.amber:Colors.blue;
    Color activeTextColor = ThemeProvider.themeOf(context).id=='dark_theme'?Colors.white:Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
        borderRadius:BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 1, color: widget.validate?isInput?activeColor:Colors.black26:fieldStatusColor)
      ),
      width: widget.width*0.8,
      height: widget.height*0.10,
      child: Material(
          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
          shadowColor: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            onTap: () {changeInputFocus();},
            child: SizedBox(
            width:  widget.width*0.8,
            height: widget.height*0.15,
            child: Row(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      widget.icon,
                      color: widget.validate?isInput?activeColor:ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor:fieldStatusColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: TextFormField(
                      focusNode: inputFocusNode,
                      autocorrect: false,
                      decoration: new InputDecoration.collapsed(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        hintText: widget.name,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: widget.validate?
                          isInput?activeTextColor:ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                          :ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor
                        )
                      ),
                      controller: _controller,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20.0,
                        height: 1.0,
                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,               
                      ),
                      autofocus: false,
                      onChanged: (value){widget.textData = _controller.text;},
                      onTap: (){
                        changeInputFocus();
                      },
                    ),
                  ),
                ),
                _controller.text.length>0?Container(
                  child: InkWell(
                      onTap: (){_controller.text="";this.setState(() {});},
                      child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.clear,
                        size: 25,
                        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor,
                      ),
                    ),
                  ),
                ):Container(),
              ],
            ),
          ),
        ),
      )
    );
  }
}



class CustomCategoryField extends StatefulWidget {
  CustomCategoryField({Key key,this.name, this.icon, this.width, this.height, this.db, this.validate}) : super(key: key);
  final double width;
  final double height;
  final String name;
  final IconData icon;
  final DbProvider db;
  bool validate = true;
  String textData = "";
  Category categoryData;

  @override
  _CustomCategoryFieldState createState() => _CustomCategoryFieldState();
}

class _CustomCategoryFieldState extends State<CustomCategoryField>{
  TextEditingController _controller;
  FocusNode inputFocusNode = new FocusNode();
  List<Category> categories = new List();
  bool isInput = false;
  bool isResult = false;


  @override
  void initState(){
    getData();
    super.initState();
     _controller = TextEditingController();
     inputFocusNode.addListener(()=>toogleInputFlag());
  }
  void toogleInputFlag(){
    if(isInput) this.isInput=false;
    else this.isInput=true;
    print(widget.name+" toogle flag "+isInput.toString());
    this.setState((){});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeInputFocus(){
    if(isInput){
      FocusScope.of(context).unfocus();
    }
    else {
      FocusScope.of(context).unfocus();
      this.setState((){});
      FocusScope.of(context).requestFocus(inputFocusNode);
    }
  }

  void getData() async {
    var temp = await widget.db.queryAllRows('Categories');
    this.categories = toCategories(temp);
    this.setState((){});
  }

  Widget buildSuggestions(BuildContext context) {
    String query = _controller.text;

    final List<Category> suggestionList = query.isEmpty
        ? List()
        : categories.where((p) => p.name.toLowerCase().startsWith(query.toLowerCase())).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).surfaceColor,
      ),
      child: ListView.builder(
        itemBuilder: (context, index) => ListTile(
          onTap: () {
            query = suggestionList[index].name;
            _controller.text = query;
            widget.categoryData = suggestionList[index];
            this.setState(() {});
          },
          leading: Icon(
            Icons.label_important,
            color: ThemeProvider.themeOf(context).id=='dark_theme'?Colors.cyan[700]:Colors.blue,
          ),
          title: RichText(
            text: TextSpan(
              text: suggestionList[index].name.substring(0, query.length),
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: suggestionList[index].name.substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ],
            ),
          ),
        ),
        itemCount: suggestionList.length<5?suggestionList.length:5,
        padding: const EdgeInsets.all(0.0),
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Color fieldStatusColor = Colors.red;
    Color activeColor = ThemeProvider.themeOf(context).id=='dark_theme'?Colors.amber:Colors.blue;
    Color activeTextColor = ThemeProvider.themeOf(context).id=='dark_theme'?Colors.white:Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
        borderRadius:BorderRadius.all(Radius.circular(10.0)),
        border: Border.all(width: 1, color: widget.validate?isInput?activeColor:Colors.black26:fieldStatusColor)
      ),
      width: widget.width*0.8,
      child: Material(
          color: ThemeProvider.optionsOf<CustomThemeOptions>(context).backgroundColor,
          shadowColor: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            onTap: () {changeInputFocus();},
            child: Column(
              children: <Widget>[
                SizedBox(
                width:  widget.width*0.8,
                height: widget.height*0.10,
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          widget.icon,
                          color: widget.validate?isInput?activeColor:ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor:fieldStatusColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: TextFormField(
                          focusNode: inputFocusNode,
                          autocorrect: false,
                          decoration: new InputDecoration.collapsed(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            hintText: widget.name,
                            hintStyle: TextStyle(color: isInput?activeTextColor:ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor)
                          ),
                          controller: _controller,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            decoration: TextDecoration.none,
                            fontSize: 20.0,
                            height: 1.0,
                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).mainTextColor,                 
                          ),
                          autofocus: false,
                          onChanged: (value){
                            widget.textData = _controller.text;
                            widget.categoryData = Category(name: _controller.text);
                            this.setState(() {});
                          },
                          onTap: (){
                            changeInputFocus();
                          },
                        ),
                      ),
                    ),
                    _controller.text.length>0?Container(
                      child: InkWell(
                          onTap: (){_controller.text="";this.setState(() {});},
                          child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.clear,
                            size: 25,
                            color: ThemeProvider.optionsOf<CustomThemeOptions>(context).defaultIconColor,
                          ),
                        ),
                      ),
                    ):Container(),
                  ],
                ),
              ),
              Container(
                child: buildSuggestions(context),
              )
            ],
          ),
        ),
      )
    );
  }
}
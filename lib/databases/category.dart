class Category{
  final int id;
  final String name;
  final String date;

  Category({this.id, this.name, this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, date: $date}';
  }
}

  List<Category> toCategories(List<Map<String, dynamic>> maps){
      // Convert the List<Map<String, dynamic> into a List<Category>.
      return maps!=null?maps.length>0?List.generate(maps.length, (i) {
        return Category(
          id: maps[i]['id'],
          name: maps[i]['name'],
          date: maps[i]['date'],
        );
    }):List():List();
  }


  void printCategories(List<Category> bookmarks){
    for(Category c in bookmarks){
      print(c.toString());
    }
  }
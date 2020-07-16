class Bookmark {
  final int id;
  final int categoryId;
  final String name;
  final String url;
  final String date;

  Bookmark({this.id, this.categoryId, this.name, this.url, this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'url': url,
      'date': date,
    };
  }

  @override
  String toString() {
    return 'Bookmark{id: $id, categoryId: $categoryId, name: $name, url: $url, date: $date}';
  }
}

  List<Bookmark> toBookmarks(List<Map<String, dynamic>> maps){
      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return maps!=null?maps.length>0?List.generate(maps.length, (i) {
        return Bookmark(
          id: maps[i]['id'],
          categoryId: maps[i]['categoryId'],
          name: maps[i]['name'],
          url: maps[i]['url'],
          date: maps[i]['date'],
        );
    }):List():List();
  }


  void printBookmarks(List<Bookmark> bookmarks){
    for(Bookmark b in bookmarks){
      print(b.toString());
    }
  }
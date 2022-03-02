class Category {
  String catid;
  String imageUrl;
  String title;
  Category({this.catid, this.imageUrl, this.title});

  factory Category.fromJson(Map<String, dynamic> json) {
    return new Category(
      catid: json['catid'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

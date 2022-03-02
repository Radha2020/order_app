class MyBanner {
  String title;
  String imageUrl;
  String catid;
  MyBanner({this.imageUrl, this.title, this.catid});

  factory MyBanner.fromJson(Map<String, dynamic> json) {
    return new MyBanner(
        title: json['title'] as String,
        imageUrl: json['imageUrl'] as String,
        catid: json['catid'] as String);
  }
}

class ItemModel {
  String name;
  String url;
  String image;
  String? description;
  List<String>? screenshots;
  String? googlePlay;
  String? appleStore;
  String? huaweiStore;
  String? youtubeLink;
  String? courseLink;
  String? docsLink;
  List<String>? highlights;

  ItemModel({
    required this.name,
    required this.url,
    required this.image,
    this.description,
    this.screenshots,
    this.googlePlay,
    this.appleStore,
    this.huaweiStore,
    this.youtubeLink,
    this.courseLink,
    this.docsLink,
    this.highlights,
  });
}

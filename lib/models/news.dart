class News{
final String title;
final String description;
final String urlImg;
final String source;


News({
  required this.title,
  required this.description,
  required this.urlImg,
  required this.source,
});

factory News.fromJson(Map<String, dynamic> json){
  return News(
    title: json['title'] as String,
    description: json['description'] as String,
    urlImg: json['image'] as String,
    source: json['source']['name'] as String,
  );
}

}
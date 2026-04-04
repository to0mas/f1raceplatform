class News{
final String title;
final String description;
final String urlImg;


News({
  required this.title,
  required this.description,
  required this.urlImg,
});

factory News.fromJson(Map<String, dynamic> json){
  return News(
    title: json['title'] as String,
    description: json['description'] as String,
    urlImg: json['image'] as String,
  );
}

}
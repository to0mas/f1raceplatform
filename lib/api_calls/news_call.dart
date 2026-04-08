 import 'package:dio/dio.dart';
 import 'package:f1raceplatform/models/news.dart';
 
 
 class NewsCall {

Future<List<News>> getNews() async{

try{
final dio = Dio();
final String url = 'https://gnews.io/api/v4/search?q=F1 OR "Formula 1"&lang=en&max=10&sortby=publishedAt&token=e1efc1efc0951435e87b62eb7674192a';


final response = await dio.get(url);

final List data = response.data['articles'];
return data.map((newsJson) => News.fromJson(newsJson)).toList();
}
catch (e) {
   print('News error: $e');
  return [];
}

 }


 }
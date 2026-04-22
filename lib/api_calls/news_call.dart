import 'package:dio/dio.dart';
 import 'package:f1raceplatform/models/news.dart';
 
 
 class NewsCall {

Future<List<News>> getNews() async{

try{
final dio = Dio();
final String url = 'https://gnews.io/api/v4/search?q=("Formula%201"%20OR%20F1%20OR%20"Formula%20One")%20AND%20(motorsport%20OR%20race%20OR%20Grand%20Prix)&lang=en&country=us&max=10&sortby=publishedAt&apikey=67968d4726398a5b794270212d410ae8';


final response = await dio.get(url);

final List data = response.data['articles'];
return data.map((newsJson) => News.fromJson(newsJson)).toList();
}
catch (e) {

  return [];
}

 }


 }
import 'package:dio/dio.dart';
import 'package:f1raceplatform/models/races.dart';

class RacesCall {
  Future<List<Race>> getRace() async {
    try {
      final dio = Dio();
      final String url = 'https://f1api.dev/api/current/next';

      final response = await dio.get(url);

      final List data = response.data['race'] ?? [];
      
      return data.map((raceJson) => Race.fromJson(raceJson)).toList();
    } 
   
    catch (e) {
    
      return [];
    }
  }
}
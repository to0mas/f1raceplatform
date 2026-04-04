import 'package:dio/dio.dart';
import 'package:f1raceplatform/models/weather.dart';

class WeatherCall {

Future <List<Weather>> getWeather() async{

 try{
  final dio = Dio();
final String url = 'https://api.openf1.org/v1/weather?session_key=latest';

final response = await dio.get(url);

final List data = response.data['weather'];
return data.map((weatherJson) => Weather.fromJson(weatherJson)).toList();
    }
    catch (e) {
      return [];
    }

  }

}
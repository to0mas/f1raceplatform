import 'package:f1raceplatform/models/driver.dart';
import 'package:dio/dio.dart';


class DriverCall {

Future<List<Driver>> getDrivers() async{
try{
    final dio = Dio();
final String url = 'https://api.openf1.org/v1/drivers?session_key=latest';

final response = await dio.get(url);

final List data = response.data;
return data.map((driverJson) => Driver.fromJson(driverJson)).toList();
}
catch (e) {
    return [];
}





}

}
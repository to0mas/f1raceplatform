

import 'package:dio/dio.dart';
import 'package:f1raceplatform/models/driver_standing.dart';

class DriverStandingsCall {

  Future<List<DriverStanding>> getDriverStandings() async{

    try{
  final dio = Dio();
final String url = 'https://api.jolpi.ca/ergast/f1/2026/driverStandings.json';

final response = await dio.get(url);

final List data = response.data['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'];
return data.map((driverJson) => DriverStanding.fromJson(driverJson)).toList();
    }
    catch (e) {
      return [];
    }

  }
}
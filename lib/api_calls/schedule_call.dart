import 'package:dio/dio.dart';
import 'package:f1raceplatform/models/schedule.dart';

class ScheduleCall {
  Future<List<Schedule>> getSchedule() async {
    try {
      final dio = Dio();
      const String url = 'https://api.openf1.org/v1/meetings?year=2026';

      final response = await dio.get(url);

      final List data = response.data;

      return data.map((item) => Schedule.fromJson(item)).toList();
    } catch (e) {
     
      return [];
    }
  }
}
import 'package:dio/dio.dart';
import 'package:f1raceplatform/models/team_standing.dart';

class TeamStandingsCall {
  Future<List<TeamStanding>> getTeamStandings() async {
    try {
      final dio = Dio();

      final String url =
          'https://api.jolpi.ca/ergast/f1/2026/constructorStandings.json';

      final response = await dio.get(url);

      final List data =
          response.data['MRData']['StandingsTable']['StandingsLists'][0]
              ['ConstructorStandings'];

      return data
          .map((teamJson) => TeamStanding.fromJson(teamJson))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
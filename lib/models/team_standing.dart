class TeamStanding {
  final String teamName;
  final String teamCode;
  final int points;

  TeamStanding({
    required this.teamName,
    required this.teamCode,
    required this.points,
  });

  factory TeamStanding.fromJson(Map<String, dynamic> json) {
    return TeamStanding(
      teamName: json['Constructor']['name'],
      teamCode: json['Constructor']['constructorId'],
      points: int.parse(json['points'].toString()),
    );
  }
}
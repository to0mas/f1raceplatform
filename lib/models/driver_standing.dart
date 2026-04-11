class DriverStanding {
  final int position;
  final String driverCode;
  final int points;
  final int wins;
  final String givenName;
  final String familyName;

  DriverStanding({
    required this.position,
    required this.driverCode,
    required this.points,
    required this.wins,
    required this.givenName,
    required this.familyName,
  });

  factory DriverStanding.fromJson(Map<String, dynamic> json) {
    return DriverStanding(
      position: int.parse(json['position']),
      driverCode: json['Driver']['code'],
      points: int.parse(json['points']),
      wins: int.parse(json['wins']),
      givenName: json['Driver']['givenName'],
      familyName: json['Driver']['familyName'],
    );
  }
}
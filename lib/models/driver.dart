class Driver {
  final int driverNumber;
  final String firstName;
  final String lastName;
  final String nameAcronym;
  final String teamColour;
  final String teamName;
  final String? headshotUrl;

  // custom stats
  final int podiums;
  final int debut;
  final int wins;
  final int worldChampionship;

  Driver({
    required this.driverNumber,
    required this.firstName,
    required this.lastName,
    required this.nameAcronym,
    required this.teamColour,
    required this.teamName,
    this.headshotUrl,
    required this.podiums,
    required this.debut,
    required this.wins,
    required this.worldChampionship,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {

    const Map<String, Map<String, int>> driverStats = {
      "VER": {"podiums": 100, "debut": 2015, "wins": 60, "worldChampionship": 3},
      "HAM": {"podiums": 200, "debut": 2007, "wins": 105, "worldChampionship": 7},
      "LEC": {"podiums": 35, "debut": 2018, "wins": 8, "worldChampionship": 0},
      "NOR": {"podiums": 20, "debut": 2019, "wins": 3, "worldChampionship": 0},
      "SAI": {"podiums": 25, "debut": 2015, "wins": 4, "worldChampionship": 0},
      "RUS": {"podiums": 15, "debut": 2019, "wins": 2, "worldChampionship": 0},
      "ALO": {"podiums": 105, "debut": 2001, "wins": 32, "worldChampionship": 2},
      "PER": {"podiums": 35, "debut": 2011, "wins": 6, "worldChampionship": 0},
      "PIA": {"podiums": 10, "debut": 2023, "wins": 2, "worldChampionship": 0},
      "GAS": {"podiums": 5, "debut": 2017, "wins": 1, "worldChampionship": 0},
    };

    final stats = driverStats[json['name_acronym']] ?? {
      "podiums": 0,
      "debut": 0,
      "wins": 0,
      "worldChampionship": 0,
    };

    return Driver(
      driverNumber: json['driver_number'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      nameAcronym: json['name_acronym'] ?? '',
      teamColour: json['team_colour'] ?? '000000',
      teamName: json['team_name'] ?? '',
      headshotUrl: json['headshot_url'],

      podiums: stats['podiums']!,
      debut: stats['debut']!,
      wins: stats['wins']!,
      worldChampionship: stats['worldChampionship']!,
    );
  }

  
  String get fullName => "$firstName $lastName";
}
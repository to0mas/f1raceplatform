
class Driver {//class Driver

  final int driverNumber;
  final String firstName;
  final String lastName;
  final String nameAcronym;
  final String teamColour;
  final String teamName;
 final String? headshotUrl;


  Driver({//ctor pro třídu Driver
    required this.driverNumber,
    required this.firstName,
    required this.lastName,
    required this.nameAcronym,
    required this.teamColour,
    required this.teamName,
    required this.headshotUrl,
  });


  factory Driver.fromJson(Map<String, dynamic> json) {// factory constructor pro vytvoření instance Driver z JSON dat
    return Driver(
      driverNumber: json['driver_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      nameAcronym: json['name_acronym'],
      teamColour: json['team_colour'],
      teamName: json['team_name'],
     headshotUrl: json['headshot_url'] ?? '',
    );
  }

}
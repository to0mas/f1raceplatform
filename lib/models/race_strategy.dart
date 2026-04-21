class RaceStrategy {
  final Map<String, dynamic> gp;
  final Map<String, dynamic> driver;

  final int gpId;
  final int driverId;

  final String startTyre;
  final int pitStops;
  final List<int> pitLaps;
  final List<String> pitTyres;
  final List<Map<String, dynamic>> tires;

  RaceStrategy({
    required this.gp,
    required this.driver,
    required this.gpId,
    required this.driverId,
    required this.startTyre,
    required this.pitStops,
    required this.pitLaps,
    required this.pitTyres,
    required this.tires,
  });

  @override
  String toString() {
    return '''RaceStrategy(
      GP: ${gp['grandprix_name']},
      Driver: ${driver['driver_first_name']} ${driver['driver_last_name']},
      Start Tyre: $startTyre,
      Pit Stops: $pitStops,
      Pit Laps: $pitLaps,
      Pit Tyres: $pitTyres,
    )''';
  }
}
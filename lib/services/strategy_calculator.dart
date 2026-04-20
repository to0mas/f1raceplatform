class RaceDataPrep {
  // -------------------------
  // DATA PREPARATION
  // -------------------------

  static int getTotalLaps(Map<String, dynamic> gp) {
    return gp['laps'] as int;
  }

  static String getStartTyre(Map<String, dynamic> startTyre) {
    return startTyre['tire_compound'] as String;
  }

  static List<int> cleanPitLaps(List<int?> laps) {
    return laps.whereType<int>().toList()..sort();
  }

  static List<String> cleanPitTyres(List<String?> tyres) {
    return tyres.whereType<String>().toList();
  }

  static double getBaseLapTime(Map<String, dynamic> gp) {
    return (gp['base_lap_time'] ?? 82.08).toDouble();
  }

  static double getDegradation(
    List<Map<String, dynamic>> tires,
    String compound,
  ) {
    final tyre = tires.firstWhere(
      (t) => t['tire_compound'] == compound,
      orElse: () => {'degradation': 0},
    );

    return (tyre['degradation'] ?? 0).toDouble();
  }

  static double calculateStint({
    required double baseLapTime,
    required double degradation,
    required int laps,
  }) {
    double total = 0;

    for (int i = 1; i <= laps; i++) {
      total += baseLapTime + (i * degradation);
    }

    return total;
  }

  static const double avgPitLossTime = 22.0;

  static double calculateRaceTime({
    required Map<String, dynamic> gp, // bere data z db
    required List<Map<String, dynamic>> tires,
    required String startCompound,
    required List<String?> pitTyres,
    required List<int?> pitLaps,
  }) {
    final baseLapTime = getBaseLapTime(gp); // vezme základní čas kola GP
    final totalLaps = getTotalLaps(gp); // počet kol závodu

    double totalTime = 0; // tady se ukládá celkový čas

    String currentTyre = startCompound; // startovní guma
    int previousLap = 0; // odkud začíná stint

    final cleanLaps = cleanPitLaps(pitLaps);
    final cleanTyres = cleanPitTyres(pitTyres); // odstraní null hodnoty

    // projíždí celý závod + pitstopy
    for (int i = 0; i <= cleanLaps.length; i++) {
      final endLap =
          (i < cleanLaps.length) ? cleanLaps[i] : totalLaps;

      final stintLaps = endLap - previousLap;

      final degradation = getDegradation(tires, currentTyre); // finalní degradace

      totalTime += calculateStint(
        baseLapTime: baseLapTime, // první
        degradation: degradation, // druhé
        laps: stintLaps, // průměr
      );

      if (i < cleanLaps.length) {
        totalTime += avgPitLossTime;

        if (i < cleanTyres.length) {
          currentTyre = cleanTyres[i];
        }

        previousLap = endLap;
      }
    }

    return totalTime;
  }
}
class RaceDataPrep {
  static int getTotalLaps(Map<String, dynamic> gp) {
    return gp['laps'] as int;
  }

  static List<int> cleanPitLaps(List<int?> laps) {
    return laps.whereType<int>().toList();
  }

  static List<String> cleanPitTyres(List<String?> tyres) {
    return tyres.whereType<String>().toList();
  }

  static double getBaseLapTime(Map<String, dynamic> gp) {
    // ⚠️ pokud nemáš v DB base_lap_time, fallback je nutný
    return (gp['base_lap_time'] ?? 82.08).toDouble();
  }

  static double getDegradation(
    List<Map<String, dynamic>> tires,
    String compound,
  ) {
    final tyre = tires.firstWhere(
      (t) => t['tire_compound'] == compound,
      orElse: () => {'degradation': 0.15},
    );

    return (tyre['degradation'] ?? 0.15).toDouble();
  }

  static double calculateStint({
    required double baseLapTime,
    required double degradation,
    required int laps,
  }) {
    double total = 0;

    for (int i = 0; i < laps; i++) {
      total += baseLapTime + (i * degradation);
    }

    return total;
  }

  static const double avgPitLossTime = 22.0;

  static List<Map<String, dynamic>> calculateBreakdown({
    required Map<String, dynamic> gp,
    required List<Map<String, dynamic>> tires,
    required String startCompound,
    required List<String?> pitTyres,
    required List<int?> pitLaps,
  }) {
    final baseLapTime = getBaseLapTime(gp);
    final totalLaps = getTotalLaps(gp);

    final cleanLaps = cleanPitLaps(pitLaps);
    final cleanTyres = cleanPitTyres(pitTyres);

    final int stintCount =
        cleanLaps.length < cleanTyres.length
            ? cleanLaps.length
            : cleanTyres.length;

    List<Map<String, dynamic>> result = [];

    String currentTyre = startCompound;
    int previousLap = 0;

    for (int i = 0; i < stintCount + 1; i++) {
      final int endLap =
          (i < cleanLaps.length) ? cleanLaps[i] : totalLaps;

      final int stintLaps = endLap - previousLap;

      if (stintLaps <= 0) continue;

      final degradation = getDegradation(tires, currentTyre);

      final stintTime = calculateStint(
        baseLapTime: baseLapTime,
        degradation: degradation,
        laps: stintLaps,
      );

      result.add({
        'stint': i + 1,
        'tyre': currentTyre,
        'laps': stintLaps,
        'time': stintTime,
      });

      if (i < cleanTyres.length) {
        currentTyre = cleanTyres[i];
      }

      previousLap = endLap;
    }

    return result;
  }

  static double calculateRaceTime({
    required Map<String, dynamic> gp,
    required List<Map<String, dynamic>> tires,
    required String startCompound,
    required List<String?> pitTyres,
    required List<int?> pitLaps,
  }) {
    final breakdown = calculateBreakdown(
      gp: gp,
      tires: tires,
      startCompound: startCompound,
      pitTyres: pitTyres,
      pitLaps: pitLaps,
    );

    double total = 0;

    for (int i = 0; i < breakdown.length; i++) {
      total += (breakdown[i]['time'] as double);

      if (i != breakdown.length - 1) {
        total += avgPitLossTime;
      }
    }

    return total;
  }
}
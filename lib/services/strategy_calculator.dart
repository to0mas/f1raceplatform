class RaceDataPrep {
  static int getTotalLaps(Map<String, dynamic> gp) {
    final laps = gp['laps'] as int?;
    if (laps == null || laps < 10) {
      throw Exception('Invalid laps: $laps');
    }
    return laps;
  }

  static List<int> cleanPitLaps(List<int?> laps) {
    final cleaned = laps.whereType<int>().toList();
    cleaned.sort();
    return cleaned;
  }

  static List<String> cleanPitTyres(List<String?> tyres) {
    return tyres.whereType<String>().toList();
  }

  static double getBaseLapTime(Map<String, dynamic> gp) {
    return (gp['base_lap_time'] ?? 93.0).toDouble();
  }

  static double getDegradation(
    List<Map<String, dynamic>> tires,
    String compound,
  ) {
    final tyre = tires.firstWhere(
      (t) => t['tire_compound'] == compound,
      orElse: () => tires.first,
    );

    final base = (tyre['degradation'] ?? 0.03).toDouble();

    switch (compound) {
      case 'Soft':
        return base + 0.02;
      case 'Medium':
        return base + 0.01;
      case 'Hard':
        return base;
      default:
        return base;
    }
  }

  // Degradace resetuje na 0 na začátku každého stintu
  static double calculateStint({
    required double baseLapTime,
    required double baseDegradation,
    required int laps,
    required String compound,
  }) {
    double total = 0;
    for (int i = 0; i < laps; i++) {
      total += baseLapTime + (baseDegradation * i);
    }
    return total;
  }

  static double pitLossTime(String from, String to) {
    return 22.0;
  }

  static bool validatePitLaps(List<int> pitLaps, int totalLaps) {
    if (pitLaps.isEmpty) return true;
    if (pitLaps.first < 3) return false;
    if (pitLaps.last > totalLaps - 5) return false;
    for (int i = 0; i < pitLaps.length - 1; i++) {
      if (pitLaps[i] >= pitLaps[i + 1]) return false;
      if (pitLaps[i + 1] - pitLaps[i] < 5) return false;
    }
    return true;
  }

  static bool validatePitTyres(String startCompound, List<String> pitTyres) {
    if (pitTyres.isEmpty) return true;
    if (pitTyres.first == startCompound) return false;
    for (int i = 0; i < pitTyres.length - 1; i++) {
      if (pitTyres[i] == pitTyres[i + 1]) return false;
    }
    return true;
  }

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

    if (!validatePitLaps(cleanLaps, totalLaps)) {
      throw Exception('Invalid pit lap configuration');
    }
    if (!validatePitTyres(startCompound, cleanTyres)) {
      throw Exception('Invalid tire configuration');
    }

    String currentTyre = startCompound;
    int previousLap = 0;
    List<Map<String, dynamic>> result = [];

    if (cleanLaps.isEmpty) {
      final deg = getDegradation(tires, startCompound);
      final stintTime = calculateStint(
        baseLapTime: baseLapTime,
        baseDegradation: deg,
        laps: totalLaps,
        compound: startCompound,
      );
      return [
        {'stint': 1, 'tyre': startCompound, 'laps': totalLaps, 'time': stintTime}
      ];
    }

    for (int i = 0; i <= cleanLaps.length; i++) {
      final endLap = (i < cleanLaps.length) ? cleanLaps[i] : totalLaps;
      final stintLaps = endLap - previousLap;
      if (stintLaps <= 0) continue;

      final deg = getDegradation(tires, currentTyre);
      final stintTime = calculateStint(
        baseLapTime: baseLapTime,
        baseDegradation: deg,
        laps: stintLaps,
        compound: currentTyre,
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
    try {
      final breakdown = calculateBreakdown(
        gp: gp,
        tires: tires,
        startCompound: startCompound,
        pitTyres: pitTyres,
        pitLaps: pitLaps,
      );

      double total = 0;
      for (int i = 0; i < breakdown.length; i++) {
        total += breakdown[i]['time'] as double;
        if (i != breakdown.length - 1) {
          total += pitLossTime(
            breakdown[i]['tyre'] as String,
            breakdown[i + 1]['tyre'] as String,
          );
        }
      }
      return total;
    } catch (e) {
      final baseLapTime = getBaseLapTime(gp);
      final totalLaps = getTotalLaps(gp);
      return (totalLaps * baseLapTime) + 120;
    }
  }

  // AI simuluje klasickou 1-stop strategii: Medium → Hard
  static double calculateAiTime({
    required Map<String, dynamic> gp,
    required List<Map<String, dynamic>> tires,
  }) {
    final totalLaps = getTotalLaps(gp);
    final pitLap = (totalLaps * 0.5).round();

    return calculateRaceTime(
      gp: gp,
      tires: tires,
      startCompound: 'Medium',
      pitTyres: ['Hard'],
      pitLaps: [pitLap],
    );
  }
}
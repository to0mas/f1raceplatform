
class RaceStrategyCalculator {
  
  static double calculate({
    required int lapsTotal,
    required double baseLap,
    required double degradation,
    required String startTyre,
    required List<int> pitLaps,
    required List<String> pitTyres,
  }) {
    double time = 0;
    String tyre = startTyre;
    int lastLap = 0;

    // 🔥 FIXNUTO: Lineární degradace
    for (int i = 0; i <= pitLaps.length; i++) {
      int endLap = (i < pitLaps.length) ? pitLaps[i] : lapsTotal;
      int stint = endLap - lastLap;

      if (stint <= 0) continue;

      // Lineární degradace na stint
      for (int lap = 0; lap < stint; lap++) {
        time += baseLap + (degradation * lap);
      }

      // Pit loss mezi stinty
      if (i < pitTyres.length) {
        time += _pitLoss(tyre, pitTyres[i]);
        tyre = pitTyres[i];
      }

      lastLap = endLap;
    }

    return time;
  }

  /// 🔥 FIXNUTO: Realistický pit loss
  static double _pitLoss(String from, String to) {
    if (from == to) return 16.0;
    return 16.0;
  }

  /// Validace strategie
  static bool validateStrategy({
    required int lapsTotal,
    required List<int> pitLaps,
    required List<String> pitTyres,
    required String startTyre,
  }) {
    if (pitLaps.isEmpty && pitTyres.isEmpty) {
      return true; // 0 pit stopů je OK
    }

    if (pitLaps.length != pitTyres.length) {
      return false; // Počet pit stopů a tyrů se musí shodovat
    }

    // Pit lap validace
    if (pitLaps.first < 3 || pitLaps.last > lapsTotal - 5) {
      return false; // Pit stop mimo povolený rozsah
    }

    // Pit lap seřazení
    for (int i = 0; i < pitLaps.length - 1; i++) {
      if (pitLaps[i] >= pitLaps[i + 1]) {
        return false; // Nejsou seřazeny
      }
      if (pitLaps[i + 1] - pitLaps[i] < 5) {
        return false; // Příliš blízko
      }
    }

    // Pit tyre validace
    if (pitTyres.first == startTyre) {
      return false; // Nesmí být stejný jako start
    }

    for (int i = 0; i < pitTyres.length - 1; i++) {
      if (pitTyres[i] == pitTyres[i + 1]) {
        return false; // Nesmí se opakovat
      }
    }

    return true;
  }
}

import 'dart:math';

/// 🔥 FIXNUTO: RaceEngine s realističtějšími výpočty
class RaceEngine {
  static final Random _random = Random();

  /// Vypočítej čas jednoho kola s variací
  /// 
  /// Parametry:
  /// - base: base lap time (80s)
  /// - degradation: degradace gumy per lap (0.03-0.05)
  /// - lap: číslo kola (0-56)
  static double lapTime({
    required double base,
    required double degradation,
    required int lap,
  }) {
    // 🔥 FIXNUTO: Lineární wear
    double wear = degradation * lap;

    // 🔥 FIXNUTO: Malá variace (±1.5%)
    // Díky variacím si uživatel myslí, že je to realističtější
    double variance = 0.985 + _random.nextDouble() * 0.03; // 0.985 - 1.015

    // Výsledný čas = (base + wear) * variance
    return (base + wear) * variance;
  }

  /// Alternativní verze OHNE randomness (deterministické)
  static double lapTimeDeterministic({
    required double base,
    required double degradation,
    required int lap,
  }) {
    // Čistě lineární bez variace
    return base + (degradation * lap);
  }

  /// Pit loss čas (stinký do pit lane + pit stop + výjezd)
  static double pitStopTime({
    required String fromTyre,
    required String toTyre,
  }) {
    // 🔥 FIXNUTO: Realistický pit loss
    if (fromTyre == toTyre) {
      return 16.0; // Bez výměny gum - jen servis
    }
    return 16.0; // S výměnou gum (stejný čas v tétosimulaci)
  }

  /// Variabilita kvůli počasí/podmínkám (optional)
  static double weatherVariation() {
    // Random weather effect: ±2%
    return 0.98 + _random.nextDouble() * 0.04;
  }
}

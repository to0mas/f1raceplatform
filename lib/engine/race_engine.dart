import 'dart:math';


class RaceEngine {
  static final Random _random = Random();

 
  /// Parametry:
  /// - base: base lap time (80s)
  /// - degradation: degradace gumy per lap (0.03-0.05)
  /// - lap: číslo kola (0-56)
  static double lapTime({
    required double base,
    required double degradation,
    required int lap,
  }) {
   
    double wear = degradation * lap;

    double variance = 0.985 + _random.nextDouble() * 0.03; // 0.985 - 1.015

    return (base + wear) * variance;
  }


  static double lapTimeDeterministic({
    required double base,
    required double degradation,
    required int lap,
  }) {
   
    return base + (degradation * lap);
  }

  static double pitStopTime({
    required String fromTyre,
    required String toTyre,
  }) {
  
    if (fromTyre == toTyre) {
      return 16.0; 
    }
    return 16.0; 
  }

  //
  static double weatherVariation() {
   
    return 0.98 + _random.nextDouble() * 0.04;
  }
}
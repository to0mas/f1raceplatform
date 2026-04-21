/// 🔥 FIXNUTO: RaceComparison s lepšímanalýzu výsledků
class RaceComparison {
  /// Srovnání simulovaného a expected času
  static Map<String, dynamic> compare({
    required double sim,
    required double expected,
  }) {
    if (expected <= 0) {
      return {
        "sim": sim,
        "expected": expected,
        "diff": 0,
        "diff_percent": 0,
        "result": "NO_EXPECTED_DATA",
        "verdict": "Data not found",
      };
    }

    final double diff = sim - expected;
    final double diffPercent = (diff / expected) * 100;

    // 🔥 FIXNUTO: Lepší analýza výsledku
    String verdict;
    if (diff < -5) {
      verdict = "EXCELLENT! Much faster than AI! 🚀🚀";
    } else if (diff < 0) {
      verdict = "YOU WIN! Faster than AI! 🚀";
    } else if (diff < 5) {
      verdict = "CLOSE! Nearly same speed";
    } else if (diff < 15) {
      verdict = "YOU LOSE! But close enough";
    } else if (diff < 30) {
      verdict = "SLOWER! Need better strategy";
    } else {
      verdict = "FAR BEHIND! Major strategy error";
    }

    return {
      "sim": sim,
      "expected": expected,
      "diff": diff,
      "diff_percent": diffPercent,
      "result": diff < 0 ? "WIN" : "LOSE",
      "verdict": verdict,
      "quality": _getQualityRating(diffPercent),
    };
  }

  /// Kvalita strategie na základě rozdílu
  static String _getQualityRating(double diffPercent) {
    if (diffPercent < -3) return "⭐⭐⭐⭐⭐ Excellent";
    if (diffPercent < 0) return "⭐⭐⭐⭐ Very Good";
    if (diffPercent < 1) return "⭐⭐⭐⭐ Good";
    if (diffPercent < 3) return "⭐⭐⭐ Average";
    if (diffPercent < 5) return "⭐⭐ Below Average";
    return "⭐ Poor";
  }

  /// Doporučení na zlepšení
  static String getRecommendation(double diff, int pitStops) {
    if (diff < 0) {
      return "Great strategy! Keep it up!";
    }

    if (diff > 30) {
      return "Consider using a pit stop strategy";
    }

    if (diff > 15) {
      return "Try different tire compound for pit stops";
    }

    return "Small adjustments needed to beat the AI";
  }

  /// Detailní analýza
  static Map<String, dynamic> getDetailedAnalysis({
    required double sim,
    required double expected,
    required int pitStops,
    required String startTyre,
    required List<String> pitTyres,
  }) {
    final comparison = compare(sim: sim, expected: expected);

    return {
      ...comparison,
      "strategy": {
        "pit_stops": pitStops,
        "start_tyre": startTyre,
        "pit_tyres": pitTyres,
      },
      "recommendation": getRecommendation(
        comparison["diff"] as double,
        pitStops,
      ),
      "efficiency": ((expected / sim) * 100).toStringAsFixed(2) + "%",
    };
  }
}

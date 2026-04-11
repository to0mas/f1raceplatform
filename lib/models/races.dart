class Race {
  final String raceName;
  final DateTime? date;
  final DateTime? time;
  final int round;
  final int laps;
  final String circuitLength;
  final int corners;

  Race({
    required this.raceName,
    required this.date,
    required this.time,
    required this.round,
    required this.laps,
    required this.circuitLength,
    required this.corners,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      raceName: json['raceName'] as String,
      date: json['schedule']?['race']?['date'] != null 
          ? DateTime.tryParse(json['schedule']['race']['date']) 
          : null,
      time: json['schedule']?['race']?['time'] != null 
          ? DateTime.tryParse(json['schedule']['race']['time']) 
          : null,
      round: json['round'] as int,
      laps: json['laps'] as int,
      circuitLength: json['circuit']?['circuitLength'] as String? ?? '0km',
      corners: json['circuit']?['corners'] as int? ?? 0,
    );
  }
}
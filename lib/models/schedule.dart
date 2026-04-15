class Schedule {
  final String meetingOfficialName;
  final String circuitShortName;
  final DateTime dateStart;
  final String countryFlag;
  final String circuitImage;

  Schedule({
    required this.meetingOfficialName,
    required this.circuitShortName,
    required this.dateStart,
    required this.countryFlag,
    required this.circuitImage,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      meetingOfficialName:
          json['meeting_official_name'] ?? 'Unknown',

      circuitShortName:
          json['circuit_short_name'] ?? 'Unknown',

      dateStart: DateTime.tryParse(json['date_start'] ?? '') ??
          DateTime(1970, 1, 1),

      countryFlag:
          json['country_flag'] ?? '',

      circuitImage: (json['circuit_image'] is Map)
          ? json['circuit_image']['name'] ?? ''
          : '',
    );
  }
}
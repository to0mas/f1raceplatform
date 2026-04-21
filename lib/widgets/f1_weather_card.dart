import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const List<Map<String, dynamic>> kF1Calendar2026 = [
  {
    'name': 'FORMULA 1 CRYPTO.COM MIAMI GRAND PRIX 2026',
    'lat': 25.9581,
    'lon': -80.2389,
    'raceDate': '2026-05-03',
  },
  {
    'name': 'FORMULA 1 MONACO GRAND PRIX 2026',
    'lat': 43.7347,
    'lon': 7.4205,
    'raceDate': '2026-05-24',
  },
  {
    'name': 'FORMULA 1 CANADIAN GRAND PRIX 2026',
    'lat': 45.5017,
    'lon': -73.5673,
    'raceDate': '2026-06-14',
  },
  {
    'name': 'FORMULA 1 BRITISH GRAND PRIX 2026',
    'lat': 52.0786,
    'lon': -1.0169,
    'raceDate': '2026-07-05',
  },
];

class _DayForecast {
  final String label;
  final double tempMax;
  final double tempMin;
  final String iconCode;
  final int rainChance;

  const _DayForecast({
    required this.label,
    required this.tempMax,
    required this.tempMin,
    required this.iconCode,
    required this.rainChance,
  });
}

class F1WeatherCard extends StatefulWidget {
  final String apiKey;
  final String backgroundImage;

  const F1WeatherCard({
    super.key,
    required this.apiKey,
    this.backgroundImage = 'assets/images/miami.png',
  });

  @override
  State<F1WeatherCard> createState() => _F1WeatherCardState();
}

class _F1WeatherCardState extends State<F1WeatherCard> {
  late final Map<String, dynamic> _race;

  bool _loading = true;
  String? _error;
  double? _currentTemp;
  List<_DayForecast> _days = [];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _race = kF1Calendar2026.firstWhere(
      (r) => DateTime.parse(r['raceDate']).isAfter(now),
      orElse: () => kF1Calendar2026.last,
    );

    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final lat = _race['lat'];
      final lon = _race['lon'];

      final currentRes = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=${widget.apiKey}&units=metric',
      ));

      final forecastRes = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=${widget.apiKey}&units=metric',
      ));

      final currentJson = jsonDecode(currentRes.body);
      final forecastJson = jsonDecode(forecastRes.body);

      final list = (forecastJson['list'] as List);

      final Map<String, List<Map<String, dynamic>>> grouped = {};

      for (final e in list) {
        final dt = DateTime.fromMillisecondsSinceEpoch(
          e['dt'] * 1000,
          isUtc: true,
        ).toLocal();

        final key = '${dt.year}-${dt.month}-${dt.day}';
        grouped.putIfAbsent(key, () => []).add(e);
      }

      final firstThreeDays = grouped.values.take(3).toList();
      final labels = ['FRIDAY', 'SATURDAY', 'SUNDAY'];

      final days = List.generate(firstThreeDays.length, (i) {
        final entries = firstThreeDays[i];

        final tempsMax = entries
            .map((e) => (e['main']['temp_max'] as num).toDouble())
            .toList();

        final tempsMin = entries
            .map((e) => (e['main']['temp_min'] as num).toDouble())
            .toList();

        final rainChance = entries
            .map((e) => ((e['pop'] ?? 0) * 100).toDouble())
            .reduce((a, b) => a > b ? a : b)
            .round();

        final midday = entries.first;

        return _DayForecast(
          label: labels[i],
          tempMax: tempsMax.reduce((a, b) => a > b ? a : b),
          tempMin: tempsMin.reduce((a, b) => a < b ? a : b),
          iconCode: midday['weather'][0]['icon'],
          rainChance: rainChance,
        );
      });

      if (!mounted) return;

      setState(() {
        _currentTemp = (currentJson['main']['temp'] as num).toDouble();
        _days = days;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'error';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Container(
        height: 260,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE10600).withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  widget.backgroundImage,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFE10600).withOpacity(0.25),
                          const Color(0xFF8B0000).withOpacity(0.15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE10600),
                        ),
                      )
                    : _error != null
                        ? const Center(
                            child: Text(
                              'WEATHER ERROR',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_currentTemp!.round()}°C',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _race['name'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 14),

                              Expanded(
                                child: Row(
                                  children: _days.map((d) {
                                    return Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.55),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.12),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              d.label,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w800,
                                                fontSize: 12,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Icon(
                                              _icon(d.iconCode),
                                              color: const Color(0xFFFFD700),
                                              size: 22,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              '${d.tempMax.round()}°/${d.tempMin.round()}°',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              '${d.rainChance}%',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _icon(String code) {
    switch (code.replaceAll('d', '').replaceAll('n', '')) {
      case '01':
        return Icons.wb_sunny_rounded;
      case '03':
      case '04':
        return Icons.cloud_rounded;
      case '09':
      case '10':
        return Icons.umbrella_rounded;
      case '11':
        return Icons.thunderstorm_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}
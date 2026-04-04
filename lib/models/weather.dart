class Weather{
  final double airTemperature;
  final int humidity;
  final double rainfall;
  final double trackTemperature;
  final double windSpeed;


  Weather({

    required this.airTemperature,
    required this.humidity,
    required this.rainfall,
    required this.trackTemperature,
    required this.windSpeed,
  });


  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(

      airTemperature: json['air_temperature'],
      humidity: json['humidity'],
      rainfall: json['rainfall'],
      trackTemperature: json['track_temperature'],
      windSpeed: json['wind_speed'],

    );
  }
}
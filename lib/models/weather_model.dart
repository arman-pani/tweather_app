import 'dart:convert';

class WeatherModel {
  final double currentTemp;
  final String currentSky;
  final double currentHumidity;
  final double currentWindSpeed;
  final double currentPressure;

  WeatherModel({
    required this.currentTemp,
    required this.currentSky,
    required this.currentHumidity,
    required this.currentWindSpeed,
    required this.currentPressure,
  });

  WeatherModel copyWith({
    double? currentTemp,
    String? currentSky,
    double? currentHumidity,
    double? currentWindSpeed,
    double? currentPressure,
  }) {
    return WeatherModel(
      currentTemp: currentTemp ?? this.currentTemp,
      currentSky: currentSky ?? this.currentSky,
      currentHumidity: currentHumidity ?? this.currentHumidity,
      currentWindSpeed: currentWindSpeed ?? this.currentWindSpeed,
      currentPressure: currentPressure ?? this.currentPressure,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currentTemp': currentTemp,
      'currentSky': currentSky,
      'currentHumidity': currentHumidity,
      'currentWindSpeed': currentWindSpeed,
      'currentPressure': currentPressure,
    };
  }

  // converts the map from the API call into WeatherModel format
  factory WeatherModel.fromMap(Map<String, dynamic> map) {
    final currentWeatherData = map['list'][0];

    return WeatherModel(
      currentTemp: (currentWeatherData['main']['temp'] - 273.15).round(),
      currentSky: currentWeatherData['weather'][0]['main'],
      currentHumidity: currentWeatherData['main']['humidity'],
      currentWindSpeed: currentWeatherData['wind']['speed'],
      currentPressure: currentWeatherData['main']['pressure'],
    );
  }

  String toJson() => json.encode(toMap());

  factory WeatherModel.fromJson(String source) =>
      WeatherModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'WeatherModel(currentTemp: $currentTemp, currentSky: $currentSky, currentHumidity: $currentHumidity, currentWindSpeed: $currentWindSpeed, currentPressure: $currentPressure)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeatherModel &&
        other.currentTemp == currentTemp &&
        other.currentSky == currentSky &&
        other.currentHumidity == currentHumidity &&
        other.currentWindSpeed == currentWindSpeed &&
        other.currentPressure == currentPressure;
  }

  @override
  int get hashCode {
    return currentTemp.hashCode ^
        currentSky.hashCode ^
        currentHumidity.hashCode ^
        currentWindSpeed.hashCode ^
        currentPressure.hashCode;
  }
}

import 'dart:convert';

import 'package:weather_app/data/data_provider/weather_data_provider.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;

  WeatherRepository(this.weatherDataProvider);

  Future<WeatherModel> getCurrentWeather() async {
    try {
      String cityName = 'Bhubaneswar';

      // we fetch raw weather data from WeatherDataProvider
      final weatherData = await weatherDataProvider.getCurrentWeather(cityName);

      // then decode the response json and model it
      final data = jsonDecode(weatherData);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }

      // converts raw data 
      return WeatherModel.fromMap(data);
    } catch (e) {
      throw e.toString();
    }
  }
}

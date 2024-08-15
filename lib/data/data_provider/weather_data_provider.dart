import 'package:http/http.dart' as http;
import 'package:weather_app/confidential_keys.dart';

// in data_provider, we are only fetching raw data from the API and
// giving it to repository to model it for the developer
class WeatherDataProvider {
  Future<String> getCurrentWeather(String cityName) async {
    try {
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey'));

      return res.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

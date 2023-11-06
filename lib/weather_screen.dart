import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/hourly_weather_forecast_item.dart';

import 'additional_info_item.dart';
import 'confidential_keys.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Bhubaneswar';
      final res = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey'));

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemp =
              (currentWeatherData['main']['temp'] - 273.15).round();

          final currentSky = currentWeatherData['weather'][0]['main'];

          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentPressure = currentWeatherData['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // main card
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp °C',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              currentSky,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //weather forecast
              Text(
                'Hourly Forecast',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6,
              ),

              SizedBox(
                height: 140,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final hourlyWeatherData = data['list'][index + 1];
                    final hourlyTime =
                        DateTime.parse(hourlyWeatherData['dt_txt']);
                    final hourlyTemp =
                        (hourlyWeatherData['main']['temp'] - 273.15).round();
                    final hourlySky = hourlyWeatherData['weather'][0]['main'];

                    return HourlyWeatherForecastItem(
                      time: DateFormat.j().format(hourlyTime),
                      temp: hourlyTemp.toString(),
                      icon: hourlySky == "Clouds" || hourlySky == "Rain"
                          ? Icons.cloud
                          : Icons.sunny,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //additional info
              Text(
                'Additional Infomation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    info: 'Humidity',
                    infodata: '$currentHumidity',
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    info: 'Wind Speed',
                    infodata: '$currentWindSpeed',
                  ),
                  AdditionalInfoItem(
                    icon: Icons.beach_access,
                    info: 'Pressure',
                    infodata: "$currentPressure",
                  ),
                ],
              )
            ]),
          );
        },
      ),
    );
  }
}

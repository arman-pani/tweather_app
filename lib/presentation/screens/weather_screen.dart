import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';

import '../widgets/additional_info_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    // adding WeatherFetched event to WeatherBloc
    context.read<WeatherBloc>().add(WeatherFetched());
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
                context.read<WeatherBloc>().add(WeatherFetched());
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //   return const Center(child: CircularProgressIndicator.adaptive());
          // }

          // if (snapshot.hasError) {
          //   return Center(child: Text(snapshot.error.toString()));
          // }

          if (state is WeatherFailure) {
            return Center(child: Text(state.error));
          }

          if (state is! WeatherSuccess) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final data = state.weather;

          final currentTemp = data.currentTemp;

          final currentSky = data.currentSky;

          final currentHumidity = data.currentHumidity;
          final currentWindSpeed = data.currentWindSpeed;
          final currentPressure = data.currentPressure;

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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp °C',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              currentSky,
                              style: const TextStyle(
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
              const SizedBox(
                height: 20,
              ),
              //weather forecast
              const Text(
                'Hourly Forecast',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),

              // SizedBox(
              //   height: 140,
              //   child: ListView.builder(
              //     itemCount: 5,
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       final hourlyWeatherData = data['list'][index + 1];
              //       final hourlyTime =
              //           DateTime.parse(hourlyWeatherData['dt_txt']);
              //       final hourlyTemp =
              //           (hourlyWeatherData['main']['temp'] - 273.15).round();
              //       final hourlySky = hourlyWeatherData['weather'][0]['main'];

              //       return HourlyWeatherForecastItem(
              //         time: DateFormat.j().format(hourlyTime),
              //         temp: hourlyTemp.toString(),
              //         icon: hourlySky == "Clouds" || hourlySky == "Rain"
              //             ? Icons.cloud
              //             : Icons.sunny,
              //       );
              //     },
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              //additional info
              const Text(
                'Additional Infomation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
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

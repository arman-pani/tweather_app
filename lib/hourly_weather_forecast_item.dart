import "package:flutter/material.dart";

class HourlyWeatherForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyWeatherForecastItem({
    super.key,
    required this.time,
    required this.icon,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 10,
          ),
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '$temp °C',
            style: const TextStyle(fontSize: 16),
          ),
        ]),
      ),
    );
  }
}

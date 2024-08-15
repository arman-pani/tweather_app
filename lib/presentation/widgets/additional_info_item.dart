import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String info;
  final String infodata;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.info,
    required this.infodata,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(
        icon,
        size: 30,
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        info,
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        infodata,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    ]);
  }
}

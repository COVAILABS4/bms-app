import 'package:flutter/material.dart';

class TemperatureComponent extends StatelessWidget {
  final List<dynamic> temperatureData;

  const TemperatureComponent({Key? key, required this.temperatureData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      color: Colors.white, // Background color similar to the image
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTemperatureColumn(temperatureData[0], "°C"),
          const SizedBox(width: 16),
          Image.asset(
            'assets/images/temp.jpg', // Ensure this image is added to your assets
            height: 70,
            width: 70,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          _buildTemperatureColumn(temperatureData[1], "°F"),
        ],
      ),
    );
  }

  Widget _buildTemperatureColumn(dynamic data, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTemperatureRow("MOS", data["mos"]!.toStringAsFixed(1), unit,
            isBold: true),
        _buildTemperatureRow("1", data["1"]!.toStringAsFixed(1), unit),
        _buildTemperatureRow("2", data["2"]!.toStringAsFixed(1), unit),
      ],
    );
  }

  Widget _buildTemperatureRow(String label, String value, String unit,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$value$unit",
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Color(0xFF00BFFF), // Styled as in your image
            ),
          ),
        ],
      ),
    );
  }
}

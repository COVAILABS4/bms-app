import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final int index;
  final String name;
  final double value;

  Cell({required this.index, required this.name, required this.value});

  Color _getCellColor(double value) {
    if (value < 4.0) {
      return Colors.grey.shade300; // Light Grey
    } else if (value >= 4.0 && value < 4.8) {
      return const Color.fromARGB(255, 29, 240, 237); // Light Blue
    } else {
      return const Color.fromARGB(255, 96, 240, 48); // Light Green
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Name of the Cell
        Text(
          name,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Index in Rounded Black Border
            Container(
              width: 20,
              height: 20,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: TextStyle(fontSize: 10),
              ),
            ),
            SizedBox(width: 5), // Spacing between index and battery
            // Battery Container
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Battery Shape
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _getCellColor(value),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Battery Cap
                    Container(
                      width: 5,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
                // Voltage Value
                Positioned(
                  child: Text(
                    value.toStringAsFixed(3),
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

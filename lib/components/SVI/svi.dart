import 'package:flutter/material.dart';
import 'cell.dart';

class SVI extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  SVI({required this.data});

  @override
  Widget build(BuildContext context) {
    // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Define the desired width of each cell
    double cellWidth = 150; // Adjust this value based on your design
    int crossAxisCount = (screenWidth / cellWidth + 0.8).floor() -
        1; // Calculate number of columns

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            const Text(
              "Single Voltage Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Dynamic Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Cell(
                    index: index,
                    name: data[index]['name'],
                    value: data[index]['value'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

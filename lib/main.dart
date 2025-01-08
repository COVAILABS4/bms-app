import 'package:flutter/material.dart';

class DataDisplayGrid extends StatelessWidget {
  final Map<String, dynamic> values = {
    "total_volt": 52.52,
    "current": 0.00,
    "power": 0.00,
    "vol_high": 4.087,
    "vol_low": 3.75,
    "vol_diff": 0.337,
    "ave_vol": 4.04,
    "cycle_index": 78,
  };

  final Map<String, String> icons = {
    "total_volt": "assets/images/total_volt_icon.png",
    "current": "assets/images/current_icon.png",
    "power": "assets/images/power_icon.png",
    "vol_high": "assets/images/vol_high_icon.png",
    "vol_low": "assets/images/vol_low_icon.png",
    "vol_diff": "assets/images/vol_diff_icon.png",
    "ave_vol": "assets/images/ave_vol_icon.png",
    "cycle_index": "assets/images/cycle_index_icon.png",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Data Grid Display')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.3, // Adjusted for better alignment
          ),
          itemCount: values.length,
          itemBuilder: (context, index) {
            String key = values.keys.elementAt(index);
            dynamic value = values[key];
            String imageUrl = icons[key] ?? "";

            return Row(
              children: [
                // Left: Image/Icon
                Image.asset(
                  imageUrl,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.image_not_supported, size: 40),
                ),
                SizedBox(width: 8), // Space between image and text
                // Right: Column with Value and Key
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value.toString(),
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      key.replaceAll('_', ' ').toUpperCase(),
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: DataDisplayGrid()));
}

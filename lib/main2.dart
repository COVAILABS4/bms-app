import 'package:flutter/material.dart';
import 'components/SVI/svi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<dynamic> sviData = [
    {"name": "Cell 1", "value": 4.067},
    {"name": "Cell 2", "value": 4.067},
    {"name": "Cell 3", "value": 4.08},
    {"name": "Cell 4", "value": 4.06},
    {"name": "Cell 5", "value": 4.067},
    {"name": "Cell 6", "value": 4.067},
    {"name": "Cell 7", "value": 3.749},
    {"name": "Cell 8", "value": 4.067},
    {"name": "Cell 9", "value": 4.067},
    {"name": "Cell 10", "value": 4.067},
    {"name": "Cell 11", "value": 4.8},
    {"name": "Cell 12", "value": 4.9},
    {"name": "Cell 13", "value": 4.067},
    {"name": "Cell 14", "value": 3.067},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SVI(data: sviData),
    );
  }
}

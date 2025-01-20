import 'package:bms/components/Dashboards/dash.dart';
import 'package:bms/components/Dashboards/dashboard_handler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<dynamic> mockData = [
    {
      "name": "MEGATECH BMS 1",
      "mac_address": "A4:C1:37:30:87:B9",
      "soc": "90",
      "states": {
        "charging": true,
        "balance": false,
        "dis_mos": true,
        "protection": false,
      },
      "svi": [
        {"name": "Cell 1", "value": 4.067},
        {"name": "Cell 2", "value": 4.067},
        {"name": "Cell 3", "value": 4.08},
      ]
    },
    {
      "name": "MEGATECH BMS 2",
      "mac_address": "B4:C1:38:30:88:C0",
      "soc": "1",
      "states": {
        "charging": false,
        "balance": true,
        "dis_mos": true,
        "protection": true,
      },
      "svi": [
        {"name": "Cell 1", "value": 4.01},
        {"name": "Cell 2", "value": 4.02},
        {"name": "Cell 3", "value": 4.03},
        {"name": "Cell 4", "value": 4.04},
      ]
    },
    {
      "name": "MEGATECH BMS 3",
      "mac_address": "C5:D2:39:40:89:D1",
      "soc": "70",
      "states": {
        "charging": true,
        "balance": false,
        "dis_mos": true,
        "protection": false,
      },
      "svi": [
        {"name": "Cell 1", "value": 3.9},
        {"name": "Cell 2", "value": 4.9},
        {"name": "Cell 3", "value": 4.1},
        {"name": "Cell 4", "value": 4.2},
        {"name": "Cell 5", "value": 4.3},
      ]
    },
    {
      "name": "MEGATECH BMS 4",
      "mac_address": "D6:E3:40:50:90:E2",
      "soc": "60",
      "states": {
        "charging": false,
        "balance": true,
        "dis_mos": false,
        "protection": true,
      },
      "svi": [
        {"name": "Cell 1", "value": 4.01},
        {"name": "Cell 2", "value": 4.02},
        {"name": "Cell 3", "value": 4.03},
        {"name": "Cell 4", "value": 4.04},
        {"name": "Cell 5", "value": 4.05},
        {"name": "Cell 6", "value": 4.06},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardHandler(
        data: mockData,
      ),
    );
  }
}

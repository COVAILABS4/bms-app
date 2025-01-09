import 'package:bms/components/Dashboards/dash.dart';
import 'package:bms/components/Dashboards/dashboard_handler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Map<String, dynamic>> mockData = [
    {
      "name": "MEGATECH BMS 1",
      "mac_address": "A4:C1:37:30:87:B9",
      "soc": 90,
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
      ],
      "temperature": [
        {"mos": 24.6, "1": 24.6, "2": 24.9},
        {"mos": 76.10, "1": 76.10, "2": 76.82},
      ],
      "values": {
        "total_volt": 52.52,
        "current": 0.00,
        "power": 0.00,
        "vol_high": 4.087,
        "vol_low": 3.75,
        "vol_diff": 0.337,
        "ave_vol": 4.04,
        "cycle_index": 78,
      },
    },
    {
      "name": "MEGATECH BMS 2",
      "mac_address": "B4:C1:38:30:88:C0",
      "soc": 1,
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
      ],
      "temperature": [
        {"mos": 24.6, "1": 24.6, "2": 24.9},
        {"mos": 76.10, "1": 76.10, "2": 76.82},
      ],
      "values": {
        "total_volt": 52.52,
        "current": 0.00,
        "power": 0.00,
        "vol_high": 4.087,
        "vol_low": 3.75,
        "vol_diff": 0.337,
        "ave_vol": 4.04,
        "cycle_index": 78,
      },
    },
    {
      "name": "MEGATECH BMS 3",
      "mac_address": "C5:D2:39:40:89:D1",
      "soc": 70,
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
      ],
      "temperature": [
        {"mos": 24.6, "1": 24.6, "2": 24.9},
        {"mos": 76.10, "1": 76.10, "2": 76.82},
      ],
      "values": {
        "total_volt": 52.52,
        "current": 0.00,
        "power": 0.00,
        "vol_high": 4.087,
        "vol_low": 3.75,
        "vol_diff": 0.337,
        "ave_vol": 4.04,
        "cycle_index": 78,
      },
    },
    {
      "name": "MEGATECH BMS 4",
      "mac_address": "D6:E3:40:50:90:E2",
      "soc": 60,
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
      ],
      "temperature": [
        {"mos": 24.6, "1": 24.6, "2": 24.9},
        {"mos": 76.10, "1": 76.10, "2": 76.82},
      ],
      "values": {
        "total_volt": 52.52,
        "current": 0.00,
        "power": 0.00,
        "vol_high": 4.087,
        "vol_low": 3.75,
        "vol_diff": 0.337,
        "ave_vol": 4.04,
        "cycle_index": 78,
      },
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

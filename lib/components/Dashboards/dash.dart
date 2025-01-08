import 'package:bms/components/top/gauge.dart';
import 'package:bms/components/info/info.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Dashboard extends StatelessWidget {
  late Map<String, dynamic> data;

  Dashboard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00BFFF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Header(
              name: data['name'],
              macAddress: data['mac_address'],
            ),
            const SizedBox(height: 20),
            SOCGauge(soc: int.parse(data['soc'])),
            const SizedBox(height: 20),
            InfoContainer(
              data: data,
            ),
          ],
        ),
      ),
    );
  }
}

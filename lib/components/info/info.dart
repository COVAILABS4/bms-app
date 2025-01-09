import 'package:bms/components/SVI/svi.dart';
import 'package:bms/components/info/section1.dart';
import 'package:bms/components/info/section2.dart';
import 'package:bms/components/info/section3.dart';
import 'package:flutter/material.dart';

class InfoContainer extends StatelessWidget {
  final Map<dynamic, dynamic> data;

  InfoContainer({required this.data});

  @override
  Widget build(BuildContext context) {
    Widget greyLine() {
      return Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            const Divider(color: Colors.grey),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          section1(data['states']),
          greyLine(),
          section2(data['values'], context),
          greyLine(),
          TemperatureComponent(temperatureData: data['temperature']),
          greyLine(),
          SVI(data: data['svi']),
          greyLine(),
        ],
      ),
    );
  }
}

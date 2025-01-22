import 'package:flutter/material.dart';

import 'components/Dashboards/dashboard_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key _dashboardKey = UniqueKey(); // Unique key for refreshing the widget

  void _restartDashboard() {
    setState(() {
      _dashboardKey =
          UniqueKey(); // Generate a new key to rebuild DashboardHandler
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DashboardHandler(key: _dashboardKey),
        floatingActionButton: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25), // Adjust horizontal position
            child: FloatingActionButton(
              onPressed: _restartDashboard,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.refresh, color: Colors.white),
              tooltip: "Restart Dashboard",
            ),
          ),
        ),
      ),
    );
  }
}

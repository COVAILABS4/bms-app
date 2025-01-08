import 'package:bms/components/Dashboards/dash.dart';
import 'package:flutter/material.dart';

class DashboardHandler extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  DashboardHandler({required this.data});

  @override
  _DashboardHandlerState createState() => _DashboardHandlerState();
}

class _DashboardHandlerState extends State<DashboardHandler> {
  late List<Map<String, dynamic>> data; // Declare data variable here
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    data = widget.data; // Initialize the local data with widget.data
  }

  void nextData() {
    setState(() {
      currentIndex = (currentIndex + 1) % data.length;
    });
  }

  void previousData() {
    setState(() {
      currentIndex = (currentIndex - 1 + data.length) % data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00BFFF),
        title: Text("MEGATECH BMS"),
        actions: [
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Button Pressed"),
                      );
                    });
              },
              child: Text("C"))
        ],
      ),
      body: Stack(
        children: [
          Dashboard(
            data: data[currentIndex],
          ),
          _getButton(
            left: 10,
            top: 50,
            onPressed: previousData,
            icon: Icons.arrow_back,
          ),
          _getButton(
            right: 10,
            top: 50,
            onPressed: nextData,
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  /// Reusable function for FloatingActionButton
  Widget _getButton({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: FloatingActionButton(
        onPressed: onPressed,
        mini: true,
        backgroundColor: Colors.blue,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

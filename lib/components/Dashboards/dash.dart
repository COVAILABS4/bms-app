import 'package:bms/components/top/gauge.dart';
import 'package:bms/components/info/info.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  final Map<dynamic, dynamic> data;

  Dashboard({required this.data});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;

  @override
  void initState() {
    super.initState();

    // Add a listener to the scroll controller to determine when to show the button
    _scrollController.addListener(() {
      if (_scrollController.offset > 50) {
        setState(() {
          _showScrollToTopButton = true;
        });
      } else {
        setState(() {
          _showScrollToTopButton = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00BFFF),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            Header(
              name: widget.data['name'],
              macAddress: widget.data['mac_address'],
            ),
            const SizedBox(height: 20),
            SOCGauge(soc: widget.data['soc']),
            const SizedBox(height: 20),
            InfoContainer(
              data: widget.data,
            ),
          ],
        ),
      ),
      floatingActionButton: _showScrollToTopButton
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
    );
  }
}

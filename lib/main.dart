import 'package:flutter/material.dart';
import 'package:bms/components/Dashboards/dashboard_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Map<String, String>> topics = [
    {"name": "BMS-0", "topic_name": "bms-0"},
    {"name": "BMS-1", "topic_name": "bms-1"},
    {"name": "BMS-2", "topic_name": "bms-2"},
    {"name": "BMS-3", "topic_name": "bms-3"},
  ];

  Key _dashboardKey = UniqueKey(); // Unique key for refreshing the widget

  // Function to restart the DashboardHandler
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
      home: ScaffoldWithFAB(
        child: TopicList(
          topics: topics,
          restartDashboard: _restartDashboard,
        ),
      ),
    );
  }
}

// Scaffold with floating action button always available
class ScaffoldWithFAB extends StatelessWidget {
  final Widget child;

  const ScaffoldWithFAB({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Topic List"),
        backgroundColor: const Color(0xFF00BFFF),
      ),
      body: child,
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 25), // Adjust horizontal position
          child: FloatingActionButton(
            onPressed: () {
              // Call restartDashboard for the action
              if (child is TopicList) {
                (child as TopicList).restartDashboard();
              }
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.refresh, color: Colors.white),
            tooltip: "Restart Dashboard",
          ),
        ),
      ),
    );
  }
}

// Topic list page
class TopicList extends StatelessWidget {
  final List<Map<String, String>> topics;
  final VoidCallback restartDashboard;

  const TopicList(
      {super.key, required this.topics, required this.restartDashboard});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(topics[index]['name']!),
          subtitle: Text(topics[index]['topic_name']!),
          onTap: () {
            // Navigate to DashboardHandler and pass data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardHandler(
                  key: UniqueKey(), // Pass a new unique key for refresh
                  topics: topics,
                  initialIndex: index,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'topic.dart'; // Import the Topic model
import 'package:bms/components/Dashboards/dashboard_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Topic> topics = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _loadTopics();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString('topics');
    if (storedData != null) {
      setState(() {
        final List<dynamic> data = json.decode(storedData);
        topics = data
            .map((e) => Topic.fromMap(Map<String, String>.from(e)))
            .toList();
      });
    }
  }

  Future<void> _saveTopics() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, String>> data =
        topics.map((topic) => topic.toMap()).toList();
    await prefs.setString('topics', json.encode(data));
  }

  void _addTopic(Topic newTopic) {
    setState(() {
      topics.add(newTopic);
    });
    _saveTopics();
  }

  void _updateTopic(int index, Topic updatedTopic) {
    setState(() {
      topics[index] = updatedTopic;
    });
    _saveTopics();
  }

  void _deleteTopic(int index) {
    setState(() {
      topics.removeAt(index);
    });
    _saveTopics();
  }

  void _showCreateTopicDialog() {
    final nameController = TextEditingController();
    final topicNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text(
            "Add Topic",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: topicNameController,
                decoration: const InputDecoration(labelText: "Topic Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    topicNameController.text.isNotEmpty) {
                  _addTopic(Topic(
                    name: nameController.text,
                    topicName: topicNameController.text,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateTopicDialog(int index) {
    final nameController = TextEditingController(text: topics[index].name);
    final topicNameController =
        TextEditingController(text: topics[index].topicName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text(
            "Update Topic",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: topicNameController,
                decoration: const InputDecoration(labelText: "Topic Name"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    topicNameController.text.isNotEmpty) {
                  _updateTopic(
                    index,
                    Topic(
                      name: nameController.text,
                      topicName: topicNameController.text,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Topic List"),
        backgroundColor: const Color(0xFF00BFFF),
        actions: [
          IconButton(
            onPressed: _showCreateTopicDialog,
            icon: const Icon(Icons.add),
            tooltip: "Add Topic",
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _animationController,
        child: topics.isEmpty
            ? const Center(
                child: Text(
                  "No Topics Available",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, _) =>
                                DashboardHandler(
                              key: UniqueKey(),
                              topics:
                                  topics.map((topic) => topic.toMap()).toList(),
                              initialIndex: index,
                            ),
                            transitionsBuilder: (context, animation, _, child) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(topics[index].name),
                        subtitle: Text(topics[index].topicName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showUpdateTopicDialog(index),
                              tooltip: "Edit Topic",
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteTopic(index);
                              },
                              tooltip: "Delete Topic",
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
